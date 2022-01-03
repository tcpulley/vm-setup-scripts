#!/usr/bin/env bash

# Fail if an error occurrs
set -e


if [ $EUID == 0 ]
then
   echo -e '\n\n!!!! Do NOT run this script with sudo !!!!\n\nDoing so would install pyenv in /root which is probably not your intention.\n\n'
   exit 1
fi

#
echo -e \\n\\n***** Install packages needed to install pyenv and to build python versions\\n\\n
#
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git


#
echo -e \\n\\n***** Installing PyEnv\\n\\n
#
curl https://pyenv.run | bash

#
echo -e \\n\\n***** Updating .bashrc\\n\\n

# Insert commands to add PyEnv to the beginning of the path and init completions and VirtualEnv
# NOTE: You must enclose the HereDoc identifier in strong quotes (single quotes) to keep  "$(pyenv xxx)"" from being executed
cat <<'EndCfgUpdate'  >> ~/.bashrc 

# >>> PyEnv Init and Config
export PATH="/home/tcpulley/.pyenv/bin:$PATH" 
eval "$(pyenv init --path)"         # Init the Path
eval "$(pyenv init -)"              # Init Completions
eval "$(pyenv virtualenv-init -)"   # Init Virtual Environss
# <<< PyEnv Config
EndCfgUpdate



echo -e \\n\\n***** Run the following command to enable pyenv in the current shell\\n\\n\\texec \$SHELL\\n\\n
