---
title: "A Little Introduction to Big Data"
author: "A. Abdias Baldiviezo"
date: "July 14, 2020"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---




## Background

https://mapr.com/blog/spark-101-what-it-what-it-does-and-why-it-matters/
https://www.youtube.com/watch?v=4DgTLaFNQq0&feature=youtu.be
https://www.youtube.com/watch?v=Ewd5PXgLXlU&feature=youtu.be
http://onlinelibrary.wiley.com/doi/10.1002/sam.11242/epdf
https://onlinelibrary.wiley.com/toc/19321872/2014/7/6
<br>

## Notes
<img src="https://mapr.com/blog/spark-101-what-it-what-it-does-and-why-it-matters/assets/image5.jpg">
<br>

### Apache Spark
-Spark is a general-purpose distributed data processing engine that is suitable for use in a wide range of circumstances. On top of the Spark core data processing engine, there are libraries for SQL, machine learning, graph computation, and stream processing, which can be used together in an application
-Programming languages supported by Spark include: Java, Python, Scala, and R. Application developers and data scientists incorporate Spark into their applications to rapidly query, analyze, and transform data at scale. Tasks most frequently associated with Spark include ETL and SQL batch jobs across large data sets, processing of streaming data from sensors, IoT, or financial systems, and machine learning tasks.
-There were 3 core concepts to the Google strategy:

    Distribute data: when a data file is uploaded into the cluster, it is split into chunks, called data blocks, and distributed amongst the data nodes and replicated across the cluster.
    Distribute computation: users specify a map function that processes a key/value pair to generate a set of intermediate key/value pairs and a reduce function that merges all intermediate values associated with the same intermediate key. Programs written in this functional style are automatically parallelized and executed on a large cluster of commodity machines in the following way:
        The mapping process runs on each assigned data node, working only on its block of data from a distributed file.
        The results from the mapping processes are sent to the reducers in a process called "shuffle and sort": key/value pairs from the mappers are sorted by key, partitioned by the number of reducers, and then sent across the network and written to key sorted "sequence files" on the reducer nodes.
        The reducer process executes on its assigned node and works only on its subset of the data (its sequence file). The output from the reducer process is written to an output file.
    Tolerate faults: both data and computation can tolerate failures by failing over to another node for data or processing.

-Spark is capable of handling several petabytes of data at a time, distributed across a cluster of thousands of cooperating physical or virtual servers. It has an extensive set of developer libraries and APIs and supports languages such as Java, Python, R, and Scala; its flexibility makes it well-suited for a range of use cases. Spark is often used with distributed data stores such as MapR XD, Hadoop’s HDFS, and Amazon’s S3, with popular NoSQL databases such as MapR Database, Apache HBase, Apache Cassandra, and MongoDB, and with distributed messaging stores such as MapR Event Store and Apache Kafka.

-Much of Spark's power lies in its ability to combine very different techniques and processes together into a single, coherent whole. Outside Spark, the discrete tasks of selecting data, transforming that data in various ways, and analyzing the transformed results might easily require a series of separate processing frameworks, such as Apache Oozie. Spark, on the other hand, offers the ability to combine these together, crossing boundaries between batch, streaming, and interactive workflows in ways that make the user more productive.

### Apache Hadoop
-Hadoop Uses HDFS and also works in clusters, the configuration that Hadoop uses is structured in nodes,
distributed across several servers.
-It uses MapReduce to process all the data.
-Instead of processing the data on the client's hardware, Hadoop processes the data across the nodes in the server,
which is also called Mapping. That is why it is faster.
-There is projects like Hive that make Hadoop more like SQL.
-Java Programming is required to interact with raw Hadoop.
-Hadoop is not very efficient in fast queries like other SQL tools.

### Divide and Recombine

-Why computational systems for data analysis are so important?
  "soon I am getting output in seconds rather than hours"
-Data science includes computational systems for data analysis
  "the attack on large complex data in the field of statistics will not happen
  unless statistics becomes a synonym of data science"
-Why developers of computational systems for data analysis need deep knowledge of data analysis
  "a computational environment for data analysis has very special requirements that can be
  adequately addressed only by a combination of deep systems knowledge and deep 
  knowledge of the process of data analysis"
-Statistical theory and methods for large complex data
  
-Learning data analysis by doing data analysis
-Open Source Software
-Which logical thinking?
  "Math is deductive logic. THe logic of data analysis applied to disciplines like
  astrophysics and power engineering is inductive"
-Divide and Recombine (D&R)
    Data Divided into subsets by statistical division 
-Deep analysis means the data is analyzed in detail at their finest granularity.
-Two methods of dividing data : Conditioning Variable and Replicate
-Analytic recombination:"D&R estimates are a replacement for estimates we could have gotten
ha it been feasible, and practical in terms of computation time, to apply the analytic method directly to all of the data."
-A tool for D&R is Tessera

