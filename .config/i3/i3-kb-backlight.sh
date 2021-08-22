#!/bin/bash
#
#  i3-kb-backlight
#
#  Keyboard backlight control and notifications for i3wm
#
#  Dependencies:
#    awk (POSIX compatible)
#    bc
#    upower
#
#  Copyright (c) 2018 Beau Hastings. All rights reserved.
#  License: GNU General Public License v2
#
#  Author: Beau Hastings <beau@saweet.net>
#  URL: https://github.com/hastinbe/i3-kb-brightness

get_brightness() {
    backlight GetBrightness | awk '{print $2}'
}

get_max_brightness() {
    backlight GetMaxBrightness | awk '{print $2}'
}

set_brightness() {
    backlight SetBrightness "$(clamp "$1" 0 "$(get_max_brightness)")"
}

increase_brightness() {
    local -r step=$1
    local -r current=$(get_brightness)
    local -r max=$(get_max_brightness)
    local -r new=$(min "$max" $(( current + step )) )

    set_brightness "$new"
}

decrease_brightness() {
    local -r step=$1
    local -r current=$(get_brightness)
    local -r new=$(max 0 $(( current - step )) )

    set_brightness "$new"
}

backlight() {
    local -r method=$1

    case "$method" in
        GetBrightness)
            dbus-send --type=method_call --system --print-reply=literal \
                --dest='org.freedesktop.UPower' \
                '/org/freedesktop/UPower/KbdBacklight' \
                "org.freedesktop.UPower.KbdBacklight.${method}"
            ;;
        GetMaxBrightness)
            dbus-send --type=method_call --system --print-reply=literal \
                --dest='org.freedesktop.UPower' \
                '/org/freedesktop/UPower/KbdBacklight' \
                "org.freedesktop.UPower.KbdBacklight.${method}"
            ;;
        SetBrightness)
            local value="$2"
            dbus-send --type=method_call --system --print-reply=literal \
                --dest='org.freedesktop.UPower' \
                '/org/freedesktop/UPower/KbdBacklight' \
                "org.freedesktop.UPower.KbdBacklight.${method}" \
                "int32:${value}"
            ;;
    esac
}

min() {
    echo "if ($1 < $2) $1 else $2" | bc
}

max() {
    echo "if ($1 > $2) $1 else $2" | bc
}

clamp() {
    min "$(max "$1" "$2")" "$3"
}

empty() {
    [[ -z $1 ]]
}

command_exists() {
    command -v "$1" >/dev/null 2>&1;
}

error() {
    echo "$COLOR_RED$*$COLOR_RESET"
}

has_color() {
    (( $(tput colors 2>/dev/null || echo 0) >= 8 )) && [ -t 1 ]
}

has_capability() {
    [[ "${NOTIFY_CAPS[*]}" =~ $1 ]]
}

# Generates a progress bar for the provided value.
#
# Arguments:
#   Percentage      (integer) Percentage of progress.
#   Maximum         (integer) Maximum percentage. (default: 100)
#   Divisor         (integer) For calculating the ratio of blocks to progress (default: 5)
#
# Returns:
#   The progress bar.
progress_bar() {
    local -r percent=${1:?$(error 'Percentage is required')}
    local -r max_percent=${2:-100}
    local -r divisor=${3:-5}
    local -r progress=$(((percent > max_percent ? max_percent : percent) / divisor))

    printf -v bar "%*s" $progress ""
    echo "${bar// /█}"
}

notify_brightness() {
    local -r max=$(get_max_brightness)
    local -r brightness=$(get_brightness)
    local -r percent=$(echo "\
    define pcnt(x,y) { \
        auto s, var; \
        s = scale; \
        scale = 1; \
        var = x / y * 100; \
        scale = s; \
        return (var); \
    } scale = 0; pcnt($brightness,$max)/1" | bc -l)
    local text="Brightness: ${percent}%"

    if $SHOW_BRIGHTNESS_PROGRESS; then
        local -r progress=$(progress_bar "$percent")
        text="$text $progress"
    fi

    case "$NOTIFICATION_METHOD" in
        xosd    ) notify_brightness_xosd "$percent" "$text" ;;
        herbe   ) notify_brightness_herbe "$text" ;;
        *       ) notify_brightness_libnotify "$percent" "$ICON" "$text" ;;
    esac
}

list_notification_methods() {
    awk -W posix 'match($0,/^notify_brightness_([[:alnum:]]+)/) {print substr($0, 19, RLENGTH-18)}' "${BASH_SOURCE[0]}" || exit "$EX_USAGE"
    exit "$EX_OK"
}

# Send notifcation for libnotify-compatible notification daemons.
#
# Arguments:
#   Percent     (integer) An integer indicating the brightness.
#   Icon        (string) Icon to display.
#   Text        (string) Notification text.
notify_brightness_libnotify() {
    local -r percent=$1
    local -r icon=${2:-$ICON}
    local -r text=${*:3}
    local -a args=(
        -t "$EXPIRES"
    )
    local -a hints=(
        # Replaces previous notification in some notification servers
        string:synchronous:brightness
        # Replaces previous notification in NotifyOSD
        string:x-canonical-private-synchronous:brightness
    )

    # If we're not drawing our own progress bar, allow the notification daemon to draw its own (if supported)
    if ! $SHOW_BRIGHTNESS_PROGRESS; then
        hints+=(int:value:"$percent")
    fi

    (( ${#NOTIFY_CAPS[@]} < 1 )) && load_notify_server_caps

    if has_capability icon-static; then
        args+=(-i "$icon")

        # haskell-notification-daemon (aka deadd-notification-center) does not support -i|--icon
        hints+=(string:image-path:"$icon")
    fi

    if $USE_DUNSTIFY; then
        args+=(-r 1000)

        # Transient notifications will bypass the idle_threshold setting.
        # Should be boolean, but Notify-OSD doesn't support boolean yet. Dunst checks
        # for int and bool with transient so lets play nice with both servers.
        hints+=(int:transient:1)

        read -ra hints <<< "${hints[@]/#/-h }"
        "${DUNSTIFY_PATH:+${DUNSTIFY_PATH%/}/}dunstify" "${hints[@]}" "${args[@]}"  "$text"
    else
        read -ra hints <<< "${hints[@]/#/-h }"
        "${NOTIFY_SEND_PATH:+${NOTIFY_SEND_PATH%/}/}notify-send" "${hints[@]}" "${args[@]}" "$text"
    fi
}

# Send notification to XOSD.
#
# Arguments:
#   Percent     (integer) An integer indicating the brightness.
#   Text        (string) Notification text.
notify_brightness_xosd() {
    local -r percent=$1
    local -r text=${*:2}
    local -r delay=$(ms_to_secs "$EXPIRES")

    "${XOSD_PATH}osd_cat" --align center -b percentage -P "$percent" -d "$delay" -p top -A center -c "$COLOR_XOSD_TEXT" -T "$text" -O 2 -u "$COLOR_XOSD_OUTLINE" & disown
}

# Send notification to herbe.
#
# Arguments:
#   Text    (string) Notification text.
#
# Note: a patch with a notify-send script for herbe, not in the current version at this
#       time but would make this irrelevant. See https://github.com/dudik/herbe/pull/10
notify_brightness_herbe() {
    local -r text=$*

    # Dismiss existing/pending notifications to prevent queuing
    pkill -SIGUSR1 herbe

    "${HERBE_PATH}herbe" "$text" & disown
}

# Rearrange all options to place flags first
# Author: greycat
# URL: https://mywiki.wooledge.org/ComplexOptionParsing
arrange_opts() {
    local flags args optstr=$1
    shift

    while (($#)); do
        case $1 in
            --)
                args+=("$@")
                break;
                ;;
            -*)
                flags+=("$1")
                if [[ $optstr == *"${1: -1}:"* ]]; then
                    flags+=("$2")
                    shift
                fi
                ;;
            *)
                args+=("$1")
                ;;
        esac
        shift
    done
    OPTARR=("${flags[@]}" "${args[@]}")
}

parse_opts() {
    local optstring=e:i:nN:phy

    arrange_opts "$optstring" "$@"
    set -- "${OPTARR[@]}"

    OPTIND=1

    while getopts "$optstring" opt; do
        case "$opt" in
            e    ) EXPIRES=$OPTARG ;;
            i    ) ICON=$OPTARG ;;
            n    ) DISPLAY_NOTIFICATIONS=true ;;
            N    ) NOTIFICATION_METHOD=$OPTARG ;;
            p    ) SHOW_BRIGHTNESS_PROGRESS=true ;;
            y    ) USE_DUNSTIFY=true ;;
            h | *) usage ;;
        esac
    done

    read -ra CMDARGS <<< "${OPTARR[@]:$((OPTIND-1))}"
}

exec_command() {
    IFS=' ' read -ra ARGS <<< "$1"
    set -- "${ARGS[@]}"

    COMMAND=${1:?$(error 'A command is required')}
    shift

    case "$COMMAND" in
        increase)
            increase_brightness "${1:-1}"
            ;;
        decrease)
            decrease_brightness "${1:-1}"
            ;;
        notifications)
            list_notification_methods
            ;;
        *)
            usage
            ;;
    esac
}

# Converts milliseconds to seconds with rounding up
#
# Arguments:
#   milliseconds    (integer) An integer in milliseconds
ms_to_secs() {
    echo $(( ($1 + (1000 - 1)) / 1000 ))
}

bootstrap() {
    setup_cli_colors
}

setup_cli_colors() {
    if has_color; then
        COLOR_RESET=$'\033[0m'
        COLOR_RED=$'\033[0;31m'
        COLOR_GREEN=$'\033[0;32m'
        COLOR_YELLOW=$'\033[0;33m'
        COLOR_MAGENTA=$'\033[0;35m'
    fi
}

usage() {
    cat <<- EOF 1>&2
${COLOR_YELLOW}Usage:${COLOR_RESET} $0 [<options>] <command> [<args>]
Control keyboard backlight brightness.

${COLOR_YELLOW}Commands:${COLOR_RESET}
  ${COLOR_GREEN}increase <value>${COLOR_RESET}      increase brightness
  ${COLOR_GREEN}decrease <value>${COLOR_RESET}      decrease brightness
  ${COLOR_GREEN}notifications${COLOR_RESET}         show available notification methods
  ${COLOR_GREEN}help${COLOR_RESET}                  display help

${COLOR_YELLOW}Options:${COLOR_RESET}
  ${COLOR_GREEN}-e <expires>${COLOR_RESET}          expiration time of notifications in ms
  ${COLOR_GREEN}-i <icon>${COLOR_RESET}             name of keyboard brightness icon
  ${COLOR_GREEN}-n${COLOR_RESET}                    enable notifications
  ${COLOR_GREEN}-N <method>${COLOR_RESET}           notification method (${COLOR_MAGENTA}default: libnotify${COLOR_RESET})
  ${COLOR_GREEN}-p${COLOR_RESET}                    enable progress bar
  ${COLOR_GREEN}-h${COLOR_RESET}                    display help
EOF
    exit "$EX_USAGE"
}

show_brightness_notification() {
    $DISPLAY_NOTIFICATIONS || return

    if empty "$NOTIFICATION_METHOD"; then
        load_notify_server_info
        NOTIFICATION_METHOD=$NOTIFY_SERVER
    fi

    notify_brightness
}

# Loads notification system information via DBus
load_notify_server_info() {
    command_exists dbus-send || return
    IFS=$'\t' read -r NOTIFY_SERVER _ _ _ < <(dbus-send --print-reply --dest=org.freedesktop.Notifications /org/freedesktop/Notifications org.freedesktop.Notifications.GetServerInformation | awk 'BEGIN { ORS="\t" }; match($0, /^   string ".*"/) {print substr($0, RSTART+11, RLENGTH-12)}')
}

# Load notification system capabilities via DBus
load_notify_server_caps() {
    command_exists dbus-send || return
    IFS= read -r -d '' -a NOTIFY_CAPS < <(dbus-send --print-reply=literal --dest="${DBUS_NAME}" "${DBUS_PATH}" "${DBUS_IFAC_FDN}.GetCapabilities" | awk 'RS="      " { if (NR > 2) print $1 }')
}

post_command_hook() {
    show_brightness_notification
}

main() {
    # Getopt parsing variables
    declare OPTIND
    declare -a OPTARR CMDARGS

    # Exit codes
    declare -ir \
        EX_OK=0 \
        EX_USAGE=64

    # DBUS constants
    declare -r \
        DBUS_NAME=org.freedesktop.Notifications \
        DBUS_PATH=/org/freedesktop/Notifications \
        DBUS_IFAC_FDN=org.freedesktop.Notifications

    # Notification server information
    declare \
        NOTIFY_SERVER
        # NOTIFY_VENDOR \
        # NOTIFY_VERSION \
        # NOTIFY_SPEC_VERSION

    # Notification capabilities
    declare -a NOTIFY_CAPS=()

    declare \
        COLOR_RESET \
        COLOR_RED \
        COLOR_GREEN \
        COLOR_YELLOW \
        COLOR_MAGENTA

    # Notification colors
    declare -r \
        COLOR_XOSD_TEXT=${COLOR_OTHER:-#FFFFFF} \
        COLOR_XOSD_OUTLINE=${COLOR_XOSD_OUTLINE:-#222222}

    declare -l NOTIFICATION_METHOD

    declare \
        COMMAND \
        ICON=keyboard-brightness
        DISPLAY_NOTIFICATIONS=false \
        SHOW_BRIGHTNESS_PROGRESS=false \
        USE_DUNSTIFY=false

    declare -i EXPIRES=1500

    bootstrap

    parse_opts "$@"

    exec_command "${CMDARGS[*]}" && post_command_hook

    exit "${EXITCODE:-$EX_OK}"
}

main "$@"