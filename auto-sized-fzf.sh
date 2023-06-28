#!/usr/bin/env bash

# -- check to see if we were sourced --

(
  [[ -n $ZSH_VERSION && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)
) && sourced=1 || sourced=0

# -- Default configurations: --

if [ -z "$FZF_SIZER_VERTICAL_THRESHOLD" ]; then
  export FZF_SIZER_VERTICAL_THRESHOLD="2.0"
fi

if [ -z "$FZF_SIZER_VERTICAL_PREVIEW_LOCATION" ]; then
  export FZF_SIZER_VERTICAL_PREVIEW_LOCATION="bottom"
fi

if [ -z "$FZF_SIZER_HORIZONTAL_PREVIEW_LOCATION" ]; then
  export FZF_SIZER_HORIZONTAL_PREVIEW_LOCATION="right"
fi

if [ -z "$FZF_SIZER_HORIZONTAL_PREVIEW_PERCENT_CALCULATION" ]; then
  export FZF_SIZER_HORIZONTAL_PREVIEW_PERCENT_CALCULATION='max(50, min(80, 100 - ((7000 + (11 * __WIDTH__))  / __WIDTH__)))'
fi

if [ -z "$FZF_SIZER_VERTICAL_PREVIEW_PERCENT_CALCULATION" ]; then
  export FZF_SIZER_VERTICAL_PREVIEW_PERCENT_CALCULATION='max(50, min(80, 100 - ((4000 + (5 * __HEIGHT__)) / __HEIGHT__)))'
fi

# -- Sizer "programs": --

export FZF_SIZER_BC_STL='
define min(a, b) { if (a < b) return a else return b }
define max(a, b) { if (a > b) return a else return b }
'

fzf_sizer_run_bc_program() {
  WIDTH="${WIDTH:=$(tput cols)}"
  HEIGHT="${HEIGHT:=$(tput lines)}"

  WIDTH_SUBSTITUTED="${1//__WIDTH__/$WIDTH}"
  echo "${FZF_SIZER_BC_STL} ${FZF_SIZER_BC_LIB} ${WIDTH_SUBSTITUTED//__HEIGHT__/$HEIGHT}" | bc -l
}

fzf_sizer_preview_window_settings() {
  IS_VERTICAL="$(fzf_sizer_run_bc_program "__WIDTH__ / __HEIGHT__ < $FZF_SIZER_VERTICAL_THRESHOLD")"

  if [ "$IS_VERTICAL" = '1' ]; then
    PREVIEW_DIRECTION="$FZF_SIZER_VERTICAL_PREVIEW_LOCATION"
    PREVIEW_SIZE="$(fzf_sizer_run_bc_program "$FZF_SIZER_VERTICAL_PREVIEW_PERCENT_CALCULATION")"
  else
    PREVIEW_DIRECTION="$FZF_SIZER_HORIZONTAL_PREVIEW_LOCATION"
    PREVIEW_SIZE="$(fzf_sizer_run_bc_program "$FZF_SIZER_HORIZONTAL_PREVIEW_PERCENT_CALCULATION")"
  fi

  # NB: round the `bc -l` result
  echo "$PREVIEW_DIRECTION:${PREVIEW_SIZE%%.*}%"
}

fzf_sizer_hidden_preview_window_settings() {
  echo "$(fzf_sizer_preview_window_settings):hidden"
}

if [ "$sourced" -eq 0 ]; then
  fzf_sizer_preview_window_settings
fi
