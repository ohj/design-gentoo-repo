shell=`/bin/basename \`/bin/ps -p $$ -ocomm=\``
if [ -f "@exec_prefix@/init/$shell" ]
then
  . "@exec_prefix@/init/$shell"
else
  . "@exec_prefix@/init/sh"
fi
