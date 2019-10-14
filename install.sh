apt-get install apt-transport-https
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
apt update
apt -y  install default-jre
apt -y  install elasticsearch
vim /etc/elasticsearch/elasticsearch.yml
   discovery.type: single-node
   network.host: 0.0.0.0
systemctl start elasticsearch

wget https://raw.githubusercontent.com/amadureira/scripts/master/gera.sh
chmod 0755 gera.sh
apt install bc
./gera.sh $(date +%s | sed 's;^\([0-9]\+\);\1-21600;g'  |bc)  $(date +%s)  60 host-1 'uso de cpu'  99 2
./gera.sh $(date +%s | sed 's;^\([0-9]\+\);\1-21600;g'  |bc)  $(date +%s)  60 host-2 'uso de cpu'  99 2
./gera.sh $(date +%s | sed 's;^\([0-9]\+\);\1-21600;g'  |bc)  $(date +%s)  60 host-3 'uso de cpu'  99 2

wget https://dl.grafana.com/oss/release/grafana_6.4.2_amd64.deb
dpkg -i grafana_6.4.2_amd64.deb
systemctl start grafana-server


while true; 
do 
    INI=$( date +%s -d '1 minute ago'  )
    END=$( date +%s )
   ./gera.sh ${INI}  ${END}  60 host-1 'uso de cpu'  99 2;
   ./gera.sh ${INI}  ${END}  60 host-2 'uso de cpu'  99 2;  
   ./gera.sh ${INI}  ${END}  60 host-3 'uso de cpu'  99 2; 
   sleep 60 ;
done
