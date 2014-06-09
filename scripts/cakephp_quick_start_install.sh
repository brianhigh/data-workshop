#!/bin/bash

# Simplistic "quick start" script for new CakePHP users and demos.

# Requires that you have a database with CakePHP naming conventions.
# Assumes you have Apache, PHP, and mod_rewrite components working.
# Recommended: Configure Apache for redirect to SSL port for non-SSL.
# Note: Example configuration is for use with public_html web root.
# Also requires perl, git and apg: sudo apt-get install perl git apg
# Downloads CakePHP and configures for your web app (mostly defaults).
# Sets up basic auth. for your own username to your web root folder.
# Works with the latest CakePHP from GitHub as of 2014-06-09.

# Last modified by Brian High <high@uw.edu> on 2014-06-09.

# Initialize folder and group varables
APP_FOLDER='lab'
WEB_ROOT=~/public_html
WEB_ROOT_PATH=~$USER
WEB_GROUP='www-data'

# Prepare web root folder
mkdir -p "$WEB_ROOT"
chmod 2755 "$WEB_ROOT"
cd "$WEB_ROOT"

# Get CakePHP if not already downloaded
test -d cakephp || git clone git://github.com/cakephp/cakephp.git

# Remove app folder if already present
test -d "$APP_FOLDER" && rm -rf "$APP_FOLDER"

# Copy CakePHP to "$APP_FOLDER"
cp -R cakephp "$APP_FOLDER"
cd "$APP_FOLDER"

# Create .htaccess files so CakePHP will work with public_html folder
cat << EOF > .htaccess
<IfModule mod_rewrite.c>
    RewriteEngine on
    RewriteRule    ^$    webroot/    [L]
    RewriteRule    (.*) webroot/\$1    [L]
    RewriteBase    /$WEB_ROOT_PATH/$APP_FOLDER/app/
 </IfModule>
EOF

cat << EOF > app/.htaccess
<IfModule mod_rewrite.c>
    RewriteEngine on
    RewriteRule    ^$    webroot/    [L]
    RewriteRule    (.*) webroot/\$1    [L]
    RewriteBase    /$WEB_ROOT_PATH/$APP_FOLDER/app/
</IfModule>
EOF

cat << EOF > app/webroot/.htaccess
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond    %{REQUEST_FILENAME} !-d
    RewriteCond    %{REQUEST_FILENAME} !-f
    RewriteRule    ^ index.php [L]
    RewriteBase    /$WEB_ROOT_PATH/$APP_FOLDER/app/webroot/
</IfModule>
EOF

cd app

# Prompt for database (DB) connection variables
read -p "Enter DB Username: " DBUSERNAME
read -s -p "Enter DB Password: " DBPASSWORD
echo
read -p "Enter DB Name: " DBNAME
read -p "Enter DB Host: " DBHOST

# Create custom database.php file
cat << EOF > Config/database.php
<?php
class DATABASE_CONFIG {

        var \$default = array(
                'datasource' => 'Database/Mysql',
                'persistent' => false,
                'host' => '$DBHOST',
                'login' => '$DBUSERNAME',
                'password' => '$DBPASSWORD',
                'database' => '$DBNAME',
                'prefix' => '',
        );
}
EOF

# Bake the app with default settings
chmod u+x Console/cake
for i in model controller view; do \
    Console/cake bake $i all
done

# Change the security salt and cipher seed
cd Config
SALT=$(apg -n 1 -m 41 -x 41)
perl -pi -e "s/\.salt', '.*'/\.salt', '$SALT'/g;" core.php
SEED=$(apg -a 1 -n 1 -M n -m 29 -x 29)
perl -pi -e "s/\.cipherSeed', '.*'/\.cipherSeed', '$SEED'/g;" core.php

# Set up basic web auth
cd "$WEB_ROOT"
echo "Setting up username=$USER for basic web authentication..."
htpasswd -c .htpasswd $USER
cat << EOF > .htaccess
Options -Indexes
AuthUserFile $(pwd)/.htpasswd
AuthType Basic
AuthName "$USER - Restricted Access"
Require valid-user
<Files ~ "^.ht">
Order allow,deny
Deny from all
</Files>
EOF

# Set permissions -- local users may still read your Config files
cd "$WEB_ROOT"
chmod -R o+w "$APP_FOLDER"/app/tmp

# Set permissions more securely -- requires sudo if not in WEB_GROUP
cd "$WEB_ROOT"
sudo chgrp -R $WEB_GROUP "$APP_FOLDER"
sudo find "$APP_FOLDER" -type f -exec chmod 0640 "{}" \;
sudo find "$APP_FOLDER" -type d -exec chmod 2750 "{}" \;
sudo chmod -R g+w "$APP_FOLDER"/app/tmp
chmod u+x "$APP_FOLDER"/app/Console/cake
sudo chgrp $WEB_GROUP .ht* && chmod 640 .ht*
