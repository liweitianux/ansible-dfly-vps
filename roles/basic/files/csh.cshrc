#
# /etc/csh.cshrc
# csh/tcsh resource script, read at beginning of execution by each shell
#
# Aaron LI
#

setenv  EDITOR  vi
setenv  PAGER   less

# Locale
# NOTE: mosh (https://github.com/mobile-shell/mosh) requires UTF-8.
# NOTE: login.conf(5) is ignored by SSH since it handles the login by its own
setenv  LANG        en_US.UTF-8
setenv  MM_CHARSET  UTF-8
setenv  LC_COLLATE  C

if ( $?prompt ) then
    # An interactive shell
    set prompt = "%N@%m%# "
    set promptchars = "%#"
    set filec
    set history = 1000
    set savehist = (1000 merge)
    set autolist = ambiguous
    set autoexpand
    set autorehash
    set mail = (/var/mail/$USER)

    # A safer version of rm that isn't as annoying as -i
    alias rm    'rm -I'
    alias h     history 25
    alias j     jobs -l
    alias ls    ls -G  # color!
    alias la    ls -aF
    alias lf    ls -FA
    alias ll    ls -lAF

    if ( $?tcsh ) then
        bindkey    "^W" backward-delete-word
        bindkey -k up   history-search-backward
        bindkey -k down history-search-forward

        # Credit:
        # * https://stackoverflow.com/a/1912527/4856091
        # * http://www.ibb.net/~anne/keyboard/keyboard.html#Tcsh
        bindkey "\e[1~" beginning-of-line  # Home
        bindkey "\e[7~" beginning-of-line  # Home rxvt
        bindkey "\e[2~" overwrite-mode     # Insert
        bindkey "\e[3~" delete-char        # Delete
        bindkey "\e[4~" end-of-line        # End
        bindkey "\e[8~" end-of-line        # End rxvt
    endif
endif
