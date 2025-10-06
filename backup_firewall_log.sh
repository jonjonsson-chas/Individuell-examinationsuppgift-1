#!/bin/bash
# Skrip som skriver backup av brandväggsloggar

SOURCE="/var/log/firewall_script.log"
DEST_DIR="/var/backups/firewall_logs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DEST_FILE="$DEST_DIR/firewall_script_$TIMESTAMP.log"

# Kontrollera om loggfilen redan finns
if [ ! -f "$SOURCE" ]; then
    echo "[$(date)] Loggfil saknas: $SOURCE" | logger -t firewall-backup
    exit 1
fi

# Skapa backup-mapp om den inte finns
mkdir -p "$DEST_DIR"

# Kopiera filen med tidsstämpel
cp "$SOURCE" "$DEST_FILE"

# Logga resultat
if [ $? -eq 0 ]; then
    echo "[$(date)] Backup skapad: $DEST_FILE" | logger -t firewall-backup
else
    echo "[$(date)] Backup misslyckades!" | logger -t firewall-backup
fi

# Ta bort filer äldre än 7 dagar
find "$DEST_DIR" -type f -mtime +7 -name "firewall_script_*.log" -delete
