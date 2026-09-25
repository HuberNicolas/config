# config

My macOS setup: shell, editor, git and the tools I install on a new machine.
Take whatever is useful.

## What's in here

| Folder / file | What it is |
| --- | --- |
| `zsh/` | `.zshrc` (Oh My Zsh + Powerlevel10k), `.zprofile`, `.p10k.zsh` prompt config |
| `bash/`, `fish/` | Minimal profiles for the other shells (conda, LM Studio CLI) |
| `git/.gitconfig` | Name, email, `main` as default branch |
| `gh/config.yml` | GitHub CLI settings and aliases |
| `vscode/` | `settings.json` and the list of installed extensions |
| `conda/.condarc` | Conda: don't auto-activate `base` |
| `claude/skills/` | My custom [Claude Code](https://claude.com/claude-code) skills |
| `Brewfile` | Homebrew formulae, casks and VS Code extensions |

Things I use: [Oh My Zsh](https://ohmyz.sh), [Powerlevel10k](https://github.com/romkatv/powerlevel10k),
[Warp](https://www.warp.dev), VS Code with the [Viow](https://marketplace.visualstudio.com/items?itemName=youssef.viow)
theme and [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme),
Miniconda, `uv`, `pnpm`.

## Install

```bash
git clone https://github.com/nicolas-huber/config.git ~/Code/Personal/config
cd ~/Code/Personal/config
./install.sh              # symlink configs into $HOME (existing files are moved to *.backup)
./install.sh --packages   # additionally: brew bundle + VS Code extensions
```

The mapping from repo files to their place in `$HOME` lives in [`links.txt`](links.txt).
Because the files are symlinked, edits on the machine show up directly in this repo.

To refresh the generated lists (`Brewfile`, `vscode/extensions.txt`):

```bash
./update.sh
```

## Not in here

SSH keys, tokens (`gh/hosts.yml`), shell history, Docker and Claude credentials stay on the machine.

## License

[MIT](LICENSE)
