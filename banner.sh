
#!/usr/bin/env bash
# ==========================================
# OMDUTA CLOUD - NEON PREMIUM VPS
# Owner: @OmdutaMd
# Telegram: https://t.me/OmdutaMd
# ==========================================

P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
C='\033[38;5;117m'
D='\033[38;5;245m'
W='\033[1;37m'
N='\033[0m'

# Jangan tampilkan banner jika bukan terminal interaktif
if [[ ! -t 1 ]]; then
    exit 0
fi

clear 2>/dev/null || true

# Ambil informasi sistem
HOST=$(hostname 2>/dev/null || echo "OMDUTA-VPS")
OS=$(. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-Ubuntu}")
KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "Unknown")

RAM_TOTAL=$(free -m 2>/dev/null | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m 2>/dev/null | awk '/Mem:/ {print $3}')

DISK_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
DISK_PERCENT=$(df / 2>/dev/null | awk 'NR==2 {print $5}')

RAM_TOTAL=${RAM_TOTAL:-0}
RAM_USED=${RAM_USED:-0}
DISK_TOTAL=${DISK_TOTAL:-Unknown}
DISK_USED=${DISK_USED:-Unknown}
DISK_PERCENT=${DISK_PERCENT:-Unknown}

# Fungsi garis kotak
line() {
    printf "${P}╠══════════════════════════════════════════════╣${N}\n"
}

# Fungsi informasi
info() {
    printf "${P}║${N} %-14s ${D}:${N} ${W}%-28s${N} ${P}║${N}\n" "$1" "$2"
}

# Fungsi progress bar
bar() {
    local value=$1
    local width=20
    local filled

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

if [[ "$RAM_TOTAL" -gt 0 ]]; then
    RAM_PERCENT=$((RAM_USED * 100 / RAM_TOTAL))
else
    RAM_PERCENT=0
fi

printf "\n"
printf "${P}╔══════════════════════════════════════════════╗${N}\n"
printf "${P}║${N}       ${V}✦ O M D U T A   C L O U D ✦${N}         ${P}║${N}\n"
printf "${P}║${N}          ${Y}PREMIUM SSH VPS SERVER${N}             ${P}║${N}\n"
printf "${P}╠══════════════════════════════════════════════╣${N}\n"
printf "${P}║${N} ${C}       WELCOME TO OMDUTA CLOUD VPS${N}          ${P}║${N}\n"
line

info "Hostname" "$HOST"
info "Operating" "$OS"
info "Kernel" "$KERNEL"
info "Architecture" "$ARCH"
info "CPU Core" "$CPU"
info "Uptime" "$UPTIME"

line

printf "${P}║${N} ${Y}RESOURCE MONITOR${N}                             ${P}║${N}\n"
printf "${P}║${N} RAM  : ${W}%s MB / %s MB${N}\n" "$RAM_USED" "$RAM_TOTAL"
printf "${P}║${N}       "
bar "$RAM_PERCENT"
printf " ${W}%s%%${N}\n" "$RAM_PERCENT"

printf "${P}║${N} DISK : ${W}%s / %s${N}\n" "$DISK_USED" "$DISK_TOTAL"
printf "${P}║${N}       ${C}%s used${N}\n" "$DISK_PERCENT"

line

printf "${P}║${N} ${G}OWNER   : ${W}@OmdutaMd${N}                       ${P}║${N}\n"
printf "${P}║${N} ${C}TELEGRAM: ${W}https://t.me/OmdutaMd${N}  ${P}║${N}\n"
line

printf "${P}║${N}       ${V}✦ THANK YOU FOR USING OMDUTA ✦${N}        ${P}║${N}\n"
printf "${P}╚══════════════════════════════════════════════╝${N}\n"
printf "\n"
