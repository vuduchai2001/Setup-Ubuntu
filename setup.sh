#!/bin/bash

exit_status() {
  if [ $? -eq 0 ]; then
    echo
    echo "***   Command Execution Was Successful.   ***"
    echo
    source ~/.bashrc
  else
    echo
    echo "-------------------------------------------------------"
    echo "     [Error] Process Command Execution Has Failed!     "
    echo "-------------------------------------------------------"
    echo

    read -p "The last command has exited with an error. Exit script? (Yes/no)" answer
    if [ "$answer" == "yes" || "$answer" == "y" || -z "$answer" ]; then
      exit 1
    fi
  fi
}

msg() {
  message=$1
  echo
  echo "--------------------------------------------"
  echo "***>>> $message <<<***"
  echo "--------------------------------------------"
  echo
}

exitUpdate() {
  clear
  echo
  echo "-------------------------------------------------------"
  echo ">>>>   Operating System Update Has Been Completed  <<<<"
  echo "-------------------------------------------------------"
  echo
  source ~/.bashrc
  exec zsh
}

#UpdateOS
updateOS() {
  msg "Initialization Update Operating System"
  #
  sudo apt update
  exit_status

  sudo apt upgrade -y
  exit_status

  sudo apt install git
  exit_status

  sudo apt install curl
  exit_status
}

#Install NodeJS
installNode() {
  msg "Start Install NodeJS"
  #
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  exit_status

  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if command -v nvm &>/dev/null; then
    nvm install v18.17.1
  else
    echo "Failed to load nvm"
  fi
}

#Install Docker
installDocker() {
  msg "Start Install Docker"
  #
  sudo apt update

  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  exit_status

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt update
  apt-cache policy docker-ce

  sudo apt install docker-ce -y
  exit_status

  sudo systemctl status docker --no-pager
  exit_status

  mkdir -p ~/.docker/cli-plugins/
  curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
  exit_status

  chmod +x ~/.docker/cli-plugins/docker-compose
  sudo usermod -aG docker ${USER}
  exit_status
}

#Install VsCode
installVSCode() {
  if [ -n "$WSL_DISTRO_NAME" ]; then
    msg "Running in WSL"
    msg "VSCode will not be installed"
  else
    msg "Running on Ubuntu (non-WSL)"
    msg "Start Install VSCode"
    #
    sudo apt update
    sudo apt install software-properties-common apt-transport-https wget -y
    exit_status

    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    exit_status

    echo | sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    exit_status

    sudo apt install code -y
    exit_status

  fi
}

####################################

#Install Zsh
installZSH() {
  msg "Start Install Zsh"
  #
  sudo apt update
  sudo apt install zsh -y
  exit_status

  chsh -s $(which zsh)

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  exit_status

}

##################################
updateOS
installNode
installDocker
installVSCode
#installZSH
exitUpdate
