#!/bin/bash

echo "---------------------------------------------------------------" 
echo "$(date)"
echo "Starting installation..."

echo "---------------------------------------------------------------" 
echo "Installing Elasticsearch..."

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && sudo apt-get install elasticsearch -y

echo "---------------------------------------------------------------" 
echo "Configuring Elasticsearch..."

EPATH="/etc/elasticsearch/elasticsearch.yml"

sudo sed -i 's/#node.name:/node.name:/' $EPATH
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' $EPATH
sudo sed -i 's/#http.port: 9200/http.port: 9200/' $EPATH
sudo sed -i 's/#discovery.seed_hosts: ["host1", "host2"]/discovery.seed_hosts ["127.0.0.1"]/' $EPATH
sudo sed -i 's/#cluster.initial_master_nodes: \["node\-1", "node\-2"\]/cluster.initial_master_nodes: \["node\-1"\]/' $EPATH

sudo service elasticsearch start
sudo systemctl is-active --quiet elasticsearch && echo "Elasticsearch service is up."

CURL_OUTPUT=$(curl -X GET http://localhost:9200/?pretty)

if [[ $? -eq "0" ]]
then
    echo "Elasticsearch complete!"
fi

echo "---------------------------------------------------------------" 
echo "Installing Kibana..."

sudo apt-get update && sudo apt install kibana -y

KPATH="/etc/kibana/kibana.yml"

sudo sed -i 's/#server.host: "localhost"/server.host: 0.0.0.0/' $KPATH

sudo service kibana start
sudo systemctl is-active --quiet kibana && echo "Kibana service is up."