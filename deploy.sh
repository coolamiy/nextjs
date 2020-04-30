#!/bin/bash
#set -x
if [ $# -ne 3 ]; then
  echo 1>&2 "Usage: $0 awskey awssecret  <stage to deploy: dev,test,stage and prod>"
  exit 1
fi
checkcommand() {
  hash $1 >/dev/null 2>&1
}
throw_error() {
  echo $1 ' :: Unexpected error occured..'
  exit 1
}
checkpackage() {
  if checkcommand $1; then
    echo " $1 exists .. continuing.. "
  else
    throw_error " $1 does not exist on the machine.. pls install and try again later.."
  fi
}
checkcommandreturn() {
  if [ "$result" -ne 0 ]; then
    echo "$2"
fi
}
checkandinstallserverless() {
  if checkcommand serverless; then
    echo " Serverless exists ..."
  else
    npm install serverless -g
    result="$?"
    checkcommandreturn result " cannot install serverless .. exiting.."
  fi

}
echo " checking node on the machine..."
checkpackage node
echo " checking npm on the machine..."
checkpackage npm
echo " checking serverless on the machine..."
checkandinstallserverless

echo " All set  with software packages..."
echo " Setting Serverless configuration..."
case $3 in
'dev') cp ./restrictIP/serverless.dev.yml ./
;;
'test') cp ./restrictIP/serverless.dev.yml ./
;;
'stage') cp ./restrictIP/serverless.dev.yml ./
;;
'prod') cp ./restrictIP/serverless.dev.yml ./
;;
esac
serverless config credentials --provider aws --key $1 --secret $2 -o
result="$?"
checkcommandreturn result " cannot set serverless credentials .. exiting .."
npm add -D serverless-nextjs-plugin
result="$?"
checkcommandreturn result " cannot set serverless next js plugin .. exiting .."

serverless deploy -v --stage $3 > deploylog.txt
if [[ $? == 0 ]]; then
    echo " deployment successful.. "
    grep "Application URL:" deploylog.txt

else
    echo " Failed to deploy application to aws.."
    exit 1
fi

serverless remove --stage $3
