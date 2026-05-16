# Changelog
This changelog adheres to (keepAChangelog)[https://keepachangelog.com/en/1.1.0/]

## [Unreleased]

### Added
#### Custom note file extension
Thanks to users *tomeczku* and *sandman_313* on the nvim subreddit for proposing: 
Added a config entry, allowing the user to specify the extension of the note
files. User can have markdown notes this way for instance

##### Migration
As the file names change with a new extension you need to migrate the extension
of all your notes to .md if you want to keep using your old notes otherwise the
plugin will think that a note with the same hash, but different extension, are
NOT the same note. I dont want to automatically do such big changes to your
notes directory.

If you are using bash you can use something like this to rename the notes in
you notes folder:

```
    for file in *.txt; do mv $file $(basename $file .txt).md; done
```

> [!WARNING]  
> Obligatory terminal command disclaimer: You should not just execute any bash
> command you find online just like that. Try to understand what this does
> before executing it. If you want to you can have an AI explain it to you.
> 
> As this is a mass file operation I advice you to backup your notes repository
> before executing this. Just in case.

### Fixed
Thanks to user *badabblubb* on the nvim subreddit for the feedback:
Converted a bunch of functions, that are only used inside the plugin
into modules. That way the global functions I have declared no longer
pollute the user global namespace and will no longer be pollute or even
override functions defined by the user or nvim.

#### 
## [Initial Release]
### Added
- taking global notes
- taking scoped notes
- offer custom scopes and helper functions for it
- user facing config
