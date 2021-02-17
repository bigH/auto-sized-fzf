# `auto-sized-fzf`

A `--preview=....` generator that is based on the shell's current dimensions.

## Installation

Install by:

```bash
# sourcing the file
. /path/to/auto-sized-fzf/auto-sized-fzf.sh
```

## Usage

Run `fzf` with preview settings:
```bash
fzf $(fzf_sizer_preview_window_settings)
```

Set `fzf` defaults:
```bash
FZF_DEFAULT_OPTS="$(fzf_sizer_preview_window_settings)"
```

Set `fzf` defaults on a new prompt (`zsh` solution):
```zsh
# resize window and fzf preview sizing/location will resize with you
precmd() {
  FZF_DEFAULT_OPTS="--border --no-height $(fzf_sizer_preview_window_settings)"
}
```

Hidden preview window (when hidden by default):
```
fzf $(fzf_sizer_hidden_preview_window_settings)
```

## Customization

**!! AVOID CUSTOMIZING: the defaults are very nice !!**

### `FZF_SIZER_VERTICAL_THRESHOLD`

If you use vertical or varying sized terminals/windows often, you may want to configure the threshold for switching to a vertical view. This ratio is calculated by running `"__WIDTH__ / __HEIGHT__ > $FZF_SIZER_VERTICAL_THRESHOLD"`. This is calculated using GNU `bc`. _The default is `2.0`._

```bash
export FZF_SIZER_VERTICAL_THRESHOLD="1.7 * __HEIGHT__ / 80"
```

### `FZF_SIZER_VERTICAL_PREVIEW_PERCENT_CALCULATION` and `FZF_SIZER_HORIZONTAL_PREVIEW_PERCENT_CALCULATION`

You can also configure how the size of the preview window is calculated. They're calculated using GNU `bc`. Try using [Desmos](https://www.desmos.com/calculator) to tweak the calculation. _The defaults are more complex than shown below._

```bash
# use __WIDTH__ for horizontal scenarios
export FZF_SIZER_HORIZONTAL_PREVIEW_PERCENT_CALCULATION='max(50, min(80, 100 - (7000 / __WIDTH__)))'

# use __HEIGHT__ for horizontal scenarios
export FZF_SIZER_VERTICAL_PREVIEW_PERCENT_CALCULATION='max(50, min(80, 100 - (5000 / __HEIGHT__)))'
```

### `FZF_SIZER_VERTICAL_PREVIEW_LOCATION` and `FZF_SIZER_HORIZONTAL_PREVIEW_LOCATION`

See `fzf` man pages for values.

Really, you can configure whatever you want about the preview window (e.g. `nofollow:cycle:bottom`).
