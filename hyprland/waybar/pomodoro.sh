#!/bin/bash
# =============================================================================
# Waybar Pomodoro Timer
# =============================================================================
# Left-click  : toggle start/pause
# Right-click : reset current session
# Middle-click: skip to next session (add to waybar config if desired)
# =============================================================================

# --- User-configurable durations (in minutes) --------------------------------
WORK_MINUTES=25
SHORT_BREAK_MINUTES=5
LONG_BREAK_MINUTES=15
SESSIONS_BEFORE_LONG_BREAK=4   # after this many work sessions, take a long break
# -----------------------------------------------------------------------------

STATE_FILE="/tmp/waybar-pomodoro"

# Modes
MODE_WORK="work"
MODE_SHORT_BREAK="short_break"
MODE_LONG_BREAK="long_break"

# ── helpers ──────────────────────────────────────────────────────────────────

init() {
    if [[ ! -f "$STATE_FILE" ]]; then
        write_state 0 "$(date +%s)" $((WORK_MINUTES * 60)) "$MODE_WORK" 0 0
    fi
}

# write_state <running> <start_time> <duration> <mode> <session_count> <auto_started>
write_state() {
    cat > "$STATE_FILE" <<EOF
running=$1
start_time=$2
duration=$3
mode=$4
session_count=$5
auto_started=$6
EOF
}

load_state() {
    # shellcheck source=/dev/null
    source "$STATE_FILE"
}

notify() {
    local summary="$1" body="$2" urgency="${3:-normal}"
    # Try notify-send; silently skip if unavailable
    command -v notify-send &>/dev/null && \
        notify-send -u "$urgency" -a "Pomodoro" "$summary" "$body" 2>/dev/null || true
}

duration_for_mode() {
    case "$1" in
        "$MODE_SHORT_BREAK") echo $((SHORT_BREAK_MINUTES * 60)) ;;
        "$MODE_LONG_BREAK")  echo $((LONG_BREAK_MINUTES  * 60)) ;;
        *)                   echo $((WORK_MINUTES         * 60)) ;;
    esac
}

# ── actions ───────────────────────────────────────────────────────────────────

toggle() {
    load_state
    NOW=$(date +%s)

    if [[ "$running" == "1" ]]; then
        # Pause: freeze remaining time
        remaining=$(( duration - (NOW - start_time) ))
        (( remaining < 0 )) && remaining=0
        write_state 0 "$NOW" "$remaining" "$mode" "$session_count" 0
    else
        # Start / resume
        write_state 1 "$NOW" "$duration" "$mode" "$session_count" 0
    fi
}

reset_timer() {
    NOW=$(date +%s)
    # Full reset: back to work mode, zero sessions, full work duration
    write_state 0 "$NOW" $((WORK_MINUTES * 60)) "$MODE_WORK" 0 0
}

skip() {
    # Manually advance to the next session
    load_state
    advance_session 1   # forced = 1 means skip even if not finished
}

# advance_session: called when timer hits 0 OR on manual skip
# forced=1 skips without caring about current remaining time
advance_session() {
    local forced="${1:-0}"
    load_state
    NOW=$(date +%s)
    local next_mode next_count

    if [[ "$mode" == "$MODE_WORK" ]]; then
        next_count=$(( session_count + 1 ))
        if (( next_count % SESSIONS_BEFORE_LONG_BREAK == 0 )); then
            next_mode="$MODE_LONG_BREAK"
            [[ "$forced" == "0" ]] && notify "🍵 Long Break!" \
                "${LONG_BREAK_MINUTES}min break — you've earned it." "normal"
        else
            next_mode="$MODE_SHORT_BREAK"
            [[ "$forced" == "0" ]] && notify "☕ Short Break" \
                "${SHORT_BREAK_MINUTES}min — stretch a little." "normal"
        fi
    else
        next_count="$session_count"
        next_mode="$MODE_WORK"
        [[ "$forced" == "0" ]] && notify "🍅 Focus Time" \
            "Break over — back to work! Session $(( next_count + 1 ))." "normal"
    fi

    local next_dur
    next_dur=$(duration_for_mode "$next_mode")
    # Auto-start the next session
    write_state 1 "$NOW" "$next_dur" "$next_mode" "$next_count" 1
}

# ── render ────────────────────────────────────────────────────────────────────

render() {
    load_state
    NOW=$(date +%s)

    if [[ "$running" == "1" ]]; then
        remaining=$(( duration - (NOW - start_time) ))
    else
        remaining="$duration"
    fi

    # Timer expired → advance session automatically
    if [[ "$running" == "1" ]] && (( remaining <= 0 )); then
        advance_session 0
        load_state          # reload after advance
        remaining="$duration"
        NOW=$(date +%s)
        remaining=$(( duration - (NOW - start_time) ))
    fi

    (( remaining < 0 )) && remaining=0

    local mins=$(( remaining / 60 ))
    local secs=$(( remaining % 60 ))
    local full_dur
    full_dur=$(duration_for_mode "$mode")
    # Strip any accidental whitespace/newline from command substitution
    full_dur="${full_dur//[[:space:]]/}"

    # Progress bar (10 blocks = 10% each)
    local bar_width=25
    local filled=0
    if (( full_dur > 0 )); then
        filled=$(( (full_dur - remaining) * bar_width / full_dur ))
    fi
    (( filled < 0         )) && filled=0
    (( filled > bar_width )) && filled=$bar_width
    local bar=""
    for (( i=0; i<filled; i++ ));          do bar+="▰"; done
    for (( i=filled; i<bar_width; i++ ));  do bar+="▱"; done

    # Session dots — only filled dots, no placeholders (grows as sessions complete)
    local dots=""
    local done_sessions=$session_count
    for (( i=0; i<done_sessions; i++ )); do
        dots+="‍‍ ●"
    done

    # Icon + class based on state & mode
    local icon class tooltip_mode

    case "$mode" in
        "$MODE_SHORT_BREAK") tooltip_mode="Short Break"  ;;
        "$MODE_LONG_BREAK")  tooltip_mode="Long Break"   ;;
        *)                   tooltip_mode="Focus #$(( session_count + 1 ))" ;;
    esac

    if [[ "$running" == "1" ]]; then
        case "$mode" in
            "$MODE_SHORT_BREAK") icon="☕"; class="short-break" ;;
            "$MODE_LONG_BREAK")  icon="🍵"; class="long-break"  ;;
            *)                   icon="🍅"; class="running"     ;;
        esac
    elif (( remaining >= full_dur )); then
        # Idle: not running and at full duration (fresh / just reset)
        icon=""; class="idle"
    else
        # Paused mid-session
        icon="⏸"; class="paused"
    fi
    [[ "$class" == "idle" ]] && bar=""
    [[ "$class" == "idle" ]] && tooltip=""
    local tooltip
    tooltip="$tooltip_mode | Sessions: $session_count | Cycle: $dots | $bar"

    #printf '{"text":"%s %02d:%02d %s %s","class":"%s","tooltip":"%s"}\n' \
    #    "$icon" "$mins" "$secs" "$bar" "$dots" "$class" "$tooltip"
    printf '{"text":"%s %02d:%02d'"${bar:+ $bar}${dots:+ $dots}"'","class":"%s","tooltip":"%s"}\n' \
        "$icon" "$mins" "$secs" "$class" "$tooltip"
}

# ── status (for scripting / debugging) ────────────────────────────────────────

status() {
    load_state
    echo "Mode         : $mode"
    echo "Running      : $running"
    echo "Sessions     : $session_count"
    echo "Duration left: ${duration}s"
}

# ── main ──────────────────────────────────────────────────────────────────────

init

case "$1" in
    toggle) toggle      ;;
    reset)  reset_timer ;;
    skip)   skip        ;;
    status) status      ;;
    *)      render      ;;
esac
