#!/usr/bin/env bash
set -euo pipefail

APP_NAME="hackbar"
BIN_DIR="$HOME/.local/bin"
CFG_DIR="$HOME/.config/$APP_NAME"
INFO_BIN="$BIN_DIR/hackbar-info"
TARGET_BIN="$BIN_DIR/target"

if [ "${EUID}" -eq 0 ]; then
  echo "[!] Ejecuta este instalador como tu usuario normal de Kali, no como root."
  exit 1
fi

if [ "${XDG_CURRENT_DESKTOP:-}" != "XFCE" ] && ! pgrep -x xfce4-panel >/dev/null 2>&1; then
  echo "[!] No parece haber una sesión XFCE activa."
  echo "    HackBar está pensado para Kali Linux con XFCE."
  exit 1
fi

echo "[+] HackBar"
echo "[+] Comprobando dependencias..."

if ! command -v xfconf-query >/dev/null 2>&1; then
  echo "[!] No se encuentra xfconf-query."
  exit 1
fi

if ! dpkg -s xfce4-genmon-plugin >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y xfce4-genmon-plugin
fi

mkdir -p "$BIN_DIR" "$CFG_DIR"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install -m 0755 "$SCRIPT_DIR/src/hackbar-info" "$INFO_BIN"
install -m 0755 "$SCRIPT_DIR/src/target" "$TARGET_BIN"

for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  touch "$rc"
  if ! grep -Fq 'export PATH="$HOME/.local/bin:$PATH"' "$rc"; then
    printf '\n# HackBar\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$rc"
  fi
done

if [ -s "$CFG_DIR/plugin-id" ]; then
  old_id="$(cat "$CFG_DIR/plugin-id")"
  if xfconf-query -c xfce4-panel -p "/plugins/plugin-$old_id" 2>/dev/null | grep -qx 'genmon'; then
    echo "[+] HackBar ya está instalada (genmon-$old_id)."
    echo "[+] Scripts actualizados."
    xfce4-panel --plugin-event="genmon-$old_id:refresh:bool:true" >/dev/null 2>&1 || true
    echo "[+] Usa: target 10.0.2.22"
    exit 0
  fi
fi

mapfile -t panels < <(xfconf-query -c xfce4-panel -p /panels 2>/dev/null | grep -E '^[0-9]+$')
if [ "${#panels[@]}" -eq 0 ]; then
  echo "[!] No se ha encontrado ningún panel XFCE."
  exit 1
fi

PANEL_ID="${panels[0]}"
PANEL_PATH="/panels/panel-$PANEL_ID/plugin-ids"
mapfile -t plugin_ids < <(xfconf-query -c xfce4-panel -p "$PANEL_PATH" 2>/dev/null | grep -E '^[0-9]+$')

max_id=0
for id in "${plugin_ids[@]}"; do
  (( id > max_id )) && max_id=$id
done
PLUGIN_ID=$((max_id + 1))

xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID" \
  -t string -s "genmon" --create
xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID/command" \
  -t string -s "$INFO_BIN" --create
xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID/update-period" \
  -t int -s 2000 --create
xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID/use-label" \
  -t bool -s false --create
xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID/enable-single-row" \
  -t bool -s true --create
xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID/font" \
  -t string -s "Monospace 8" --create

new_ids=()
inserted=0
for id in "${plugin_ids[@]}"; do
  type="$(xfconf-query -c xfce4-panel -p "/plugins/plugin-$id" 2>/dev/null || true)"
  if [ "$inserted" -eq 0 ] && [ "$type" = "clock" ]; then
    new_ids+=("$PLUGIN_ID")
    inserted=1
  fi
  new_ids+=("$id")
done
if [ "$inserted" -eq 0 ]; then
  new_ids+=("$PLUGIN_ID")
fi

xfconf-query -c xfce4-panel -p "$PANEL_PATH" -rR
args=()
for id in "${new_ids[@]}"; do
  args+=( -t int -s "$id" )
done
xfconf-query -c xfce4-panel -p "$PANEL_PATH" "${args[@]}" --create

printf '%s\n' "$PLUGIN_ID" > "$CFG_DIR/plugin-id"
printf '%s\n' "$PANEL_ID" > "$CFG_DIR/panel-id"

xfce4-panel -r
sleep 2

echo
echo "[+] HackBar instalada."
echo "[+] Target:  target 10.0.2.22"
echo "[+] Ver:     target"
echo "[+] Borrar:  target clear"
echo "[+] Abre una terminal nueva para usar 'target' sin ruta completa."
