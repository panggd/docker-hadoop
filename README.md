# docker-hadoop

## Overview
This is a learner project to understand how to map and reduce data with Hadoop.

1. Run the init-hadoop script to deploy a docker container of Hadoop cluster server
2. Build the Java based Hadoop MapReduce application to a Jar file
3. Docker cp the MapReduce Jar file and CSV dataset to Hadoop cluster server
4. Create input folder in HDFS
5. Run MapReduce Jar to process CSV dataset
7. Read results from output folder in HDFS

## Tech stack
- Docker
- Hadoop
- Java
- Gradle

## data
This folder consists of a CSV dataset that describes the total attendance group by medical institutions and year.

## map-reduce
This folder consists of a Hadoop MapReduce application that will process the CSV dataset to return the total attendance group by medical institutions.

## init-hadoop shell script
This is a script that will git clone the Hadoop docker GitHub project, deploy a docker container of a Hadoop cluster server. The Hadoop cluster server will be hosted in order to run the MapReduce application.

## Prerequsites

### Download and install Docker. Follow the below guides.
https://docs.docker.com/install


## How to run

### Start your docker daemon
This is really depend on your OS. For my case, it is just starting the Docker app.

### Deploy Hadoop cluster server
This will deploy the docker container holding a Hadoop cluster server.
```bash
./init-haoop.sh
```

### Build the Hadoop MapReduce application
Use your favorite IDE and build the jar in the mapreduce folder.

### Create a test folder in Hadoop cluster server
```bash
docker exec -it namenode bash
mkdir test
exit # Need to exit before the next step
```

### Copy the Jar and dataset into the Hadoop cluster server
```bash
# Go to data folder
docker cp hospital-and-outpatient-attendances.csv \
<namenode_container_id>:test/hospital-and-outpatient-attendances.csv

# Go to mapreduce folder
docker cp map-reduce.jar <namenode_container_id>:test/map-reduce.jar
```

### Process the dataset and enjoy the output results
```bash
# Get into the Hadoop cluster server
docker exec -it namenode bash
cd test

# This is a series of command to remove the input, output folders
# Create a new input folder in HDFS
# Copy the dataset to the HDFS input folder
# Process the dataset
hdfs dfs -rm -r input output && \
hdfs dfs -put ./input/* input && \
hadoop jar map-reduce.jar MapReducerSingleNode input output && \
hadoop fs -cat output/part-r-00000
```

## Housekeeping
Here are some housekeeping tips if you are on a low memory resource machine like me.

```bash
# This is to have a clean state of your docker environment
docker stop $(docker ps -a -q) && \
docker container prune && \
docker volume prune && \
docker network prune && \
docker image prune
```

## TODO
1. Create and integrate a REST API
2. Create multiple MapReduce and chain the processing jobs
3. Extract the output result to the REST API