#!/bin/bash

kill_service_by_port()
{
	for pid in $(lsof -i :$1 | grep LISTEN | grep -v grep | awk '{print $2}');do
		echo "kill $2 process.$pid"
		kill -9 $pid
		sleep 0.5s
	done
}

kill_service_by_name()
{
	for pid in $(ps -ef | grep $1 | grep -v grep | awk '{print $2}');do
		echo "kill $1 process.$pid"
		kill -9 $pid
		sleep 0.5s
	done
}


echo "=============Stop SmartSight Service============="
#kill_service_by_port 2181 hbase
kill_service_by_port 9092 kafka
kill_service_by_port 29993 logstash

kill_service_by_port 8085 collector
kill_service_by_port 8084 kernel
kill_service_by_port 8080 portal
kill_service_by_name tomcat

kill_service_by_port 8083 policy
kill_service_by_port 8082 nfvtrace
kill_service_by_port 38205 dbmonitor-agent
kill_service_by_port 8081 dbmonitor-collector
kill_service_by_port 8089 middlewares
kill_service_by_port 9090 cep

kill_service_by_port 8086 phoenixolap

echo "================================================="

