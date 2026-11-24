
#!/usr/bin/env bash

# ==========================================
# OMDUTA CLOUD - NEON PREMIUM VPS
# Owner: @OmdutaMd
# Telegram: https://t.me/OmdutaMd
# ==========================================

set +e

P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
C='\033[38;5;117m'
D='\033[38;5;245m'
W='\033[1;37m'
N='\033[0m'

# ==========================================
# SYSTEM INFORMATION
# ==========================================

HOST=$(hostname 2>/dev/null || echo "OMDUTA-VPS")
OS=$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-Ubuntu}")
KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "Unknown")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")

RAM_TOTAL=$(free -m 2>/dev/null | awk '/^Mem:/ {print $2}')
RAM_USED=$(free -m 2>/dev/null | awk '/^Mem:/ {print $3}')

DISK_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
DISK_PERCENT=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')

RAM_TOTAL=${RAM_TOTAL:-0}
RAM_USED=${RAM_USED:-0}
DISK_TOTAL=${DISK_TOTAL:-Unknown}
DISK_USED=${DISK_USED:-Unknown}
DISK_PERCENT=${DISK_PERCENT:-Unknown}

if [[ "$RAM_TOTAL" =~ ^[0-9]+$ ]] && (( RAM_TOTAL > 0 )); then
    RAM_PERCENT=$((RAM_USED * 100 / RAM_TOTAL))
else
    RAM_PERCENT=0
fi

# ==========================================
# FUNCTIONS
# ==========================================

line() {
    printf "${P}║${D}══════════════════════════════════════════════${P}║${N}\n"
}

info() {
    printf "${P}║${N} %-14s ${D}:${N} ${W}%-28.28s${N} ${P}║${N}\n" "$1" "$2"
}

bar() {
    local value=${1:-0}
    local width=20
    local filled=0
    local i

    [[ "$value" =~ ^[0-9]+$ ]] || value=0

    (( value > 100 )) && value=100
    filled=$((value * width / 100))

    printf "${G}"
    for ((i=0; i<filled; i++)); do
        printf "█"
    done

    printf "${D}"
    for ((i=filled; i<width; i++)); do
        printf "░"
    done

    printf "${N}"
}

# ==========================================
# DISPLAY
# ==========================================

printf "\n"
printf "${P}╔══════════════════════════════════════════════╗${N}\n"
printf "${P}║${N}          ${V}✦ OMDUTA CLOUD ✦${N}                  ${P}║${N}\n"
printf "${P}║${N}       ${Y}PREMIUM SSH VPS SERVER${N}                ${P}║${N}\n"
printf "${P}╠══════════════════════════════════════════════╣${N}\n"
printf "${P}║${N}          ${C}WELCOME TO OMDUTA VPS${N}              ${P}║${N}\n"

line

info "Hostname" "$HOST"
info "Operating" "$OS"
info "Kernel" "$KERNEL"
info "Architecture" "$ARCH"
info "CPU Core" "$CPU"
info "Uptime" "$UPTIME"

line

printf "${P}║${N}              ${Y}RESOURCE MONITOR${N}               ${P}║${N}\n"
printf "${P}║${N} RAM  : ${W}%s MB / %s MB${N}\n" "$RAM_USED" "$RAM_TOTAL"
printf "${P}║${N}        "
bar "$RAM_PERCENT"
printf " ${W}%s%%${N}\n" "$RAM_PERCENT"

printf "${P}║${N} DISK : ${W}%s / %s${N}\n" "$DISK_USED" "$DISK_TOTAL"
printf "${P}║${N}        ${C}%s USED${N}\n" "$DISK_PERCENT"

line

printf "${P}║${N} OWNER    : ${G}@OmdutaMd${N}                       ${P}║${N}\n"
printf "${P}║${N} TELEGRAM : ${C}https://t.me/OmdutaMd${N}       ${P}║${N}\n"

line

printf "${P}║${N}          ${V}✦ THANK YOU FOR USING ✦${N}            ${P}║${N}\n"
printf "${P}║${N}              ${W}OMDUTA CLOUD${N}                    ${P}║${N}\n"
printf "${P}╚══════════════════════════════════════════════╝${N}\n"
printf "\n"
