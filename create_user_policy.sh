#!/bin/bash
# Skapar en användare med begränsade rättigheter och sätter lösenordspolicy

# Fråga efter användarnamn
read -p "Ange nytt användarnamn: " USERNAME

# Kontrollera om användaren redan finns
if id "$USERNAME" &>/dev/null; then
    echo "Användaren $USERNAME finns redan."
    exit 1
fi

# Skapa användare utan hemkatalog
sudo useradd -m -s /bin/bash "$USERNAME"
echo "Användare $USERNAME skapad."

# Sätt lösenord
echo "Sätt ett lösenord för $USERNAME:"
sudo passwd "$USERNAME"

# Ställ in lösenordspolicy globalt med minimum längd och giltighetsperiod
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN     10/' /etc/login.defs

echo "Lösenordspolicy uppdaterad (max 90 dagar, min 10 tecken)."

# Tillämpa giltighetstid för just denna användare
sudo chage -M 90 -m 1 "$USERNAME"
sudo chage -l "$USERNAME"

echo "Lösenordspolicy tillämpad på $USERNAME."
