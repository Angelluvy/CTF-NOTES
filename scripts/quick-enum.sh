#!/bin/bash
# quick-enum.sh - varredura básica
if [ -z "$1" ]; then
  echo "Usage: ./quick-enum.sh <IP_or_range>"
  exit 1
fi
TARGET=$1
mkdir -p enum_${TARGET}
echo "[*] Ping scan"
nmap -sn ${TARGET} -oN enum_${TARGET}/ping.txt
echo "[*] Full TCP scan"
nmap -sS -sV -p- -T4 ${TARGET} -oN enum_${TARGET}/full_nmap.txt
echo "[*] Top 100 ports"
nmap --top-ports 100 -sS -sV -T4 ${TARGET} -oN enum_${TARGET}/top100_nmap.txt
echo "[*] Check HTTP common ports"
for port in 80 443 8080 8000 8008; do
  curl -I --max-time 5 http://${TARGET}:$port 2>/dev/null >> enum_${TARGET}/http_headers.txt || true
done
echo "[*] Done. Results in enum_${TARGET}/"
