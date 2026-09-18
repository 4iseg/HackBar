#!/usr/bin/env bash
set -euo pipefail

APP_NAME="kali-xfce-bar"
CFG_DIR="$HOME/.config/$APP_NAME"
PLUGIN_ID_FILE="$CFG_DIR/plugin-id"
PANEL_ID_FILE="$CFG_DIR/panel-id"

if [ "${EUID}" -eq 0 ]; then
  echo "[!] Ejecuta este desinstalador como tu usuario normal, no como root."
  exit 1
fi

if [ -s "$PLUGIN_ID_FILE" ] && [ -s "$PANEL_ID_FILE" ]; then
  PLUGIN_ID="$(cat "$PLUGIN_ID_FILE")"
  PANEL_ID="$(cat "$PANEL_ID_FILE")"
  PANEL_PATH="/panels/panel-$PANEL_ID/plugin-ids"

  if xfconf-query -c xfce4-panel -p "$PANEL_PATH" >/dev/null 2>&1; then
    mapfile -t ids < <(xfconf-query -c xfce4-panel -p "$PANEL_PATH" | grep -E '^[0-9]+$' | grep -vx "$PLUGIN_ID" || true)
    xfconf-query -c xfce4-panel -p "$PANEL_PATH" -rR
    if [ "${#ids[@]}" -gt 0 ]; then
      args=()
      for id in "${ids[@]}"; do
        args+=( -t int -s "$id" )
      done
      xfconf-query -c xfce4-panel -p "$PANEL_PATH" "${args[@]}" --create
    fi
  fi

  xfconf-query -c xfce4-panel -p "/plugins/plugin-$PLUGIN_ID" -rR 2>/dev/null || true
fi

rm -f "$HOME/.local/bin/kali-panel-info" "$HOME/.local/bin/target"
rm -rf "$CFG_DIR"

xfce4-panel -r >/dev/null 2>&1 || true

echo "[+] Kali XFCE Info Bar desinstalada."
echo "[i] xfce4-genmon-plugin se conserva por si lo usan otros elementos del panel."
