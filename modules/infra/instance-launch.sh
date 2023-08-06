#!/bin/bash
sudo apt update -y
sudo apt install apache2 nginx -y
sudo echo '<h1 STYLE="color: blue">Serveur $HOSTNAME</h1>' > /var/www/html/index.html
