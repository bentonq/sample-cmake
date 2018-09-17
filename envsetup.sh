# 本文件只能在bash终端用 "source envsetup.sh" 的方式执行，直接执行这
# 个脚本是无效的。
# This file must be used with "source envsetup.sh" *from bash*
# you cannot run it directly

# 本脚本的源代码来之python virtualenv与android aosp中的编译脚本。
# The source code of this script comes from the python virtualenv and the 
# build script from android aosp.

# 本脚本具有一下功能和命令：
# 1. - cmake: 命令全部带有-DCMAKE_INSTALL_PREFIX参数，指定install目录为out目录，而不是
#             /usr/local目录。
# 2. - croot: 进入当前项目的根目录。

# This script adds some command and aliases the cmake command.
# 1. - cmake: Command has -DCMAKE_INSTALL_PREFIX arg by default，it specifies 
#             the install folde to out，not the old one: /usr/local.
# 2. - croot: Changes directory to the top of the tree.

function deactivate () 
{
    # reset old environment variables
    if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="${_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _OLD_VIRTUAL_PATH
	    unalias cmake
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
        hash -r
    fi

    if [ -n "${_OLD_VIRTUAL_PS1:-}" ] ; then
        PS1="${_OLD_VIRTUAL_PS1:-}"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
    unset -f gettop
    unset -f croot
    if [ ! "$1" = "nondestructive" ] ; then
    # Self destruct!
        unset -f deactivate
    fi
}

# unset irrelevant variables
deactivate nondestructive

VIRTUAL_ENV="$PWD/out"
export VIRTUAL_ENV

_OLD_VIRTUAL_PATH="$PATH"
PATH="$VIRTUAL_ENV/bin:$PATH"
export PATH

alias cmake='cmake -DCMAKE_INSTALL_PREFIX=$VIRTUAL_ENV'

function gettop
{
    local TOPFILE=envsetup.sh
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function croot()
{
    T=$(gettop)
    if [ "$T" ]; then
        \cd $(gettop)
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT:-}" ] ; then
    _OLD_VIRTUAL_PS1="${PS1:-}"
    if [ "x(env) " != x ] ; then
	PS1="(env) ${PS1:-}"
    else
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        # special case for Aspen magic directories
        # see http://www.zetadev.com/software/aspen/
        PS1="[`basename \`dirname \"$VIRTUAL_ENV\"\``] $PS1"
    else
        PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"
    fi
    fi
    export PS1
fi

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the $PATH changes we made may not be respected
if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
    hash -r
fi
