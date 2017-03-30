#!/bin/bash

declare -r color_start="\033["
declare -r color_red="${color_start}0;31m"
declare -r color_green="${color_start}0;32m"
declare -r color_blue="${color_start}0;34m"
declare -r color_norm="${color_start}0m"

GRADER_ROOT=$(dirname ${BASH_SOURCE})

PROJECT_PATH=${GRADER_ROOT}/..

function print_dir_contents {
  local proj_path=$1
  echo "Project contents:"
  echo -e "${color_blue}$(ls ${proj_path})${color_norm}"
}

function find_file_or_dir_in_project {
  local proj_path=$1
  local file_or_dir_name=$2
  if [[ ! -e "${proj_path}/${file_or_dir_name}" ]]; then
    echo -e "[${color_red}FAIL${color_norm}]: no ${file_or_dir_name} found"
    print_dir_contents ${proj_path}
    echo -e "${color_red}${file_or_dir_name} [MISSING]${color_norm}"
    exit 1
  fi
}

# check project directory structure
function check_project_struct {
  find_file_or_dir_in_project ${PROJECT_PATH} run.sh
  find_file_or_dir_in_project ${PROJECT_PATH} src
  find_file_or_dir_in_project ${PROJECT_PATH} log_input
  find_file_or_dir_in_project ${PROJECT_PATH} log_output
}

# setup testing output folder
function setup_testing_input_output {
  TEST_OUTPUT_PATH=${GRADER_ROOT}/temp
  if [ -d ${TEST_OUTPUT_PATH} ]; then
    rm -rf ${TEST_OUTPUT_PATH}
  fi

  mkdir -p ${TEST_OUTPUT_PATH}

  cp -r ${PROJECT_PATH}/src ${TEST_OUTPUT_PATH}
  cp -r ${PROJECT_PATH}/run.sh ${TEST_OUTPUT_PATH}
  cp -r ${PROJECT_PATH}/log_input ${TEST_OUTPUT_PATH}
  cp -r ${PROJECT_PATH}/log_output ${TEST_OUTPUT_PATH}

  rm -r ${TEST_OUTPUT_PATH}/log_input/*
  rm -r ${TEST_OUTPUT_PATH}/log_output/*
  cp -r ${GRADER_ROOT}/tests/${test_folder}/log_input/log.txt ${TEST_OUTPUT_PATH}/log_input/log.txt
}

function compare_outputs {
  PROJECT_ANSWER_PATH1=${GRADER_ROOT}/temp/log_output/hosts.txt
  PROJECT_ANSWER_PATH2=${GRADER_ROOT}/temp/log_output/resources.txt
  PROJECT_ANSWER_PATH3=${GRADER_ROOT}/temp/log_output/hours.txt
  PROJECT_ANSWER_PATH4=${GRADER_ROOT}/temp/log_output/blocked.txt
  TEST_ANSWER_PATH1=${GRADER_ROOT}/tests/${test_folder}/log_output/hosts.txt
  TEST_ANSWER_PATH2=${GRADER_ROOT}/tests/${test_folder}/log_output/resources.txt
  TEST_ANSWER_PATH3=${GRADER_ROOT}/tests/${test_folder}/log_output/hours.txt
  TEST_ANSWER_PATH4=${GRADER_ROOT}/tests/${test_folder}/log_output/blocked.txt

  DIFF_RESULT1=$(diff -bB ${PROJECT_ANSWER_PATH1} ${TEST_ANSWER_PATH1} | wc -l)
  if [ "${DIFF_RESULT1}" -eq "0" ] && [ -f ${PROJECT_ANSWER_PATH1} ]; then
    echo -e "[${color_green}PASS${color_norm}]: ${test_folder} (hosts.txt)"
    PASS_CNT=$(($PASS_CNT+1))
  else
    echo -e "[${color_red}FAIL${color_norm}]: ${test_folder} (hosts.txt)"
    diff ${PROJECT_ANSWER_PATH1} ${TEST_ANSWER_PATH1}
  fi

  DIFF_RESULT2=$(diff -bB ${PROJECT_ANSWER_PATH2} ${TEST_ANSWER_PATH2} | wc -l)
  if [ "${DIFF_RESULT2}" -eq "0" ] && [ -f ${PROJECT_ANSWER_PATH2} ]; then
    echo -e "[${color_green}PASS${color_norm}]: ${test_folder} (resources.txt)"
    PASS_CNT=$(($PASS_CNT+1))
  else
    echo -e "[${color_red}FAIL${color_norm}]: ${test_folder} (resources.txt)"
    diff ${PROJECT_ANSWER_PATH2} ${TEST_ANSWER_PATH2}
  fi

  DIFF_RESULT3=$(diff -bB ${PROJECT_ANSWER_PATH3} ${TEST_ANSWER_PATH3} | wc -l)
  if [ "${DIFF_RESULT3}" -eq "0" ] && [ -f ${PROJECT_ANSWER_PATH3} ]; then
    echo -e "[${color_green}PASS${color_norm}]: ${test_folder} (hours.txt)"
    PASS_CNT=$(($PASS_CNT+1))
  else
    echo -e "[${color_red}FAIL${color_norm}]: ${test_folder} (hours.txt)"
    diff ${PROJECT_ANSWER_PATH3} ${TEST_ANSWER_PATH3}
  fi
  
  DIFF_RESULT4=$(diff -bB ${PROJECT_ANSWER_PATH4} ${TEST_ANSWER_PATH4} | wc -l)
  if [ "${DIFF_RESULT4}" -eq "0" ] && [ -f ${PROJECT_ANSWER_PATH4} ]; then
    echo -e "[${color_green}PASS${color_norm}]: ${test_folder} (blocked.txt)"
    PASS_CNT=$(($PASS_CNT+1))
  else
    echo -e "[${color_red}FAIL${color_norm}]: ${test_folder} (blocked.txt)"
    diff ${PROJECT_ANSWER_PATH4} ${TEST_ANSWER_PATH4}
  fi
}

function run_all_tests {
  TEST_FOLDERS=$(ls ${GRADER_ROOT}/tests)
  NUM_TESTS=$(($(echo $(echo ${TEST_FOLDERS} | wc -w)) * 4))
  PASS_CNT=0

  # Loop through all tests
  for test_folder in ${TEST_FOLDERS}; do

    setup_testing_input_output

    cd ${GRADER_ROOT}/temp
    bash run.sh 2>&1
    cd ../

    compare_outputs
    echo "[$(date)] ${PASS_CNT} of ${NUM_TESTS} tests passed" 
  done

  echo "[$(date)] ${PASS_CNT} of ${NUM_TESTS} tests passed" >> ${GRADER_ROOT}/results.txt
}

check_project_struct
run_all_tests
