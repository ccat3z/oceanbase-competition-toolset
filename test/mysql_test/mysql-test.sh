#!/bin/bash
MYSQL_TEST_BIN=/u01/obclient/bin/mysqltest
TEST_BASE_DIR=$PWD
TEST_SUITE_DIR=$TEST_BASE_DIR/mysql_test/test_suite
#RECORD_RESULT="-r"
RECORD_RESULT=

OBMYSQL_MS0=127.0.0.1
OBMYSQL_PORT=${OBMYSQL_PORT:-2881}
OBMYSQL_USR=admin
OBMYSQL_PWD=admin
OBMYSQL_DB=test

SUITES=

export OBMYSQL_MS0
export OBMYSQL_PORT
export OBMYSQL_USR
export OBMYSQL_PWD
export OBMYSQL_DB

while getopts 's:' OPT;do
  case $OPT in
    s)
      SUITES="$OPTARG";;
    ?)
      echo "Usage `basename $0` [-s suite_name]"
  esac
done

if [ "x${SUITES}" == "x" ];
then
  SUITES=`ls $TEST_SUITE_DIR`
fi

obclient -h${OBMYSQL_MS0} -P${OBMYSQL_PORT} -uroot  -A -Doceanbase -e 'alter system set _enable_static_typing_engine = True;select sleep(2);'

for suite in $SUITES
do
  suite_dir=${TEST_SUITE_DIR}/${suite}
  for testname in `ls ${suite_dir}/t/*.test`
  do
    case=`basename $testname .test`
    echo test ${suite}.${case}
    begin=$[$(date +%s%N)]
    $MYSQL_TEST_BIN --host=${OBMYSQL_MS0} --port=${OBMYSQL_PORT} --tmpdir=$TEST_BASE_DIR/tmp --logdir=$TEST_BASE_DIR/var/log --silent --user=$OBMYSQL_USR@mysql --password=$OBMYSQL_PWD --database=$OBMYSQL_DB --timer-file=$TEST_BASE_DIR/var/log/timer --tail-lines=20 --max-connect-retries=3 --connect-timeout=10 --test-file=${suite_dir}/t/${case}.test  --result-file=${suite_dir}/r/mysql/${case}.result $RECORD_RESULT
    result_code=$?
    end=$[$(date +%s%N)]
    result_string='success'
    if [ $result_code -ne 0 ]
    then
      result_string='failed'
    fi
    echo test ${suite}.${case} done $result_string . cost $[(end-begin)/1000000] ms
    if [ $result_code -ne 0 ]
    then
      echo "Bye"
      exit 1
    fi
  done
done
