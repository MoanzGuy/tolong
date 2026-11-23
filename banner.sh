#!/bin/bash
# Warna Neon Premium
P='\e[38;5;213m'; V='\e[38;5;183m'; Y='\e[38;5;222m'; G='\e[38;5;114m'; D='\e[38;5;242m'; N='\e[0m'; C='\e[38;5;51m'

# Fungsi Bar Loading
bar(){ f=$(($1*14/100)); for i in $(seq 14); do
    [ $i -le $f ] && printf "${G}■${N}" || printf "${D}□${N}"
; done; }

n=$(nproc); l=$(cut -d' ' -f1-3 /proc/loadavg)
cp=$(awk -v l="$l" -v c=$n 'BEGIN{p=l/c*100;if(p>100)p=100;printf "%d",p}')
read mt mu <<< $(free -m | awk '/Mem/{print $2,$3}'); rp=$((mu*100/mt))
read dt du dp <<< $(df -h / | awk 'NR==2{print $2,$3,$5}')
model=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')
os=$(. /etc/os-release; echo $PRETTY_NAME)
jam=$(date +"%H:%M:%S WIB")

echo
echo -e "${C}  ╭──────────────────────────────────────────────╮${N}"
echo -e "${C}  │${N}          ${V}O M D U T A   C L O U D${N}           ${C}│${N}"
echo -e "${C}  ╰──────────────────────────────────────────────╯${N}"
echo
# Tulisan Besar (Toilet)
toilet -f future --filter gay "@OmdutaMd"
echo
echo -e "  ${G}● STATUS ONLINE${N}  │  ${Y}Hostname : ${hostname}${N}"
echo -e "  ${D}⏰ ${jam}${N}      │  ${Y}OS       : ${os}${N}"
echo
echo -e "  ${V}┌───[ ${Y}S P E K   M E S I N${V} ]───────────────────┐${N}"
echo -e "  ${V}│${N}  🧠 CPU    : ${D}${model}${N}"
echo -e "  ${V}│${N}  ⚙️  Cores  : ${n} vCPU"
echo -e "  ${V}│${N}  ⚡ Load   : ${l}"
echo -e "  ${V}└──────────────────────────────────────────────┘${N}"
echo
echo -e "  ${V}┌───[ ${Y}R E S O U R C E S${V} ]─────────────────────┐${N}"
echo -e "  ${V}│${N}  📊 CPU    : $(bar $cp) ${cp}%"
echo -e "  ${V}│${N}  💾 RAM    : $(bar $rp) ${rp}% (${mu}/${mt} MB)"
echo -e "  ${V}│${N}  💽 Disk   : $(bar ${dp%\%}) ${dp} (${du}/${dt})"
echo -e "  ${V}└──────────────────────────────────────────────┘${N}"
echo
echo -e "  ${V}┌───[ ${Y}K O N E K S I${V} ]───────────────────────┐${N}"
echo -e "  ${V}│${N}  🌐 IP     : ${Y}$(hostname -I | awk '{print $1}')${N}"
echo -e "  ${V}│${N}  🟢 Node   : $(node -v 2>/dev/null)"
echo -e "  ${V}└──────────────────────────────────────────────┘${N}"
echo
echo -e "  ${D}Ketik ${Y}vps${D} untuk menampilkan info ini lagi.${N}"
echo