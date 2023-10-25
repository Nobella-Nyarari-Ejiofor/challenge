In /etc/keepalived/check_apiserver.sh 
#To check if API Servers are reachable from the load balancer , if not switches the Virtual IP will get switched to another load balancer  

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q  {VIRTUAL_IP_ADDRESS}; then
  curl --silent --max-time 2 --insecure https://{VIRTUAL_IP_ADDRESS}:6443/ -o /dev/null || errorExit "Error GET https://{VIRTUAL_IP ADDRESS}/"
fi

#set excecutable permission  
chmod +x keepalived.conf 