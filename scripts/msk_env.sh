#!/bin/bash

############################################
# MSK + Java Environment
############################################

export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.aarch64
export PATH="$JAVA_HOME/bin:$PATH"

export CLASSPATH=/usr/share/aws/aws-java-sdk-v2/aws-sdk-java-bundle-2.41.32.jar:/usr/lib/spark/jars/aws-msk-iam-auth-2.3.5.jar

############################################
# Create Kafka client.properties if missing
############################################

if [ ! -f "$HOME/client.properties" ]; then
cat > "$HOME/client.properties" << 'EOF'
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
EOF

echo "Created ~/client.properties"
fi

############################################
# Display Environment
############################################

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