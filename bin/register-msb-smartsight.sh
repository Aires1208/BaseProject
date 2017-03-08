#!/bin/bash
set -e

echo "############ register smartsight server on msb #############"

if [ $# -lt 3 ];then
  echo "USAGE: $0 MSB_IP MSB_PORT SMARTSIGHT_SERVER_IP NAMESPACE"
  exit 1
else
  MSB_IP=$1
  MSB_PORT=$2
  SERVER_IP=$3
  
  if [ $# -eq 3 ];then
    NAMESPACE="ranoss"
  else
    NAMESPACE=$4
  fi
fi

[ -z "${MSB_PORT}" ] && MSB_PORT="80"

register_msb(){
  NAME=$1
  VERSION=$2
  PROTOCOL=$3
  INSTANCE_PORT=$4
  PUBLISH_PORT=$5
  URL=$6

  JSON='{"serviceName":"'"${NAME}"'", "version":"'"${VERSION}"'", "url":"'"${URL}"'", "protocol":"'"${PROTOCOL}"'","namespace":"'"${NAMESPACE}"'","network_plane_type":"net_api" , "publish_port":"'"${PUBLISH_PORT}"'", "visualRange":"0|1", "lb_policy":"", "nodes":[{"ip":"'"${SERVER_IP}"'", "port":"'"${INSTANCE_PORT}"'"}]}'
  
  response=$(curl http://${MSB_IP}:${MSB_PORT}/api/msdiscover/v1/services?createOrUpdate=false --noproxy ${MSB_IP} -X POST -i -H 'Content-Type:application/json' -H 'Accept:application/json' -d "${JSON}")
  
  if [[ "$response" =~ "true" ]];then
     echo "------ ${NAME}: success to register on msb ------"
  else
     echo "------ ${NAME}: fail to register on msb ------"
  fi
}


#########################################
##############  main ####################
#########################################
register_msb smartsight-logstash-tcp v1 TCP 29993 29993  /
register_msb smartsight-collector-tcp v1 TCP 29994 29994 /
register_msb smartsight-logstash-stat v1 UDP 29995 29995 /
register_msb smartsight-logstash-span v1 UDP 29996 29996 /
register_msb smartsight-logstash-nfv v1 UDP 39995 28995 /
register_msb smartsight-collector-python v1 REST 8085 "" /zipkin/api/v1

