#!/bin/bash

VENVBASE="/opt/molecule"

function retry {
  counter=0
  until "$@"
  do exit=$?
  counter=$(($counter + 1))
    if [ $counter -ge ${max_failures:-3} ];then
      return $exit
    fi
  done
  return 0
}

source "${VENVBASE}/${ansible:-current}/bin/activate"
PY_COLORS=1 ANSIBLE_FORCE_COLOR=1 retry molecule ${command:-test} --scenario-name ${scenario:-default}
