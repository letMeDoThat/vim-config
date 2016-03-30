#!/bin/bash

declare -a __saved_dirs__
declare -a __cd_history__

function saved()
{
  if [[ $# = 0 ]]; then
    if [[ ${#__saved_dirs__[@]} = 0 ]]; then
      echo "No directories saved"
    fi
    for ((i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i)) ; do
      printf "%4d  %s\n" "$i" "${__saved_dirs__[$i]}"
    done
  else
    local dir
    for dir in "$@"; do
      if [[ $dir =~ ^-[0-9]+$ ]]; then
        local num="${dir:1}"
        if [[ $num -gt ${#__cd_history__[@]} ]]; then
          echo "No entry $num in history"
          return
        else
          dir="${__cd_history__[$num]}"
        fi
      elif [[ $dir == "-" && -n $OLDPWD ]]; then
        dir="$(realpath "$OLDPWD")"
      elif [[ $dir =~ ^- ]]; then
        echo "$dir: invalid argument"
        return
      elif [[ -n $dir ]]; then
        dir="$(realpath "$dir")"
      fi
      if [[ -d $dir ]]; then
        for saved_dir in "${__saved_dirs__[@]}"; do
          if [[ $saved_dir = $dir ]]; then
            echo "$dir : already saved"
            return
          fi
        done
        echo "$dir"
        __saved_dirs__[$(( ${#__saved_dirs__[@]} + 1 ))]="$dir"
      else
        echo "$dir: No such directory" >&2
      fi
    done
  fi
}

function dropd()
{
  function repair_indexes()
  {
    if [[ -n $ZSH_VERSION ]]; then
      for (( i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i )); do
        if [[ -z $__saved_dirs__[$i] ]]; then
          __saved_dirs__[$i]=()
          (( --i ))
        fi
      done
    else
      __saved_dirs__=([0]="" "${__saved_dirs__[@]}")
      unset __saved_dirs__[0]
    fi
  }

  if [[ $# = 0 ]]; then
    if [[ -n $ZSH_VERSION ]]; then
      __saved_dirs__[1]=()
    else
      unset __saved_dirs__[1]
    fi
    repair_indexes
  else
    for arg in "$@"; do
      if [[ $arg =~ ^[0-9]+$ ]]; then
        unset '__saved_dirs__[$arg]'
      elif [[ $arg = "@" ]]; then
        unset __saved_dirs__
        declare -a __saved_dirs__
        return
      else
        echo "$arg: invalid argument"
      fi
    done
    repair_indexes
  fi

  unset -f repair_indexes
}

_list_cd_local_hist()
{
  [[ $# -eq 0 || ! $1 =~ ^[0-9]+$ ]] && return
  local hist_size="${#__cd_history__[@]}"
  local min="$(( $hist_size - $1 + 1 ))"
  min="$(( $min < 1 ? 1 : $min ))"
  for (( i = $min ; i <= $hist_size ; ++i )); do
    printf "%4d  %s\n" "$i" "${__cd_history__[$i]}"
  done
}

function cd()
{
  function add_to_hist()
  {
    local hist_size="${#__cd_history__[@]}"
    if [[ ${__cd_history__[$hist_size]} != $1 && ! -z $1 ]]; then
      __cd_history__[$(( $hist_size + 1 ))]="$1"
    fi
  }

  # $ cd --<num> 
  # go to dir saved on postition num
  if [[ $1 =~ ^--[0-9]+$ ]]; then
    local num="${1:2}"
    if [[ $num > ${#__saved_dirs__[@]} || $num -eq 0 ]]; then
      echo "No entry $num in saved directories"
    else
      local dir="${__saved_dirs__[$num]}"
      if [[ -d $dir ]]; then
        local saved_pwd="$PWD"
        if [[ $PWD != $dir ]] && builtin cd "$dir"; then
          add_to_hist "$saved_pwd"
          echo "$dir"
        fi
      fi
    fi
  # $ cd -<num>
  # go to dir on position num in history
  elif [[ $1 =~ ^-[0-9]+$ ]]; then
    local num="${1:1}"
    if [[ $num -gt ${#__cd_history__[@]} ]]; then
      echo "No entry $num in history"
    else
      local dir="${__cd_history__[$num]}"
      if [[ -d $dir ]]; then
        local saved_pwd="$PWD"
        if [[ $PWD != $dir ]] && builtin cd "$dir"; then
          add_to_hist "$saved_pwd"
          echo "$dir"
        fi
      fi
    fi
  # $ cd -h[num]|--
  # show cd history
  elif [[ $1 =~ ^-h[0-9]*$ || $1 = "--" ]]; then
    local limit
    if [[ ${1:2} =~ ^[0-9]+$ ]]; then
      limit="${1:2}"
    else
      limit=15
    fi
    _list_cd_local_hist $limit
  # just pass args (and add dir to history if needed)
  else
    local saved_pwd="$PWD"
    builtin cd "$@"
    if [[ $PWD != $saved_pwd ]]; then
      add_to_hist "$saved_pwd"
    fi
  fi

  unset -f add_to_hist
}

function local_cd_hist()
{
  if [[ $# -eq 0 || $1 =~ ^-l[0-9]+$ ]]; then
    local limit
    if [[ ${1:2} =~ ^[0-9]+$ ]]; then
      limit="${1:2}"
    else
      limit=15
    fi
    _list_cd_local_hist $limit
  elif [[ $1 =~ ^-c$ ]]; then
    unset __cd_history__
    declare -a __cd_history__
  else
    dir=$(printf "%s\n" "${__cd_history__[@]}" | grep $(printf "%s" $1 | sed 's|\*\*|.*|g' | sed 's|\([^.]\)\*|\1[^/]*|g') \
      | tail -n1)
    [[ -z $dir && $1 =~ ^[0-9]+$ ]] && dir="${__cd_history__[$1]}"
    [[ -z $dir ]] && return
    if [[ -d $dir ]]; then
      echo "$dir"
    fi
    cd "$dir"
  fi
}
