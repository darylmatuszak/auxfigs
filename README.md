# auxfigs
For loosely coupling application config files

## PURPOSE
auxfigs assists in ensuring your preferred installation-independent settings for one or more tools are always in effect across multiple hosts.

## PREREQUISITES

### COMPATIBLE TOOL(S)
auxfigs makes the assumption that the tool(s) you are looking to configure supports:
* reading settings from a plain-text configuration file
* has some syntax/methodolgy for dynamically sourcing or including content from another file.

Tools that do no operate in such a manner will not be compatible with auxfigs.

auxfigs was designed with the likes of vim, tmux, bash, git, in mind, but any application that meets the above assumption should theoretically be compatible.

### SOURCE CONTROL OR SYNC METHOD FOR CONFIGURATIONS

Since auxfigs loosely couples a tool's main configuration to an auxiliary configuration, further action is not required when the auxiliary config (.aux file) changes.

Changes to the auxiliary configs still need to be propagated across hosts however. How this is accomplished is intentionally left open. It could be copying files by thumb drive, rsync, Dropbox , or something else.

A suggested implementation is to store your auxfigs files in a a github repo as it provides a convenient way to get your configs from any internet connected host and additionally provides source control to facilitate maintaining several sets of configurations or providing the ability to rollback changes.

### COMPATIBLE OS
auxfigs should work wherever symlinks are supported and bash can access the file system where the configs are.


## USAGE:
### First Time Setup
1. clone repo on machine where you want to run
1. `cd` into repo
1. create a symlink pointing `aux_configs` to a directory of your choosing (this only needs to be done once)
1. Add/edit files in the aux_configs directory (or link target) as needed. See FILE-STRUCTURE for details

Before linking or unlinking it is recommended to ensure all tests pass (see TESTING)

### Linking
1. `make install` will perform the linking (this also only needs to be done once per new config)

### Unlinking
Before unlinking, see NOTE ABOUT UNLINKING
1. `make remove` will remove any previously peformed linking. ALWAYS UNLINK before changing .template or .main files (see NOTE ABOUT UNLINKING)

### WHAT IT DOES
When installing operation goes as follows (repeated for each set of files)
1. auxfigs creates the main file (if it does not already exist)
2. auxfigs modifies the main file to source/include the auxiliary file (only if it does not already do so)

Whe removing operation goes as follows
1. auxfigs checks if the main file exists (if it does not it moves on to next fileset silently)
1. auxfigs checks to see if the string it would insert to link the config is present. if so it backs up the file in place, and then removes the string.

----

## TESTING:
1. Clone repo to localhost
1. `cd` into repo
1. Install [bats](https://github.com/bats-core/bats-core) to be accessible from your path OR if you have git you can run `git submodule init && git submodule update` to make it acessible for just auxfigs
1. `make` to run tests

----

## FILE-STRUCTURE
For each configuration <NAME> want to link, there are three files required.
1. `<NAME>.aux`
1. `<NAME>.main`
1. `<NAME>.template`

All files must be present in the directory that is the target of `aux_configs`. <NAME> is used to match the triplets together and so much be identical.

### .aux File
  This is the actual configuration file you want to be sourced/included/loaded. It's content has no relation to auxfigs, only its name and location.

### .main File
  This file should contain 1 line only, the absolute path to the configuration file that should be edited to source the .aux file of matching <NAME>.


### .template File
This file should contain 1 line only, the template string to be used in sourcing your auxiliary config. The content for this will vary depending on the type of configuration file, but they key is to include `aauuxx__ccoonnff` where the absolute path to your aux config should go.

#### Example
You want `/home/drl/.vimrc` to source `/home/drl/git/portable/vimrc.aux`. The directy target of the `aux_configs` symlink should look like this:

```
./vimrc.aux
./vimrc.main
./vimrc.template
```

**.aux content**

Its content should be whatever you want in your vimrc. The content is not related to auxfigs in any way.

**.main content**  

```/home/drl/.vimrc```

or perhaps instead

```${HOME}/.vimrc```

**.template content**

To include another config file in a `.vimrc` file the syntax is `source <CONFIG_FILE>` So it would be

```source aauuxx__ccoonnff```


----

## TIPS
* Once linked, changes to .aux files (manually or via some syn mechanism) do not require any action from the user to go into effect
* If making changes to .template or .main files you should first unlink them, then make the changes, and then relink them. Failure to do so could require some manual clean up.
* Operation is idempotent, so re-running without changes to the `aux_configs` directory will have no effect.
* For any configurations which you don't want to link to on the machine you are using, you can remove the extension from the `.aux` file and it will be ignored when installing. You do not have to move or edit the associated `.main` or `.template` files. If you later want to later link that config, re-attaching the removed `.aux` extension would include it for installation. (This appplies similarly if you want to run remove, but leave some configs linked)
* Having an auxfig for a tool that isn't installed usually isn't a problem (it would merely be creating a file that isn't used). If the tool doesn't overwrite the main config on installation, your settings may already be in place. If not, you can always rerun auxfigs.

## NOTE ABOUT UNLINKING
auxfigs does not mantain any history state, so unlinking only operates on the current state of the `aux_configs` directory. Consider it the opposite of linking. Instead of inserting the generated template string, it removes it. If the template or the target of main has changed since linking was run, it is not the opposite. If you accidentally change a .template or main and link wihtout unlinking first, you can immediatly unlink (to undo the newest change) and then restore your template and/or main files to their previous state and unlink. Then make the change again, and relink.
