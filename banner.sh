#!/usr/bin/env bash
# OMDUTA CLOUD — Neon Premium VPS Banner

# ANSI Colors
P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
D='\033[38;5;242m'
N='\033[0m'
C='\033[38;5;51m'

# Resource Bar — 14 blocks
bar() {
    local value="${1:-0}"
    local filled i

    value="${value%%%}"
    [[ "$value" =~ ^[0-9]+$ ]] || value=0

    (( value < 0 )) && value=0
    (( value > 100 )) && value=100

    filled=$(( value * 14 / 100 ))

    for ((i=1; i<=14; i++)); do
        if (( i <= filled )); then
            printf '%b■ %b' "$G" "$N"
        else
            printf '%b□ %b' "$D" "$N"
        fi
    done
}

# System Information
n=$(nproc 2>/dev/null || echo 1)

load1=$(awk '{print $1}' /proc/loadavg 2>/dev/null || echo 0)
load_all=$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || echo "0 0 0")

cp=$(awk -v l="$load1" -v c="$n" '
BEGIN {
    p=(c>0 ? l/c*100 : 0)
    if(p>100)p=100
    if(p<0)p=0
    printf "%d",p
}')

read -r mt mu <<< "$(free -m 2>/dev/null | awk '/^Mem:/ {print $2,$3}')"
mt=${mt:-0}
mu=${mu:-0}

if (( mt > 0 )); then
    rp=$(( mu * 100 / mt ))
else
    rp=0
fi

read -r dt du dp <<< "$(df -h / 2>/dev/null | awk 'NR==2 {print $2,$3,$5}')"

dt=${dt:-N/A}
du=${du:-N/A}
dp=${dp:-0%}

disk_pct="${dp%%%}"
[[ "$disk_pct" =~ ^[0-9]+$ ]] || disk_pct=0

model=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null |
         cut -d: -f2- | sed 's/^ *//')

model=${model:-Unknown CPU}

os=$(. /etc/os-release 2>/dev/null; printf '%s' "${PRETTY_NAME:-Unknown OS}")

host=$(hostname 2>/dev/null || echo unknown)
jam=$(date '+%H:%M:%S WIB' 2>/dev/null || date '+%H:%M:%S')

ip=$(hostname -I 2>/dev/null | awk '{print $1}')
ip=${ip:-Unavailable}

node=$(node -v 2>/dev/null || echo "Not installed")

# Banner
printf '\n'
printf '%b  ╭──────────────────────────────────────────────╮ %b\n' "$C" "$N"
printf '%b  │ %b       O M D U T A   C L O U D          %b│ %b\n' "$C" "$V" "$C" "$N"
printf '%b  ╰──────────────────────────────────────────────╯ %b\n' "$C" "$N"
printf '\n'

if command -v toilet >/dev/null 2>&1; then
    toilet -f future --filter gay '@OmdutaMd'
else
    printf '%b@OmdutaMd%b\n' "$P" "$N"
fi

printf '\n'
printf '  %b● STATUS ONLINE%b  │  %bHostname : %s%b\n' "$G" "$N" "$Y" "$host" "$N"
printf '  %b⏰ %s%b      │  %bOS       : %s%b\n' "$D" "$jam" "$N" "$Y" "$os" "$N"

printf '\n'
printf '  %b┌───[ %bS P E K   M E S I N%b ]───────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  🧠 CPU    : %b%s%b\n' "$V" "$N" "$D" "$model" "$N"
printf '  %b│%b  ⚙️  Cores  : %s vCPU\n' "$V" "$N" "$n"
printf '  %b│%b  ⚡ Load   : %s\n' "$V" "$N" "$load_all"
printf '  %b└──────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %b┌───[ %bR E S O U R C E S%b ]─────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  📊 CPU    : %s %s%%\n' "$V" "$N" "$(bar "$cp")" "$cp"
printf '  %b│%b  💾 RAM    : %s %s%% (%s/%s MB)\n' "$V" "$N" "$(bar "$rp")" "$rp" "$mu" "$mt"
printf '  %b│%b  💽 Disk   : %s %s (%s/%s)\n' "$V" "$N" "$(bar "$disk_pct")" "$dp" "$du" "$dt"
printf '  %b└──────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %b┌───[ %bK O N E K S I%b ]───────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  🌐 IP     : %b%s%b\n' "$V" "$N" "$Y" "$ip" "$N"
printf '  %b│%b  🟢 Node   : %s\n' "$V" "$N" "$node"
printf '  %b└──────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %bKetik %bvps%b untuk menampilkan info ini lagi.%b\n' "$D" "$Y" "$D" "$N"
printf '\n'