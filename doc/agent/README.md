#smartsight





**smartsight** 是一款面向大规模、分布式系统的AMP（应用性能管理）工具。smartsight以[Dapper](http://research.google.com/pubs/pub36356.html "Google Dapper")为原型，通过跟踪分布式应用内各个组件间的事务，提供了分析系统的整体架构和各组件的交互行为的解决方案。



* 安装smartsight agent时无需改动应用已有的代码

* 对性能冲击非常低(大约增加了3%的资源开销)



## 概述

服务经常由许多不同的组件、组件间的通信和对外部服务的调用组成。事务的执行经常往往是不可见的，smartsight可以跟踪组件间的事务流，并且提供清晰的视图来确定问题域和潜在的瓶颈。<br/>



### 功能清单

* **应用监控**
    - TOPO
    - 事务
* **DB监控**
    - DB监控
* **server监控**
    - 主机监控
* **analysis**
    - 健康度分析
    - 风险分析
* **policy**
    - policy管理
    - rule管理
* **NFVTrace**
    - 全流程
    - 子流程





## 架构

![Pinpoint Architecture](doc/img/smartsight-architecture.png)

### 组件清单
* **agent** - java进程代理（和应用在一个jvm中，负责收集jvm及所在server的监控数据）
* **collector** - 跟踪数据收集模块
* **dbmonitor** - db监控（包括db代理）
* **kernel** - 核心模块，含topo,report等的restful接口
* **nfvtrace** - nfv跟踪
* **policy** - 策略管理
* **portal** - 界面门户


## 支持被跟踪的应用框架

* JDK 6+ java application
* Tomcat 6/7/8, Jetty 8/9
* Spring, Spring Boot
* Apache HTTP Client 3.x/4.x, JDK HttpConnector, GoogleHttpClient, OkHttpClient, NingAsyncHttpClient
* Thrift Client, Thrift Service, DUBBO PROVIDER, DUBBO CONSUMER
* MySQL, Oracle, MSSQL, CUBRID, DBCP, POSTGRESQL, MARIA
* Arcus, Memcached, Redis, CASSANDRA
* iBATIS, MyBatis
* gson, Jackson, Json Lib
* log4j, Logback

## 部署

**smartsight server**
详细内容见[smartsight server部署文档](doc/smartsight-server-deployment.md)

**smartsight agent**
详细内容见[smartsight agent部署文档](doc/smartsight-agent-deployment.md)



