# zsh-prioritize-cwd-history

_Prioritizes history entries executed from the current working directory._

<a href="https://asciinema.org/a/7o75n5k4dmmr6aywc84e20ll9" target="_blank"><img src="https://asciinema.org/a/7o75n5k4dmmr6aywc84e20ll9.png" width="500" /></a>


## Installation

### Manual

1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh/zsh-prioritize-cwd-history`.

    ```sh
    git clone git://github.com/ericfreese/zsh-prioritize-cwd-history ~/.zsh/zsh-prioritize-cwd-history
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/zsh-prioritize-cwd-history/zsh-prioritize-cwd-history.zsh
    ```

3. Start a new terminal session.


### Oh My Zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)

    ```sh
    git clone git://github.com/ericfreese/zsh-prioritize-cwd-history $ZSH_CUSTOM/plugins/zsh-prioritize-cwd-history
    ```

2. Add the plugin to the list of plugins for Oh My Zsh to load:

    ```sh
    plugins=(zsh-prioritize-cwd-history)
    ```

3. Start a new terminal session.


## Usage

When you change directories, the zsh history list will be updated to show commands entered in the current working directory before commands executed in other directories.

**Note:** This plugin is not retroactive. History entries created before installing this plugin will not be tied to any particular directory, and will not ever be prioritized.


## Configuration

You may want to override the default global config variables after sourcing the plugin. Default values of these variables can be found [here](src/config.zsh).

**Note:** If you are using Oh My Zsh, you can put this configuration in a file in the `$ZSH_CUSTOM` directory. See their comments on [overriding internals](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-internals).


### History Directory

You can configure the location where history metadata will be saved by setting the `$ZSH_PRIORITIZE_CWD_HISTORY_DIR` global variable after sourcing this plugin.

For example:

```shell
ZSH_PRIORITIZE_CWD_HISTORY_DIR=~/my/special/dir
```


## Troubleshooting

If you have a problem, please search through [the list of issues on GitHub](https://github.com/ericfreese/zsh-prioritize-cwd-history/issues) to see if someone else has already reported it.


### Reporting an Issue

Before reporting an issue, please try temporarily disabling sections of your configuration and other plugins that may be conflicting with this plugin to isolate the problem.

When reporting an issue, please include:

- The smallest, simplest `.zshrc` configuration that will reproduce the problem.
- The version of zsh you're using (`zsh --version`)
- Which operating system you're running


## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.

2. Remove the git repository from your hard drive

    ```sh
    rm -rf ~/.zsh/zsh-prioritize-cwd-history # Or wherever you installed
    ```


## Development

### Build Process

Edit the source files in `src/`. Run `make` to build `zsh-prioritize-cwd-history.zsh` from those source files.


### Pull Requests

Pull requests are welcome! If you send a pull request, please:

- Match the existing coding conventions.
- Include helpful comments to keep the barrier-to-entry low for people new to the project.


## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.
