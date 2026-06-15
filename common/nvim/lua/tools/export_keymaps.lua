local M = {}

local modes = {
  n = "normal",
  i = "insert",
  v = "visual",
  x = "visual-block",
  s = "select",
  o = "operator-pending",
  c = "command",
  t = "terminal",
}

local function json(row)
  return vim.json.encode(row)
end

function M.export(path)
  path = vim.fn.expand(path)

  local lines = {}

  for mode, mode_name in pairs(modes) do
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      table.insert(lines, json({
        app = "nvim",
        mode = mode_name,
        key = map.lhs,
        action = map.desc or map.rhs or "<callback>",
        source = map.sid,
        noremap = map.noremap,
        silent = map.silent,
      }))
    end
  end

  vim.fn.writefile(lines, path)
  print("Exported keymaps to " .. path)
end

return M
