#!/bin/bash
set -e

echo "############ unregister smartsight server on msb #############"

if [ $# -lt 2 ];then
  echo "USAGE: $0 MSB_IP MSB_PORT VERSION NAMESPACE"
  exit 1
else
  MSB_IP=$1
  MSB_PORT=$2

  if [ $# -eq 2 ];then
    VERSION=v1
    NAMESPACE="ranoss"
  elif [ $# -eq 3 ];then
    VERSION=$3
    NAMESPACE="ranoss"
  else
    VERSION=$3
    NAMESPACE=$4
  fi
fi

[ -z "${MSB_PORT}" ] && MSB_PORT="80"
[ -z "${VERSION}" ] && VERSION=v1
[ -z "${NAMESPACE}" ] && NAMESPACE="ranoss"

unregister_msb(){
  if [ "${VERSION}" != "v1" ];then
    NAME=$1_$VERSION
  else
    NAME=$1
  fi

  response_code=$(curl http://${MSB_IP}:${MSB_PORT}/api/msdiscover/v1/services/${NAME}/version/${VERSION}?namespace=${NAMESPACE} --noproxy ${MSB_IP} -X DELETE -w %{http_code})
  if [ "$response_code" = "204"  ];then
    echo "------ ${NAME}: success to unregister on msb ------"
  else
    echo "------ ${NAME}: fail to unregister on msb ------"
  fi
}


#########################################
##############  main ####################
#########################################
unregister_msb smartsight-logstash-tcp
unregister_msb smartsight-collector-tcp
unregister_msb smartsight-logstash-stat
unregister_msb smartsight-logstash-span
unregister_msb smartsight-logstash-nfv
unregister_msb smartsight-collector-python

