set ANT_OPTS='-XX:PermSize=64m -XX:MaxPermSize=128m -Xmx512m -Dinfo.aduna.platform.appdata.basedir=.\webapps\sesame\app_dir\'

sw\ant\bin\ant.bat -f local.build.xml %1 %2 %3 %4 %5 %6 %7 %8 %9
