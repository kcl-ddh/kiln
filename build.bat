set ANT_OPTS=-Xmx512m -Dorg.eclipse.rdf4j.appdata.basedir=.\webapps\rdf4j-server\app_dir\ -Dorg.eclipse.jetty.LEVEL=WARN

sw\ant\bin\ant.bat -S -f local.build.xml %1 %2 %3 %4 %5 %6 %7 %8 %9
