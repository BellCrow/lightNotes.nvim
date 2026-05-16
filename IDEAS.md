# General Ideas 
Genral ideas about features or bugs to fix are listed in this file

* add a config options to write on every buffer change. that way the user will not be asked if they want to save the 
  note data if they try to close everything with `:qa` if they currently have a notes window open

* offer to open the notes also as a regular buffer and not only as a float window
    * I just personally prefer float windows, because they feel "detached" from the rest
      of the project that you are really working on

* find a way to have the cursor position be restorable(of course configurable by the user) for the notes

* big issue at the moment is the exclusive usage of a hashing function for the file names. it makes it impossible to do picking based on the file names
    * maybe i should make the hash only be part of the file name, in order to ensure uniqueness for the file names ?
        * would make it possible to do fuzzy searching
        * something like fileName_hash.txt
            * but how is the fileName part determined ?
