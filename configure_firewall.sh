#!/bin/bash
# Brandväggskonfiguration + loggning

LOGFILE="/var/log/firewall_script.log"

log() {
    # Skriver både fil och systemlogg
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOGFILE" | logger -t firewall-script
}

log "=== Startar brandväggskonfiguration ==="

# Kontrollera att firewalld är igång
if ! systemctl is-active --quiet firewalld; then
    log "Firewalld är inte igång, startar tjänsten..."
    sudo systemctl start firewalld && log "Firewalld startad." || log "Misslyckades starta firewalld!"
fi

# Öppna port 22 (ssh)
log "Öppnar port 22/tcp (SSH)..."
sudo firewall-cmd --permanent --add-port=22/tcp && log "Port 22 öppen." || log "Kunde inte öppna port 22."

# Blockera port 80 (http)
log "Blockerar port 80/tcp (HTTP)..."
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --permanent --remove-port=80/tcp
log "Port 80 blockerad."

# Ladda om brandväggen för att aktivera ändringar
sudo firewall-cmd --reload && log "Firewalld laddades om."

# Visa status
log "Aktuella öppna portar:"
sudo firewall-cmd --list-ports | tee -a "$LOGFILE"

log "=== Brandväggskonfiguration klar ==="
