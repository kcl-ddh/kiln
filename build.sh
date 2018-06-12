#!/bin/bash

export ANT_OPTS='-Xmx512m -Dorg.eclipse.rdf4j.appdata.basedir=./webapps/rdf4j-server/app_dir/ -Dorg.eclipse.jetty.LEVEL=WARN'

sw/ant/bin/ant -S -f local.build.xml $*
