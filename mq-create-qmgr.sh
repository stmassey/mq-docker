#!/bin/bash
# -*- mode: sh -*-
# © Copyright IBM Corporation 2015, 2017
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ -z ${MQ_QMGR_NAME+x} ]; then
  # no ${MQ_QMGR_NAME} supplied so set Queue Manager name as the hostname
  # However make sure we remove any characters that are not valid.
  echo "Hostname is: $(hostname)"
  MQ_QMGR_NAME=`echo $(hostname) | sed 's/[^a-zA-Z0-9._%/]//g'`
fi
echo "Setting Queue Manager name to ${MQ_QMGR_NAME}"

QMGR_EXISTS=`dspmq | grep ${MQ_QMGR_NAME} > /dev/null ; echo $?`

if [ ${QMGR_EXISTS} -ne 0 ]; then
  MQ_DEV=${MQ_DEV:-"true"}
  if [ "${MQ_DEV}" == "true" ]; then
    # Turns on early adopt if we're using Developer defaults
    export AMQ_EXTRA_QM_STANZAS="Channels:ChlauthEarlyAdopt=Y,MaxChannels=999999999,MaxActiveChannels=999999999,MQIBindType=FASTPATH|TuningParameters:DefaultQBufferSize=10485760,DefaultPQBufferSize=10485760"
  fi
export AMQ_EXTRA_QM_STANZAS="Channels:MaxChannels=999999999,MaxActiveChannels=999999999,MQIBindType=FASTPATH|TuningParameters:DefaultQBufferSize=10485760,DefaultPQBufferSize=10485760"  
crtmqm -lp ${LOG_PRIM} -lf ${LOG_FILE_SZ} -h 50000 -q ${MQ_QMGR_NAME} || true
fi
