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

QMGR_EXISTS=`dspmq | grep ${MQ_QMGR_NAME} > /dev/null ; echo $?`

if [ ${QMGR_EXISTS} -ne 0 ]; then
  MQ_DEV=${MQ_DEV:-"true"}
  export AMQ_EXTRA_QM_STANZAS="Channels:MaxChannels=999999999,MaxActiveChannels=999999999,MQIBindType=FASTPATH|TuningParameters:DefaultQBufferSize=10485760,DefaultPQBufferSize=10485760"
  crtmqm -lp ${LOG_PRIM} -lf ${LOG_FILE_SZ} -h 50000 -q ${MQ_QMGR_NAME} || true
fi
