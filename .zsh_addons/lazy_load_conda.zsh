# Add any commands which depend on conda here
lazy_conda_aliases=('python' 'conda')

load_conda() {
    for lazy_conda_alias in $lazy_conda_aliases
    do
        unalias $lazy_conda_alias
    done

    __conda_prefix="$HOME/.miniconda3" # Set your conda Location

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/Users/joe8922/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/joe8922/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/joe8922/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/joe8922/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    unset __conda_prefix
    unfunction load_conda
}

for lazy_conda_alias in $lazy_conda_aliases
do
    alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
done
