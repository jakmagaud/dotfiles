# ZSH Theme - Preview: https://raw.githubusercontent.com/KorvinSilver/blokkzh/master/preview.png
# Mod of the gnzh theme

setopt prompt_subst

(){

    local PR_USER PR_USER_OP PR_PROMPT PR_HOST PR_AT
    local userName hostName atSign promptSign
    local returnSymbol promptSymbolFrom promptSymbolTo promptSymbol rvmSymbol

# Switch to ASCII characters in Linux term
    if [[ ${TERM} == "linux" ]];
    then
        returnSymbol='<<'
        promptSymbolFrom='/-'
        promptSymbolTo='\-'
        promptSymbol='>'
        rvmSymbol='%F$FG[009]rvm%f'
        ZSH_THEME_GIT_PROMPT_PREFIX='-[%F$FG[011]git '
        ZSH_THEME_GIT_PROMPT_SUFFIX='%f]'
        ZSH_THEME_VIRTUALENV_PREFIX='-[%F$FG[010]python '
        ZSH_THEME_VIRTUALENV_SUFFIX='%f]'
    else
        returnSymbol='↵'
        promptSymbolFrom='┌─'
        promptSymbolTo='└─'
        promptSymbol='➤'
        rvmSymbol='%F$FG[009]🔻%f'
        ZSH_THEME_GIT_PROMPT_PREFIX='─[%F$FG[011] '
        ZSH_THEME_GIT_PROMPT_SUFFIX='%f]'
        ZSH_THEME_VIRTUALENV_PREFIX='─[%F$FG[010]🐍 '
        ZSH_THEME_VIRTUALENV_SUFFIX='%f]'
    fi

# Check the UID
    if [[ $UID -ne 0 ]]; then # normal user
        PR_USER='%F$FG[013]%n%f'
        PR_USER_OP='%F$FG[011]%#%f'
        PR_PROMPT="${promptSymbol}"
        PR_AT='@'
    else # root
        PR_USER=''
        PR_USER_OP=''
        PR_PROMPT="%F$FG[009]${promptSymbol}%f"
        PR_AT=''
    fi

# Check if we are on SSH or not
    if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
        if [[ $UID -eq 0 ]]; then
            PR_HOST='%B%F$FG[125]%M%f%b' # SSH, root
        else
            PR_HOST='%F$FG[013]%M%f' # SSH, normal user
        fi
    elif [[ $UID -eq 0 ]]; then
        PR_HOST='%B%F$FG[009]%M%f%b' # no SSH, root
    else
        #PR_HOST='%F{cyan}%M%f' # no SSH, normal user
        PR_HOST='%F$FG[014]%M%f' # no SSH, normal user

    fi

    local return_code="%(?..%F{red}%? ${returnSymbol}%f)"

    local user_host="${PR_USER}${PR_AT}${PR_HOST}"
    local current_dir="%B%F$FG[093]%~%f%b"
    local rvm_ruby=''
    if ${HOME}/.rvm/bin/rvm-prompt &> /dev/null; then # detect user-local rvm installation
        rvm_ruby='─['${rvmSymbol}' %F{red}$(${HOME}/.rvm/bin/rvm-prompt i v g s)%f]'
    elif which rvm-prompt &> /dev/null; then # detect system-wide rvm installation
        rvm_ruby='─['${rvmSymbol}' %F{red}$(rvm-prompt i v g s)%f]'
    elif which rbenv &> /dev/null; then # detect Simple Ruby Version Management
        rvm_ruby='─['${rvmSymbol}' %F{red}$(rbenv version | sed -e "s/ (set.*$//")%f]'
    fi

    local git_branch='$(git_prompt_info)'
    local venv_python='$(virtualenv_prompt_info)'

    PROMPT="${promptSymbolFrom}[${user_host}]${rvm_ruby}${venv_python}─[${current_dir}]${git_branch}
${promptSymbolTo}$PR_PROMPT "

    RPROMPT="${return_code}"
}
