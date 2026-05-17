<div align="center">
  <p align="center">
      <img align="center" height=100 widht=120 src="https://github.com/user-attachments/assets/9d83e5d9-b491-42f1-a0e4-b278391023ac">
  </p>
</div>

# LightNotes.nvim

LightNotes is a plugin for neovim, that allows you take notes in a very
simplistic nature by "attaching" a note to a file or a so called "scope".
It allows you to take notes in one of two ways "global" and "scoped".

<img width="1000" height="800" alt="Image" src="https://github.com/user-attachments/assets/ec7a3069-ac95-4943-89fc-75ee1ee64aa1" />

# AI-Disclaimer
As the topic seems to be very polarizing, I would like disclose here, that no
AI was involved in the creation of the code and documentation of  plugin. I
have only used generative AI to create the logo, you can see on the
repositories github page.

Any bugs, issues or weird behavior you might encounter have been produced 100 %
biologically :D

# Installation

## vim.pack

``` lua
    vim.pack.add({
        { src = "https://github.com/BellCrow/lightNotes.nvim", version = "master" },
    })
    local lightNotes = require("lightNotes")
    -- if you want you can supply a custom config via the setup call
    lightNotes.setup({ notes_directory = "~/lightNotesDemo/notes", log_level = 1 })

```

> [!INFO]
> Make sure to call `:helptags ALL` after installation to create a regularly
> browsable help for neovim

The demo shown here was done using these keybinds

``` lua
    vim.keymap.set("n", "<leader>ng", lightNotes.toggle_global_note, { desc = "LightNotes: Opens the global note" })

    vim.keymap.set("n", "<leader>nb", lightNotes.toggle_branch_scoped_note, {
        desc = "LightNotes: Opens a note scoped to the branch of the current git repo. Fails if you are not in a git repository",
    })

    vim.keymap.set("n", "<leader>np", lightNotes.toggle_repo_scoped_note, {
        desc = "LightNotes: Opens a note scoped to the current repository. Fails if you are not in a git repository",
    })

    vim.keymap.set("n", "<leader>nn", lightNotes.close_note, {
        desc = "LightNotes: Closes an existing float window if there is one. It's supposed to be a nicer shortcut,"
            .. " than pressing the same shortcut as the one use to open the current note",
    })

    -- this is an example for a custom scoped note
    -- that creates notes soped to a single file
    local function file_scoped_note(file_path)
        vim.print("Gotten file path: " .. file_path)
        local identifier = lightNotes.calcualate_hash(file_path)
        return identifier, identifier
    end

    vim.keymap.set("n", "<leader>nf", function()
        lightNotes.custom_scope(file_scoped_note)
    end)
```

# Scopes

There are two different kinds of notes lightNotes supports.

## Global note
There is a single so called global note. This note is
unique for your nvim config (so the value you have set via the configuration).
It will be same no matter what files/directories you are editing with nvim.

## Scoped notes
Scoped notes are "attached" to a certain scope that exists during an nvim
session. The scopes are always calculated based on the currently edited buffer
(which should be a file).

There are two predefined scopes you can use

* repository scope
* branch scope

You can also create custom scopes if you want.
See the vim help doc for examples.


# Integrations
The plugin relies on the ability to retrieve a file path for the active
buffer. If you are just working on any "real" file that is not a problem,
as there should be a backing file in your file system.
However if you are for instance in a file explorer like oil.nvim there
might not be a backing file, but there is still a valid filepath, that can be retrieved.

So at the moment, there is support for:

* oil.nvim: will act as if the selected file is the current file

As I'm not using every plugin, I cannot support all of them. If you want to add
additional integrations like for oil.nvim you can add them in the same file
where the oil integration is and create a pull request.

# When you should not use this plugin
Every note in lightNotes, is stored as a regular .txt file in a configurable
notes directory. However that means these files need to get a name. This name
is not directly specified by the user, but is calculated based on the context
from which lightNotes was invoked. This is an acceptable tradeoff for me
at the moment. I just wanted to have the ability to spawn a note window
and take some notes about what im currently working on and also be able
to recall the same data at the same place.

So if its important to you to have a certain folder structure for your notes or well named
notes files, you would have to invest some time to add your own scopes to the
plugin or you should just use an alternative plugin.



# Notes (unstructured thoughts)
- if you write a function to convert a file path to a hash value, take into consideration, that you might
  have buffers, that might not have a easy to handle path. like the nvim help for instance.
  Or you have a buffer open, that resolves to a path, that you did not expect.

