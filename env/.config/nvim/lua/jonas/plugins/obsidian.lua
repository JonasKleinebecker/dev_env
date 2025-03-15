function move_to_tag_folder()
  local file_path = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:t")

  local lines = {}
  for line in io.lines(file_path) do
    table.insert(lines, line)
  end

  local tag = nil
  local in_yaml_header = false
  local in_tags_section = false

  for _, line in ipairs(lines) do
    if line:match("^%-%-%-$") then
      in_yaml_header = not in_yaml_header
      if not in_yaml_header then
        break
      end
    elseif in_yaml_header and line:match("^tags:") then
      in_tags_section = true
    elseif in_tags_section and line:match("^%s*%-%s*#(%w+)") then
      tag = line:match("^%s*%-%s*#(%w+)") -- Extract the first tag
      break
    elseif in_tags_section and line:match("^%s*%S") then
      -- Exit the tags section if we encounter a non-indented line
      in_tags_section = false
    end
  end

  local obsidian_vault = "/mnt/g/Meine Ablage/Obsidian/Main_vault"
  local dest_folder = tag and obsidian_vault .. "/" .. tag or obsidian_vault .. "/untagged"

  if vim.fn.isdirectory(dest_folder) == 0 then
    vim.fn.mkdir(dest_folder, "p")
  end

  local dest_path = dest_folder .. "/" .. file_name
  os.rename(file_path, dest_path)

  vim.cmd("bd")
  print("Moved file to: " .. dest_path)
end

function create_obsidian_note(template)
  local title = vim.fn.input("Enter note title: ")

  if title == "" then
    print("Error: No title provided")
    return
  end

  local filename = title:gsub(" ", "-")

  local date = os.date("%Y-%m-%d")
  local date_filename = date .. "_" .. filename .. ".md"

  vim.cmd("ObsidianNew " .. date_filename)

  vim.cmd("lua pcall(vim.cmd, 'ObsidianTemplate " .. template .. "')")
  vim.api.nvim_buf_set_lines(0, 0, 1, false, {})      -- delete the automatically generated header
  vim.cmd("silent! execute '11s/\\(# \\)[^_]*_/\\1/'") -- remove date from template title
  vim.cmd("silent! execute '11s/-/ /g'")              -- replace dashes with spaces for template title
  vim.cmd("execute 'normal! 2o'")
  vim.cmd("startinsert")
end

function open_all_files_in_folder()
  local folder_path = "/mnt/g/Meine Ablage/Obsidian/Main_vault/inbox"

  if vim.fn.isdirectory(folder_path) == 0 then
    print("Folder does not exist: " .. folder_path)
    return
  end

  local files = vim.fn.glob(folder_path .. "/*", false, true)

  for _, file in ipairs(files) do
    vim.cmd("e " .. file)
  end

  print("Opened " .. #files .. " files from " .. folder_path)
end

function delete_current_file()
  local file_path = vim.fn.expand("%:p") -- Get the full path of the current file

  -- Confirm deletion with the user
  local confirm = vim.fn.input("Are you sure you want to delete this file? [y/N]: ")
  if confirm:lower() ~= "y" then
    print("Deletion canceled.")
    return
  end

  -- Delete the file
  local success, err = os.remove(file_path)
  if not success then
    print("Error deleting file: " .. err)
    return
  end

  -- Close the buffer
  vim.cmd("bd") -- Close the buffer
  print("Deleted file: " .. file_path)
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>or",
  ":lua open_all_files_in_folder()<CR>",
  { noremap = true, silent = true, desc = "Open all Obsidian inbox files in new buffers" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ok",
  ":lua move_to_tag_folder()<CR>",
  { noremap = true, silent = true, desc = "Move to tag folder" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>od",
  ":lua delete_current_file()<CR>",
  { noremap = true, silent = true, desc = "Delete current file" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>of",
  ":lua create_obsidian_note('fact_note')<CR>",
  { noremap = true, silent = true, desc = "Create obsidian note (fact template)" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>oq",
  ":lua create_obsidian_note('quote_note')<CR>",
  { noremap = true, silent = true, desc = "Create obsidian note (fact template)" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>oc",
  ":lua create_obsidian_note('code_note')<CR>",
  { noremap = true, silent = true, desc = "Create obsidian note (fact template)" }
)

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
  },
  opts = {
    disable_frontmatter = true,
    note_frontmatter_func = function(note)
      -- Return an empty table to prevent adding any frontmatter
      return {}
    end,
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = "main_vault",
        path = "/mnt/g/Meine Ablage/Obsidian/Main_vault",
      },
    },
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",
    templates = {
      folder = "templates",
    },
  },
}
