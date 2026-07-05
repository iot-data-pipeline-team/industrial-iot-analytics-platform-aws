from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Test").getOrCreate()

print("Spark started successfully")

spark.range(10).show()

spark.stop()