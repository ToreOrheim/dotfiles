local M = {}

local prompted = {}

local current_solution = function()
  local ok, mod = pcall(require, "easy-dotnet.current_solution")
  return ok and mod or nil
end

local scan_level = function(dir)
  local slns, has_project = {}, false
  local ok, handle = pcall(vim.uv.fs_scandir, dir)
  if not ok or not handle then return slns, has_project end
  while true do
    local name = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local is_sln = name:match("%.sln$") ~= nil or name:match("%.slnx$") ~= nil
    local is_proj = name:match("%.csproj$") ~= nil or name:match("%.fsproj$") ~= nil
    if is_sln or is_proj then
      local stat = vim.uv.fs_stat(vim.fs.joinpath(dir, name))
      if stat and stat.type == "file" then
        if is_sln then table.insert(slns, vim.fs.joinpath(dir, name)) end
        if is_proj then has_project = true end
      end
    end
  end
  return slns, has_project
end

local function pick_best(solutions, dir)
  if #solutions == 0 then return nil end
  if #solutions == 1 then return solutions[1] end

  local dir_name = vim.fs.basename(dir)
  local stem_matches = {}
  for _, path in ipairs(solutions) do
    local base = vim.fs.basename(path)
    local stem = base:gsub("%.slnx?$", "")
    if stem == dir_name then table.insert(stem_matches, path) end
  end

  if #stem_matches == 1 then return stem_matches[1] end

  if #stem_matches > 1 then
    for _, path in ipairs(stem_matches) do
      if path:match("%.slnx$") then return path end
    end
    return stem_matches[1]
  end

  return nil
end

local function walk_up(start_dir)
  local dir = vim.fs.normalize(vim.fn.fnamemodify(start_dir, ":p"))
  local dotnet_signal = false
  while true do
    local slns, has_project = scan_level(dir)
    if has_project then dotnet_signal = true end
    if #slns > 0 then return dir, slns, true, dotnet_signal end
    if vim.uv.fs_stat(vim.fs.joinpath(dir, ".git")) then return nil, {}, true, dotnet_signal end
    local parent = vim.fs.dirname(dir)
    if parent == dir then break end
    dir = parent
  end
  return nil, {}, false, dotnet_signal
end

local function solutions_below(start_dir, depth)
  local ok, scan = pcall(require, "plenary.scandir")
  if not ok then return {} end
  local res = scan.scan_dir(start_dir, {
    respect_gitignore = true,
    search_pattern = "%.slnx?$",
    depth = depth,
    silent = true,
  })
  return res or {}
end

local function is_dotnet_context(cwd, signal, found_at_cwd)
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype or ""
  if vim.tbl_contains({ "cs", "vb", "fsharp", "csproj", "fsproj", "sln" }, ft) then return true end
  if found_at_cwd then return true end
  return signal
end

local function get_data_dir()
  local ok, constants = pcall(require, "easy-dotnet.constants")
  if not ok then return nil end
  return vim.fs.joinpath(constants.get_data_directory(), "solutions")
end

local function skip_marker_path(cwd)
  local dir = get_data_dir()
  if not dir then return nil end
  vim.fn.mkdir(dir, "p")
  return vim.fs.joinpath(dir, "skip-" .. vim.fn.sha256(cwd))
end

local function has_skip_marker(cwd)
  local path = skip_marker_path(cwd)
  return path ~= nil and vim.fn.filereadable(path) == 1
end

local function write_skip_marker(cwd)
  local path = skip_marker_path(cwd)
  if not path then return end
  vim.fn.writefile({ cwd }, path)
end

local function clear_skip_marker(cwd)
  local path = skip_marker_path(cwd)
  if path and vim.fn.filereadable(path) == 1 then vim.fn.delete(path) end
end

function M.select(path)
  local cs = current_solution()
  if not cs then return false end
  local ok = pcall(cs.set_solution, path)
  if ok then
    clear_skip_marker(vim.fn.getcwd())
    vim.notify("dotnet: selected " .. vim.fs.basename(path), vim.log.levels.INFO)
  end
  return ok
end

function M.auto_select()
  local cs = current_solution()
  if not cs then return end
  if cs.try_get_selected_solution() then return end

  local cwd = vim.fn.getcwd()
  local dir, found, in_repo, signal = walk_up(cwd)
  if not in_repo then return end

  local found_at_cwd = dir ~= nil and vim.fs.normalize(dir) == vim.fs.normalize(cwd)
  if not is_dotnet_context(cwd, signal, found_at_cwd) then return end

  if #found == 0 then
    found = solutions_below(cwd, 2)
    dir = cwd
  end
  if #found == 0 then return end

  if prompted[cwd] then return end
  if has_skip_marker(cwd) then return end

  local best = pick_best(found, dir)
  if best then
    M.select(best)
    return
  end

  prompted[cwd] = true
  local options = vim.tbl_map(function(value) return { display = value } end, found)
  local ok = pcall(require, "easy-dotnet.picker")
  if not ok then return end
  pcall(function()
    require("easy-dotnet.picker").picker(nil, options, function(chosen)
      if chosen and chosen.display then
        M.select(chosen.display)
      else
        write_skip_marker(cwd)
      end
    end, "Pick solution file", true, true)
  end)
end

local function patch_lazy_picker()
  local cs = current_solution()
  if not cs or cs._auto_solution_patched then return end
  cs._auto_solution_patched = true
  local orig = cs.get_or_pick_solution
  cs.get_or_pick_solution = function(cb)
    if cs.try_get_selected_solution() then return orig(cb) end

    local cwd = vim.fn.getcwd()
    local dir, found, in_repo = walk_up(cwd)
    if #found == 0 and in_repo then
      found = solutions_below(cwd, 2)
      dir = cwd
    end
    if #found == 0 then return orig(cb) end

    local best = pick_best(found, dir or cwd)
    if best then
      if pcall(cs.set_solution, best) then
        return coroutine.wrap(cb)(best)
      end
    end

    local options = vim.tbl_map(function(value) return { display = value } end, found)
    local ok = pcall(require, "easy-dotnet.picker")
    if not ok then return orig(cb) end
    pcall(function()
      require("easy-dotnet.picker").picker(nil, options, function(chosen)
        if chosen and chosen.display then
          if pcall(cs.set_solution, chosen.display) then
            coroutine.wrap(cb)(chosen.display)
          end
        end
      end, "Pick solution file", true, true)
    end)
  end
end

patch_lazy_picker()

return M
