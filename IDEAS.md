# General Ideas 
Genral ideas about features or bugs to fix are listed in this file

* add a config options to write on every buffer change. that way the user will not be asked if they want to save the 
  note data if they try to close everything with `:qa` if they currently have a notes window open

* offer to open the notes also as a regular buffer and not only as a float window
    * I just personally prefer float windows, because they feel "detached" from the rest of the project the you are really working on

* maybe offer optional and opinionated keybinds ? 
    * current plan is to have
        * `<leader>ng` for the global note
        * `<leader>np` for the scoped note

* offer different ready to use scoped note hashing functions. would be good to have one for
    * project scoped note, that is created with the (custom) root of the project
    * branch based note, that incorporates the root path and the current branch name
    * file scoped note based on path of the file
        * this might be really unstable, if you refactor file names or locations a lot, but if user wants to use that I can just warn them
    * offer a hook, where the user can also just register a custom function ?

