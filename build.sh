#!/bin/bash

export ANT_OPTS='-XX:PermSize=64m -XX:MaxPermSize=128m -Xmx512m -Dinfo.aduna.platform.appdata.basedir=./webapps/sesame/app_dir/'

sw/ant/bin/ant -f local.build.xml $*
