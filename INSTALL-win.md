# Installation

In order to install all the necessery dependecies for the build system the
`setup.ps1` `PowerShell` script is provided. It mainly uses `scoop`, a popular
package manager, to install all the software you need. You should clone the
repo in your preffered way, e.g.

```bash
git clone https://gitlab.com/nikoloc-fsra/fsra-build-system.git
```

and once thats done navigate to it in a `PowerShell` session. `PowerShell` should
NOT be run as an administrator. Once there just run

```bash
.\setup.ps1
```

If the script fails for any reason, you should save the logs and either try to
fix it and inform the team of the problem and the solution you found, or contact
others to get help. Anyhow, it is important to have the issue documented for the
future use.

If the script succeeds, you should see the message `setup complete`.

## Troubleshooting

### Commands not found after running the install script

You need to restart your sessions, e.g. if `VSCode` was opened before you ran
the script in PowerShell, you need to restart `VSCode` in order for it to pick
up your new `PATH` variables.

### After building the project, LSP only partially works inside `VSCode`

You need to disable the default `Microsoft's Intellisense for C/C++`, and instead
use the `Clangd` extension that can be found in the store. Restarting the `VSCode`
may be needed.
