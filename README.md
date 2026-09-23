# snn-soc

## Installation

### Windows 10 and 11

1) Make sure your version of Windows is up-to-date. You must be running Windows 10 (Build 19041 and higher) or Windows 11.
2) Install [VS Code](https://code.visualstudio.com/Download). Once VS Code is installed, go [here](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) and install the Remote Development extension.
3) Open Command Prompt as *Administrator* and enter `wsl --install Ubuntu-22.04 --name snn-env` to enable Windows Subsystem for Linux (WSL) with Ubuntu 22.04.
4) Wait for the distribution to finish installing, then follow the prompts to setup a username and password.
5) Download [Windows Terminal](https://aka.ms/terminal) for an improved terminal experience.
6) Open Windows Terminal and make a new Ubuntu 22.04 terminal. The username on the left should be `<username>@<machine-name>`. If it is `root@<machine-name>`, something has gone wrong, and you should ask a teaching assistant for help.
7) Inside the Ubuntu terminal, enter

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/Mik3-d3v/snn-soc/main/tools/install.sh)
    ```

    You may have to enter your password a few times while everything installs. Windows may also ask for administrator access.

    Depending on your Internet connection, this may take up to 15 minutes.
8) VS Code should automatically open after the previous step. If not, open the *workspace* at `~/Documents/iac/lab0-devtools/autumn/workspace/iac-autumn.code-workspace`. To do this, open an Ubuntu 22.04 terminal and type `code`; doing this opens a [VS Code instance inside Ubuntu](https://code.visualstudio.com/docs/remote/wsl#_getting-started) rather than Windows. When VS Code opens, select "File->Open Workspace from File...", then navigate to the workspace file. You can also do this by typing the following command in an Ubuntu 22.04 terminal:

   ```bash
   code ~/Documents/iac/lab0-devtools/autumn/workspace/iac-autumn.code-workspace
   ```

9) Open a terminal inside the VS Code workspace (`Ctrl`+`J`). Enter the following command into the terminal to install the required extensions:

    ```bash
    ~/Documents/iac/lab0-devtools/tools/extensions.sh
    ```

10) Follow the instructions in the [toolchain project](https://github.com/EIE2-IAC-Labs/Lab0-devtools/blob/main/autumn/workspace/toolchain) to test that your tools are functioning correctly. This folder is already downloaded and can be found in your VS Code workspace you just opened.