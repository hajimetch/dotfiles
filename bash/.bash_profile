# run ~/.bashrc when login
test -r ~/.bashrc && . ~/.bashrc

# added by user
export PYTHONPATH=/Users/hajimetch/opt/anaconda3/bin
export LANG=ja_JP.UTF-8

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/hajimetch/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/hajimetch/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/hajimetch/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/hajimetch/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

