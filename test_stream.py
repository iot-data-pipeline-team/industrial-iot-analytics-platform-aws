from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
        .appName("KinesisTest")
        .config("spark.sql.session.timeZone", "UTC")
        .config(
            "spark.hadoop.fs.s3a.aws.credentials.provider",
            "com.amazonaws.auth.InstanceProfileCredentialsProvider"
        )
        .getOrCreate()
)

spark.sparkContext.setLogLevel("INFO")

df = (
    spark.readStream
        .format("aws-kinesis")
        .option("kinesis.region", "us-east-1")
        .option("kinesis.streamName", "machine-events-stream")
        .option("kinesis.consumerType", "GetRecords")
        .option(
            "kinesis.endpointUrl",
            "https://kinesis.us-east-1.amazonaws.com"
        )
        .option(
            "kinesis.startingPosition",
            "LATEST"
        )
        .load()
)

query = (
    df.writeStream
      .format("console")
      .option("truncate", False)
      .start()
)

query.awaitTermination()