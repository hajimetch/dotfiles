# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.

# run ~/.bashrc when login
test -r ~/.bashrc && . ~/.bashrc

# added by user
export LANG=ja_JP.UTF-8
export PIPENV_VENV_IN_PROJECT=1
. /usr/local/opt/asdf/libexec/asdf.sh

