# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

typeset -A host_repr
typeset -A host_repr_txt

# translate hostnames into shortened, colorcoded strings
host_repr=('dieter-ws' "%{$fg_bold[green]%}ws" 'dieter-p4sci-arch' "%{$fg_bold[blue]%}p4" 'gibran' "%{$fg_bold[yellow]%}Gi")
# define compact hostnames here. wish I could deduce this from host_repr
host_repr_txt=('dieter-ws-a7n8x-arch' 'ws' 'dieter-p4sci-arch' 'p4' 'gibran' 'Gi')

local hostp="@${host_repr_txt[$(hostname)]:-$(hostname)}"


# local time, color coded by last return code
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

# user part, color coded by privileges
local user="%(!.%{$fg[blue]%}.%{$fg[blue]%})%n%{$reset_color%}"

# Hostname part.  compressed and colorcoded per host_repr array
# if not found, regular hostname in default color
local host="@${host_repr[$(hostname)]:-$(hostname)}%{$reset_color%}"

# Compacted $PWD
local pwd="%{$fg[blue]%}%c%{$reset_color%}"

PROMPT='${time} ${user}${host} ${pwd} $(git_prompt_info)'

# i would prefer 1 icon that shows the "most drastic" deviation from HEAD,
# but lets see how this works out
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}?%{$fg[green]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n${hostp} %~"

# default oh-my-zsh strips stuff like user@host, ssh/sudo when you execute a command
# i want all that stuff to be shown normally
function preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1}
  title "%n${hostp} %~ $CMD" "%n${hostp} %~ $CMD"
}
