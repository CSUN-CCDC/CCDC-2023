
apt install nginx -y

cat > /etc/nginx/sites-enabled/default  <<'EOF'
server {
server_name _;
location / { proxy_pass http://localhost:8080; }
}
EOF

nginx -s reload

#installing open-appsec for NGINX

#Downloading open-appsec for Nginx instal script:
wget https://downloads.openappsec.io/open-appsec-install && chmod +x open-appsec-install

#Run the script
./open-appsec-install --auto --detect-learn

#--auto will download the relevant software and add open-appsec to NGINX.

#Example Commands:
#open-appsec-ctl --status
#open-appsec-ctl --list-policies
#open-appsec-ctl --view-policy
#open-appsec-ctl --edit-policy
#open-appsec-ctl --apply-policy
#open-appsec-ctl --view-logs
#open-appsec-ctl --stop-agent
#open-appsec-ctl --start-agent
