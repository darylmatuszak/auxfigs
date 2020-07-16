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

Since auxfigs loosely couples a tool's main configuration to an auxiliary configuration, further action is not required when the auxiliary config changes.

Changes to the auxiliary configs still need to be propagated across hosts however. How this is accomplished is intentionally left open. It could be copying files by thumb drive, rsync, Dropbox , or something else.

A suggested implementation is to store your auxfigs files in a a github repo as it provides a convenient way to get your configs from any internet connected host and additionally provides source control to facilitate maintaining several sets of configurations or providing the ability to rollback changes.

### COMPATIBLE OS
auxfigs should work wherever symlinks are supported and bash can access the file system where the configs are.


## USAGE:
1. clone repo on machine where you want to run
1. `cd` into repo
1. create a symlink pointing `aux_configs` to a directory of your choosing (this only needs to be done once)
1. Add/edit files in the aux_configs directory (or link target) as needed. See FILE-STRUCTURE for details
1. `make install` will perform the linking (this also only needs to be done once per new config)

### WHAT IT DOES
When installing operation goes as follows (repeated for each set of files)
1. auxfigs creates the main file (if it does not already exist)
2. auxfigs modifies the main file to source/include the auxiliary file (only if it does not already do so)

----

## TESTING:
1. Clone repo to localhost
1. `cd` into repo
1. Ensure `bats` is accessible in your path https://github.com/bats-core/bats-core
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
* Currently there is no removal, but operation is idempotent, so re-running without changes to `aux_configs` directory will inform you precisely what is sourced from where, which you can then use to manually the edit the appropriate files to remove any linkings as you see fit.
* For any configurations which you don't want to link to on the machine you are using, you can remove the extension from the `.aux` file and it will be ignored when installing. You do not have to move or edit the associated `.main` or `.template` files. If you later want to later link that config, re-attaching the removed `.aux` extension would include it for installation.
* Having an auxfig for a tool that isn't installed usually isn't a problem (it would merely be creating a file that isn't used). If the tool doesn't overwrite the main config on installation, your settings may already be in place. If not, you can always rerun auxfigs.
