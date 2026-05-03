local M = {}

local function close_overseer()
  local ok, overseer = pcall(require, 'overseer')
  if ok then
    overseer.close()
  end
end

local function close_sidekick()
  local ok, cli = pcall(require, 'sidekick.cli')
  if ok then
    cli.hide()
  end
end

local function close_dadbod()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == 'dbui' or ft == 'dbout' then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function close_rest_nvim_result()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == 'rest_nvim_result' then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function close_aerial()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == 'aerial' then
      vim.api.nvim_win_close(win, true)
    end
  end
end

local closers = {
  overseer = close_overseer,
  sidekick = close_sidekick,
  dadbod = close_dadbod,
  rest_nvim_result = close_rest_nvim_result,
  aerial = close_aerial,
}

function M.close_others(except)
  for name, closer in pairs(closers) do
    if name ~= except then
      closer()
    end
  end
end

return M
