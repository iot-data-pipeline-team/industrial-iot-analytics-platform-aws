#!/bin/bash

############################################
# MSK + Java Environment
############################################

export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
export PATH="$JAVA_HOME/bin:$PATH"

export CLASSPATH=/usr/share/aws/aws-java-sdk-v2/aws-sdk-java-bundle-2.41.32.jar:/usr/lib/spark/jars/aws-msk-iam-auth-2.3.5.jar

echo
echo "===================================="
echo "MSK Environment Loaded"
echo "===================================="
echo "JAVA_HOME=$JAVA_HOME"
echo "Java Version:"
java -version
echo
echo "CLASSPATH:"
echo "$CLASSPATH"
echo "===================================="
echo
