
#!/usr/bin/env bash
# ==========================================================
#              OMDUTA CLOUD — NEON PREMIUM VPS
# ==========================================================

# ANSI COLORS
P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
D='\033[38;5;242m'
C='\033[38;5;51m'
R='\033[38;5;203m'
N='\033[0m'

# TERMINAL CHECK
if [[ ! -t 1 ]]; then
    exit 0
fi

# RESOURCE BAR
bar() {
    local value="${1:-0}"
    local filled i

    value="${value%\%}"
    [[ "$value" =~ ^[0-9]+$ ]] || value=0

    (( value > 100 )) && value=100
    (( value < 0 )) && value=0

    filled=$((value * 14 / 100))

    for ((i=1; i<=14; i++)); do
        if ((i <= filled)); then
            printf '%b■%b' "$G" "$N"
        else
            printf '%b□%b' "$D" "$N"
        fi
    done
}

# SYSTEM INFORMATION
host=$(hostname 2>/dev/null || echo "Unknown")
os=$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-Unknown OS}")
kernel=$(uname -r 2>/dev/null || echo "Unknown")
arch=$(uname -m 2>/dev/null || echo "Unknown")
jam=$(date '+%H:%M:%S WIB' 2>/dev/null || echo "Unknown")
tanggal=$(date '+%d-%m-%Y' 2>/dev/null || echo "Unknown")
uptime_text=$(uptime -p 2>/dev/null || echo "Unavailable")

# CPU
cores=$(nproc 2>/dev/null || echo 1)
cpu_model=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
cpu_model=${cpu_model:-Unknown CPU}

load1=$(awk '{print $1}' /proc/loadavg 2>/dev/null || echo 0)
load_all=$(awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || echo "0 0 0")

cpu_usage=$(awk -v l="$load1" -v c="$cores" 'BEGIN {
    p=(c>0 ? l/c*100 : 0)
    if(p>100)p=100
    if(p<0)p=0
    printf "%d",p
}')

# RAM
read -r mt mu <<< "$(free -m 2>/dev/null | awk '/^Mem:/ {print $2,$3}')"
mt=${mt:-0}
mu=${mu:-0}
ram_usage=0

if ((mt > 0)); then
    ram_usage=$((mu * 100 / mt))
fi

# DISK
read -r disk_total disk_used disk_percent <<< "$(df -h / 2>/dev/null | awk 'NR==2 {print $2,$3,$5}')"

disk_total=${disk_total:-N/A}
disk_used=${disk_used:-N/A}
disk_percent=${disk_percent:-0%}

disk_value="${disk_percent%\%}"
[[ "$disk_value" =~ ^[0-9]+$ ]] || disk_value=0

# NETWORK
ip=$(hostname -I 2>/dev/null | awk '{print $1}')
ip=${ip:-Unavailable}

# SOFTWARE
node=$(node -v 2>/dev/null || echo "Not installed")
npm=$(npm -v 2>/dev/null || echo "Not installed")
git=$(git --version 2>/dev/null | awk '{print $3}')
git=${git:-"Not installed"}

# PUBLIC OWNER
owner="@OmdutaMd"
telegram="https://t.me/OmdutaMd"

# DISPLAY
clear 2>/dev/null || true

printf '\n'
printf '%b╭────────────────────────────────────────────────────╮%b\n' "$C" "$N"
printf '%b│%b                                                    %b│%b\n' "$C" "$N" "$C" "$N"
printf '%b│%b          %bO M D U T A   C L O U D%b              %b│%b\n' "$C" "$N" "$P" "$N" "$C" "$N"
printf '%b│%b             %bN E O N   P R E M I U M%b              %b│%b\n' "$C" "$N" "$V" "$N" "$C" "$N"
printf '%b│%b                                                    %b│%b\n' "$C" "$N" "$C" "$N"
printf '%b╰────────────────────────────────────────────────────╯%b\n' "$C" "$N"

printf '\n'

if command -v toilet >/dev/null 2>&1; then
    toilet -f future --filter gay '@OmdutaMd' 2>/dev/null || printf '%b@OmdutaMd%b\n' "$P" "$N"
else
    printf '%b             @OmdutaMd%b\n' "$P" "$N"
fi

printf '\n'
printf '  %b● ONLINE%b  │  %bHOST : %s%b\n' "$G" "$N" "$Y" "$host" "$N"
printf '  %b◷ %s%b  │  %bDATE : %s%b\n' "$D" "$jam" "$N" "$Y" "$tanggal" "$N"

printf '\n'
printf '  %b┌───[ %bSYSTEM INFORMATION%b ]────────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  🖥 OS       : %s\n' "$V" "$N" "$os"
printf '  %b│%b  ⚙ Kernel   : %s\n' "$V" "$N" "$kernel"
printf '  %b│%b  🧠 CPU      : %s\n' "$V" "$N" "$cpu_model"
printf '  %b│%b  🔢 Cores    : %s vCPU\n' "$V" "$N" "$cores"
printf '  %b│%b  📦 Arch     : %s\n' "$V" "$N" "$arch"
printf '  %b│%b  ⏱ Uptime   : %s\n' "$V" "$N" "$uptime_text"
printf '  %b│%b  ⚡ Load     : %s\n' "$V" "$N" "$load_all"
printf '  %b└──────────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %b┌───[ %bRESOURCE MONITOR%b ]─────────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  CPU  : %s %s%%\n' "$V" "$N" "$(bar "$cpu_usage")" "$cpu_usage"
printf '  %b│%b  RAM  : %s %s%% (%s/%s MB)\n' "$V" "$N" "$(bar "$ram_usage")" "$ram_usage" "$mu" "$mt"
printf '  %b│%b  DISK : %s %s (%s/%s)\n' "$V" "$N" "$(bar "$disk_value")" "$disk_percent" "$disk_used" "$disk_total"
printf '  %b└──────────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %b┌───[ %bNETWORK & SOFTWARE%b ]───────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  🌐 Local IP : %s\n' "$V" "$N" "$ip"
printf '  %b│%b  🟢 Node.js  : %s\n' "$V" "$N" "$node"
printf '  %b│%b  📦 NPM      : %s\n' "$V" "$N" "$npm"
printf '  %b│%b  🔧 Git      : %s\n' "$V" "$N" "$git"
printf '  %b└──────────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %b┌───[ %bOWNER INFORMATION%b ]────────────────────────┐%b\n' "$V" "$Y" "$V" "$N"
printf '  %b│%b  👤 Owner    : %b%s%b\n' "$V" "$N" "$P" "$owner" "$N"
printf '  %b│%b  ✈ Telegram : %b%s%b\n' "$V" "$N" "$C" "$telegram" "$N"
printf '  %b└──────────────────────────────────────────────────┘%b\n' "$V" "$N"

printf '\n'
printf '  %bKetik %bvps%b untuk menampilkan banner kembali.%b\n' "$D" "$Y" "$D" "$N"
printf '\n'
