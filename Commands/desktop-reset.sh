#!/bin/bash
# kde-session-reset.sh — reset KDE session to fresh-boot state
# Debian 13 KDE / systemd user session
# Run as your normal user inside any terminal.

RED='\033[0;31m'; YLW='\033[1;33m'; GRN='\033[0;32m'; DIM='\033[2m'; NC='\033[0m'
logstop() { echo -e "${YLW}[stop]${NC}  $*"; }
logkeep() { echo -e "${DIM}[keep]  $*${NC}"; }
logerr()  { echo -e "${RED}[fail]${NC}  $*"; }

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  KDE Session Reset  —  $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# User systemd PID — boundary for process walks
# ─────────────────────────────────────────────────────────────────────────────
USER_SYSTEMD_PID=$(ps -u "$USER" -o pid=,comm= --no-headers 2>/dev/null \
    | awk '$2=="systemd"{print $1}' | head -1 | tr -d ' ')
[[ -z "$USER_SYSTEMD_PID" ]] && { echo "Could not find user systemd PID. Aborting."; exit 1; }
echo "User systemd PID: $USER_SYSTEMD_PID"

# ─────────────────────────────────────────────────────────────────────────────
# Build SAFE PID set by walking DOWN from the calling terminal emulator.
# We find the terminal by walking UP from $$ until we hit a known terminal name.
# ─────────────────────────────────────────────────────────────────────────────
declare -A SAFE

# _walk_down() {
#     local parent=$1
#     [[ "$parent" == "$USER_SYSTEMD_PID" ]] && return
#     SAFE[$parent]=1
#     while IFS= read -r child; do
#         [[ "$child" =~ ^[0-9]+$ ]] || continue
#         [[ -n "${SAFE[$child]+_}" ]] && continue
#         _walk_down "$child"
#     done < <(ps -o pid= --ppid "$parent" 2>/dev/null | tr -d ' ')
# }

# Walk up from this script to find the terminal emulator PID.
# Also mark every ancestor along the way as SAFE so the calling
# shell chain is never killed even if terminal detection fails.
TERMINAL_PID=""
_pid=$$
while [[ "$_pid" =~ ^[0-9]+$ && "$_pid" -gt 1 && "$_pid" != "$USER_SYSTEMD_PID" ]]; do
    SAFE[$_pid]=1   # protect every ancestor unconditionally
    _comm=$(ps -o comm= -p "$_pid" 2>/dev/null | tr -d ' \n')
    case "$_comm" in
        yakuake|xterm|alacritty|kitty|wezterm|foot|gnome-terminal*)
            TERMINAL_PID=$_pid; break ;;
    esac
    _pid=$(ps -o ppid= -p "$_pid" 2>/dev/null | tr -d ' \n')
done

if [[ -n "$TERMINAL_PID" ]]; then
    echo "Terminal PID: $TERMINAL_PID ($(ps -o comm= -p "$TERMINAL_PID" 2>/dev/null | tr -d ' \n'))"
else
    echo "Terminal not found, protecting calling shell chain only"
fi

SAFE[$USER_SYSTEMD_PID]=1

# ─────────────────────────────────────────────────────────────────────────────
# KDE core process names — never kill regardless of tree position
# ─────────────────────────────────────────────────────────────────────────────
is_kde_core() {
    case "$1" in
        yakuake|xterm|alacritty|kitty|wezterm|foot|gnome-terminal*|\
        plasmashell|kwin_x11|kwin_wayland|kwin_wayland_wrapper|kwin_wayland_wr|\
        ksmserver|kded5|kded6|kdeinit5|kdeinit6|\
        kglobalaccel5|kglobalaccel6|kwalletd5|kwalletd6|\
        Xorg|Xwayland|systemd|"(sd-pam)"|startplasma*|plasma_session|\
        polkit-kde-auth*|gcr-ssh-agent|gnome-keyring-d*|\
        pipewire|wireplumber|pipewire-pulse|mpris-proxy|\
        dbus-daemon|dbus-broker|\
        xdg-desktop-por*|xdg-document-po*|xdg-permission-*|\
        at-spi-bus-laun*|at-spi2-registr*|\
        baloo*|baloorunner|org_kde_powerde*|gmenudbusmenupr*|\
        kaccess|kactivitymanage*|ksystemstats|xembedsniproxy|kscreen*|\
        dconf-service|fusermount3|obexd|xwaylandvideobr*|xsettingsd|\
        ssh-agent|python3|bash|sh|gdbus)
            return 0 ;;
    esac
    # Protect children of core KDE processes
    local ppid pcomm
    ppid=$(ps -o ppid= -p "$2" 2>/dev/null | tr -d ' \n')
    [[ "$ppid" =~ ^[0-9]+$ ]] || return 1
    pcomm=$(ps -o comm= -p "$ppid" 2>/dev/null | tr -d ' \n')
    case "$pcomm" in
        plasmashell|kwin_wayland|kwin_x11|kded5|kded6|ksmserver) return 0 ;;
    esac
    return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# PART 1: Stop non-essential systemd --user services
# ─────────────────────────────────────────────────────────────────────────────
is_kde_service() {
    case "$1" in
        plasma-*|pipewire*|wireplumber*|xdg-*|at-spi-dbus-bus*|dbus*|\
        gnome-keyring*|gcr-*|obex*|mpris*)
            return 0 ;;
    esac
    return 1
}

echo ""
echo "── User services ───────────────────────────────────"
svc_stopped=0; svc_kept=0

while IFS= read -r unit; do
    unit="${unit// /}"
    [[ -z "$unit" || "$unit" != *.service ]] && continue
    if is_kde_service "$unit"; then
        logkeep "$unit"
        (( svc_kept++ )) || true
    else
        logstop "$unit"
        systemctl --user stop "$unit" 2>/dev/null || logerr "could not stop $unit"
        (( svc_stopped++ )) || true
    fi
done < <(systemctl --user list-units --type=service --state=running \
             --no-legend --no-pager 2>/dev/null | awk '{print $1}')

echo "  Stopped: $svc_stopped  |  Kept: $svc_kept"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
# PART 2: Kill orphan processes
# ─────────────────────────────────────────────────────────────────────────────
echo "── Orphan processes ────────────────────────────────"
kill_pids=()

while IFS=' ' read -r pid comm; do
    [[ "$pid" =~ ^[0-9]+$ ]] || continue
    if [[ -n "${SAFE[$pid]+_}" ]]; then
        logkeep "[$pid] $comm"
        continue
    fi
    if is_kde_core "$comm" "$pid"; then
        logkeep "[$pid] $comm  (kde core)"
        continue
    fi
    logstop "[$pid] $comm"
    kill -TERM "$pid" 2>/dev/null && kill_pids+=("$pid") || true
done < <(ps -u "$USER" -o pid=,comm= --no-headers 2>/dev/null)

if [[ ${#kill_pids[@]} -gt 0 ]]; then
    sleep 1
    for pid in "${kill_pids[@]}"; do
        kill -0 "$pid" 2>/dev/null || continue
        echo -e "${RED}[kill]${NC}  [$pid] still alive → SIGKILL"
        kill -KILL "$pid" 2>/dev/null || true
    done
fi

echo ""

# ─────────────────────────────────────────────────────────────────────────────
# PART 3: Clean /tmp
# ─────────────────────────────────────────────────────────────────────────────
echo "── Cleaning /tmp ───────────────────────────────────"
cleaned=0
while IFS= read -r entry; do
    case "$(basename "$entry")" in
        pulse-*|kde-*|kio*|dbus-*|pipewire-*|.X*|ICE-unix) continue ;;
    esac
    rm -rf "$entry" 2>/dev/null && (( cleaned++ )) || true
done < <(find /tmp -maxdepth 1 -user "$USER" 2>/dev/null)
echo "  Removed $cleaned item(s)"
echo ""

systemctl --user daemon-reload 2>/dev/null || true

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GRN}  Done.${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
