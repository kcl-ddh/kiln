#!/bin/bash

export ANT_OPTS='-XX:PermSize=64m -XX:MaxPermSize=128m -Xmx512m'

sw/ant/bin/ant -f local.build.xml $*
