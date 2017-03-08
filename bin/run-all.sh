#!/bin/bash

DIRNAME=`dirname $0`
RUNHOME=`cd $DIRNAME/;pwd`

APP_NAME=smartsight
APP_VERSION=v1.3.1
STEPS=10
STEP=0

show_version()
{
	echo -e "\n"
	echo "*******************************************************"
	echo "                   smartsight-v1.3.1                   "
	echo "*******************************************************"
}

check_java()
{
	if [ -z "$JAVA_HOME" ];then
		echo -e "---the env parameter \"JAVA_HOME\" is not setted.---"
		exit 1
	elif [ ! -f $JAVA_HOME/bin/java ];then
		echo -e "---the env parameter \"JAVA_HOME\" is not setted correctly.---"
		exit 1
	fi
}

check_hbase()
{
	check_process_port_and_name 2181 hbase
	if [ $status -eq 0 ];then
		if [ ! -z $HBASE_HOME ] && [ -f $HBASE_HOME/bin/hbase ];then			
			$HBASE_HOME/bin/start-hbase.sh > /dev/null
			
			sleep 3s
			$HBASE_HOME/bin/hbase shell $RUNHOME/infra/init-hbase.txt > /dev/null
		else
			echo "---hbase is not running, please check---"
			exit 1
		fi
	else
		#echo "---hbase is already running---"

		pid=$(lsof -i :2181 | grep LISTEN | grep -v grep | awk '{print $2}')
		process=$(ps -ef | grep $pid | grep -v grep)

		HBASE_HOME=${process##*-Dhbase.home.dir=}
		HBASE_HOME=${HBASE_HOME%% *}

		$HBASE_HOME/bin/hbase shell $RUNHOME/infra/init-hbase.txt > /dev/null
	fi
}

check_process_port_and_name()
{
	# 1---ok 0---ng
	status=0
	port_status=$(lsof -i :$1 | grep LISTEN | grep -v grep | wc -l)
	if [ ! $port_status -eq 0 ];then
		pid=$(lsof -i :$1 | grep LISTEN | grep -v grep | awk '{print $2}')
		process_status=$(ps -ef | grep $pid | grep -v grep | grep $2 | wc -l)
		if [ ! $process_status -eq 0 ];then
			status=1
		else
			status=0
		fi
	else
		status=0
	fi
}

print_step()
{
	NAME=$1
	if [ ! -z "$NAME" ];then
		STEP=$(expr $STEP + 1)
		echo "############### step $STEP/$STEPS : starting $NAME ###############"
	fi
}

run_sh()
{
	print_step $1	

	SHELL_FILE=$2
	if [ -f "$SHELL_FILE" ];then
	        $SHELL_FILE
	else
	        echo "---can not find $SHELL_FILE---"
	fi
}

start_nfvtrace()
{
	print_step nfvtrace

	## start with agent ##
	DEST_PATH=/home/test/version/smartsight-agent
	mkdir -p $DEST_PATH
	rm -rf $DEST_PATH/*
	AGENT_PACKAGE=`basename $RUNHOME/agent/*.zip`
	unzip -q -d $DEST_PATH $RUNHOME/agent/$AGENT_PACKAGE

	run_sh "" $RUNHOME/nfvtrace/start-nfvtrace.sh
}

start_dbmonitor()
{
	print_step dbmonitor

        # dbmonitor-agent
	run_sh "" $RUNHOME/dbmonitor/agent/start-dbmonitor-agent.sh

	# dbmonitor-collector
	run_sh "" $RUNHOME/dbmonitor/collector/start-dbmonitor-collector.sh
}

start_phoenixolap()
{
	print_step phoenixolap

	run_sh "" $RUNHOME/nfvtrace/start-phoenixolap.sh
}


show_version
check_java
check_hbase

run_sh kafka $RUNHOME/kafka/start-kafka.sh
run_sh logstash $RUNHOME/logstash/start-logstash.sh

run_sh collector $RUNHOME/collector/start-collector.sh
run_sh kernel $RUNHOME/kernel/start-kernel.sh
run_sh portal $RUNHOME/portal/start-portal.sh

run_sh cep $RUNHOME/cep/start-cep.sh
run_sh policy $RUNHOME/policy/start-policy.sh
start_nfvtrace
start_dbmonitor
run_sh middlewares $RUNHOME/middlewares/start-middlewares.sh

start_phoenixolap

run_sh "" $RUNHOME/check-all.sh
