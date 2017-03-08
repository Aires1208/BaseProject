#!/bin/bash

check_service()
{
	port_status=$(lsof -i :$1 | grep LISTEN | grep -v grep | wc -l)
	if [ ! $port_status -eq 0 ];then
		pid=$(lsof -i :$1 | grep LISTEN | grep -v grep | awk '{print $2}')
		process_status=$(ps -ef | grep $pid | grep $2 | grep -v grep | wc -l)
		if [ ! $process_status -eq 0 ];then
			printf "%-45s %2s\n" "$2 Port:$1, Pid:$pid" "----- OK"
		else
			printf "%-45s %2s\n" "$2 Port:$1" "----- NG"
		fi
	else
		printf "%-45s %2s\n" "$2 Port:$1" "----- NG"
	fi
}

echo "=============Check SmartSight Service Status============"
check_service 2181 hbase
check_service 9092 kafka
check_service 29993 logstash

check_service 8085 collector
check_service 8084 kernel
check_service 8080 portal

check_service 8083 policy
check_service 8082 nfvtrace
check_service 38205 dbmonitor-agent
check_service 8081 dbmonitor-collector
check_service 8089 middlewares
check_service 9090 cep
echo "========================================================"

