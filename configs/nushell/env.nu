# Nushell Environment Config File
#
# version = "0.88.1"

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    mut dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    # Stop paths from becomming too long keeping it at most 3 dirs long
    if ($dir | path split | length) > 3 {
        $dir = ($dir | path split | last 3 | prepend "..." | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi blue_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_blue_bold })
    let path_segment = $" ($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"

    $"($path_segment)(get_git_info)"
}

def get_git_info [] {
    let status = do --ignore-errors {git --no-optional-locks status --porcelain=2 --branch | lines}

    if ($status | is-empty) {
        return ""
    }
    
    let branch = $status
        | where ($it | str starts-with "# branch.head")
        | split column ' ' _ _ branch
        | get branch
        | first

    let has_unstaged = (if ($status
        | where ($it | str starts-with '1') or ($it | str starts-with '2')
        | is-empty) {
        false
    } else {
        true
    })
    let color = (if $has_unstaged { ansi light_red } else {ansi green })

    $" ($color) ($branch)(ansi reset)"
}

def create_separator [] {
    let color = (if ($env.LAST_EXIT_CODE == 0) { ansi light_green } else { ansi light_red })
    $" ($color)❯(ansi reset) "
}

def create_right_prompt [] {
    # Right prompt is the time elapsed for the last command nicely formatted
    mut secs = ($env.CMD_DURATION_MS | into int) / 1000 | math round
    mut mins = 0
    mut hours = 0
    
    $mins = $secs // 60
    $secs = $secs mod 60

    $hours = $mins // 60
    $mins = $mins mod 60

    mut parts = []

    if $hours > 0 {
        $parts = ($parts | append $"($hours)h")
    }
    if $mins > 0 {
        $parts = ($parts | append $"($mins)m")
    }
    if $secs > 0 {
        $parts = ($parts | append $"($secs)s")
    }

    $"(ansi yellow)($parts | str join (char space))(ansi reset)"
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| create_separator }
$env.PROMPT_INDICATOR_VI_INSERT = {|| create_separator }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " > " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

$env.EDITOR = "nvim"

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
