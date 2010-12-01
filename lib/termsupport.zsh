typeset -A host_repr_txt
# define compact hostnames here. wish I could deduce this from host_repr
host_repr_txt=('dieter-ws-a7n8x-arch' "ws" 'dieter-p4sci-arch' "p4")

local hostp="@${host_repr_txt[$(hostname)]:-$(hostname)}"

case "$TERM" in
  xterm*|rxvt*)
    preexec () {
      print -Pn "\e]0;%n${hostp} $1\a"  # xterm
    }
    precmd () {
      print -Pn "\e]0;%n${hostp} %~\a"  # xterm
    }
    ;;
  screen*)
    preexec () {
      local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
      echo -ne "\ek$CMD\e\\"
      print -Pn "\e]0;%n${hostp} $1\a"  # xterm
    }
    precmd () {
      echo -ne "\ekzsh\e\\"
      print -Pn "\e]0;%n${hostp} %~\a"  # xterm
    }
    ;;
esac
