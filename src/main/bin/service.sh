#!/usr/bin/env bash

# set bin path
APP_HOME_BIN=`dirname $0`

# set app home
APP_HOME=${APP_HOME_BIN}/..

# set main class
APP_MAIN_CLASS=com.xxx.collector.Collector

# set lib path
APP_HOME_LIB=${APP_HOME}/lib

# set config path
APP_HOME_CONFIG=${APP_HOME}/config

# set log path
APP_HOME_LOG=${APP_HOME}/log

# set JAVA_HOME
JAVA_HOME=${JAVA_HOME}

# set CLASSPATH
CLASSPATH=${CLASSPATH}
for i in "$APP_HOME_LIB"/*.jar; do
   CLASSPATH="${CLASSPATH}":"$i"
done

# set JVM options
JAVA_OPTS=""
JAVA_OPTS=${JAVA_OPTS}"-DAPP_HOME=${APP_HOME} "
JAVA_OPTS=${JAVA_OPTS}"-Dlog4j.properties=${APP_HOME_CONFIG}/log4j.properties "

# get process pid
JPS_ID=0

# check and set pid to ${JPS_ID}
check_pid() {
    java_ps=`${JAVA_HOME}/bin/jps -l | grep ${APP_MAIN_CLASS}`
    if [ -n "${java_ps}" ]; then
        JPS_ID=`echo ${java_ps} | awk '{print $1}'`
    else
        JPS_ID=0
    fi
}

# start process foreground
debug() {
    check_pid

    if [ ${JPS_ID} -ne 0 ]; then
        echo "============================================="
        echo "warn: ${APP_MAIN_CLASS} already started! (pid=${JPS_ID})"
        echo "============================================="
    else
        echo "Starting $APP_MAIN_CLASS foreground..."
        ${JAVA_HOME}/bin/java ${JAVA_OPTS} -classpath ${CLASSPATH} ${APP_MAIN_CLASS}
    fi
}

# start process
start() {
    check_pid

    if [ ${JPS_ID} -ne 0 ]; then
        echo "============================================="
        echo "warn: ${APP_MAIN_CLASS} already started! (pid=${JPS_ID})"
        echo "============================================="
    else
        echo -n "Starting $APP_MAIN_CLASS ..."
        nohup ${JAVA_HOME}/bin/java ${JAVA_OPTS} -classpath ${CLASSPATH} ${APP_MAIN_CLASS} >/dev/null 2>&1 &

        check_pid

        if [ ${JPS_ID} -ne 0 ]; then
            echo "(pid=${JPS_ID}) [OK]"
        else
            echo "[Failed]"
        fi
    fi
}

# stop process
stop() {
    check_pid

   if [ ${JPS_ID} -ne 0 ]; then
        echo -n "Stopping ${APP_MAIN_CLASS} ...(pid=${JPS_ID}) "
        kill -9 ${JPS_ID}
        if [ $? -eq 0 ]; then
             echo "[OK]"
        else
            echo "[Failed]"
        fi

        check_pid
        if [ ${JPS_ID} -ne 0 ]; then
            stop
        fi
   else
        echo "============================================="
        echo "warn: ${APP_MAIN_CLASS} is not running"
        echo "============================================="
   fi
}

# get process status
status() {
    check_pid

    if [ ${JPS_ID} -ne 0 ];  then
        echo "${APP_MAIN_CLASS} is running! (pid=${JPS_ID})"
    else
        echo "${APP_MAIN_CLASS} is not running"
    fi
}

# get system info
info() {
    echo "system information:"
    echo "*************************************************"
    echo `head -n 1 /etc/issue`
    echo `uname -a`
    echo
    echo "JAVA_HOME=${JAVA_HOME}"
    echo `${JAVA_HOME}/bin/java -version`
    echo
    echo "APP_HOME=${APP_HOME}"
    echo "APP_MAIN_CLASS=${APP_MAIN_CLASS}"
    echo "*************************************************"
}

case "$1" in
    'debug')
        debug
        ;;
    'start')
        start
        ;;
   'stop')
        stop
        ;;
   'restart')
        stop
        start
        ;;
   'status')
        status
        ;;
   'info')
        info
        ;;
   *)
        echo "Usage: $0 {debug|start|stop|restart|status|info}"
        exit 1
esac
