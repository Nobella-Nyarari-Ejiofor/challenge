# Interintel Technologies DevOps Challenge - Nobella Nyarari Ejiofor

## Table of Contents
1. [Introduction](#introduction)
2. [Setting up a Highly Available K8s Cluster](##k8scluster)
3. [Setting up a big-data streaming data service](#big-data)
4. [Setting up a CI/CD Pipeline](#pipeline)
6. [License](#license)

## Introduction
I'm elated to take on this challenge as part of the interview process. All feedback and suggestions will be highly appreciated . 

## Setting up a Highly Available K8s Cluster
On Bare Metal .

### Base image configuration.
<u>On premises </u>
1. Use of a minimal operating system and a SCM (Security Configuration Management) ie Ansible to automate the process of applying security configurations to your base images .
2. Kubernetes labels on images to easen identification and management of images in the cluster.
3. Regular updates on the image pull policy and base images to ensure images are upto date. 
4. Scanning the image to get hold of any vulnerabilities before deploying to production .
5. Proper configuration of the underlying OS Configurations - ie network configuration , file permissions and user configurations .

<u>AWS</u>
1. Use of AWS Systems Manger parameter store - includes the parameters to configure security to the base image .
2. Use of least priviledge on IAM to the access of base images . 
3. AWS Manager State Manager Association - applies the parameters in the parameters group to the base image .
4. State manager association - applies security configuration to base image .
5. AWS Image buillder service can build new images from basic images .  
6. Deploying base images to AWS . 

### Load balancing 
On both load balancers(two different servers or using static ports on the master nodes ): update system , install haproxy and keepalived on both . In a round robin load balancing technique . On both load balancers : 

<u>Haproxy .</u>

Creating a script to check if there is a connection to the master nodes from the load balancer. 
Configuration of network interfaces - adding the virtual IP to the loadbalancers Network interfaces ie (eth1).
Configure the check script as in my [ckeck_apiserver.sh](./keepalived/check_apiserver.sh).

<u>In Haproxy.</u>
Editing the haproxy file to listen to port 6443 on the load balancers , to use round robin technique , to balance traffic on the three master nodes by adding their hostnames and IP addresses . 
Restarting the haproxy service . 

### Setting up K8s
Automation  using ansible or manually with low task loads on each server by connecting to servers with ssh.
- Upgrades , disabling swap in the /etc/fstab and disabling the firewalls. 
- Setting the hostnames by updating host files to include all servers involved then  enabling and loading the kernel modules , add kernel settings .
- Installation of k8s using container runtime , hence installation of  the runtime (containerd). 
- Enabling the docker repository .
- Add k8s apt repository  then  Installation of kubeadm , kubectl and kubelet . 
- Initialising the  kubernetes cluster.
     kubeadm init --control-plane-endpoint="{VIRTUAL_IP_ADDRESS}:6443" --upload-certs --apiserver-advertise-address={server/node-IP-address-master1} --pod-network-cidr={CIDR}
- Join our other master nodes also including --apiserver-advertise-address={server/node-IP-address-master2/3} .
- Joining the worker nodes to the master nodes without the api-server tags as they are worker nodes .     
- Installing the network interface ie using  the calico manifest for  kubernete API  manifests networking datastores , open the file and update pod claseless i         nter-domain routing ie in CIDR edit to our pool of IPs . Run command on master node to install calico plugin .
- Verify cluster installation and high availability ie by rebooting one load balancer and checking if the virtual Ip address is attached to the alternate loadbalancer  ie using : ip a s , or a journalctl of keepalived. 

### Monitoring setup for servers
Use of zabbix monitoring . A separate server can be used as the zabbix server . SNMP , IPMI can send alerts to the zabbix server without need of deploying an agent . If need be, the zabbix agent can be deployed on all the servers and the zabbix server collects all the metrics on the servers in the cluster . If more metrics are needed rather than the OS level , metrics from the BMC can be collected using external scripts ie  Redfish plugin that collects metrics on the physical state of the server ie temparature of the server .

### Centralized logging  with EFK
EFK - Elastic search , Fluentd and Kibana.
Elasticsearch - stores indexes and logs data .
Fluentd - Log collector that collects and fowards logs to Elasticsearch .
Kibana - A web interface to visualize and explore log data stored in Elasticsearch .


## Setting up a big-data streaming data service
Airflow would enter the picture to coordinate the whole data pipeline. This implies that the NiFi and Spark Streaming operations would be scheduled and managed by Airflow.
### The data pipeline
1. The data pipeline would be defined by the directed acyclic graph (DAG) that Airflow would produce. The NiFi and Spark Streaming operations, together with the dependencies between them, would be specified in the DAG.
2. The DAG would then be scheduled by Airflow to execute on a regular basis.
3. The NiFi and Spark Streaming workflows are started by Airflow when the DAG runs.
    NiFi Process:
    After obtaining information from transactional  databases A and  B , analytical database B and C , NiFi modifies and purges it before publishing it to Kafka topics  V and W , X and Y respectively.
    
    Spark Process:
    Applications for Spark streaming take in data from Kafka topics Vand W , X and Y, analyze it in real time, and then publish the findings back to topics P and Q, R and S repectively .
    
    Data from Kafka topics P, Q, R  and Scan then be consumed by downstream applications or systems for additional processing or reporting.
4. To make sure the NiFi and Spark Streaming workflows are operating properly, Airflow would keep an eye on them.
In the event that the pipeline fails, Airflow will attempt the unsuccessful
The data can then be stored into a data lake ie Amazon S3 , or a warehouse ie Amazon Redshift and more insights and analytics can be derived . For example using AMazon Athena and Amazon Quicksight to query and visualize data repectively . The data can be also be stored in a NoSQL database and can be queried from there .

## Setting up a CI/CD Pipeline
### 1. How I would go about it 
Depending on the application code language and the target platform for the pipeline, technologies and procedures to be used can be analyzed. I would ensure the availability of an existing and updated application source code in a version control system ie Github or GitLab for the first step of my pipeline . 

### 2. Approach taken 
The use of containerization in the pipeline if k8s is our target platform .
Use of docker agents in Jenkins  as the worker nodes to save costs and workloads . 
Use of ArgoCD and Argo Image Adapter deployed as controllers on k8s cluster inline with effecient GitOps tools. 

### 3. Implementation of the approach .

  The structure of CI/CD pipeline 
  <br>
  Version control system  - GitLab <br>
  Two Source code repositories - One for the  application source code and another one for the k8s helm charts <br>
  Target platform - Kubernetes <br>
  Orchestrator - Jenkins , has multiple plugins , open-source with community support and free to use <br>
  Application code - Java  <br>
  Argo CD - Scalable , No-code and easy to use on UI  , open source <br>

![Project Image](./Images/CI-CD-pipeline.png)
  
When a user makes a commit to the repository the web hook in Git triggers Jenkins . Jenkins caters for our Continuous Integration .Jenkins will essentialy be in the root folder of the application as a JenkinsFile. Our continuous Integration  done by Jenkins has the following steps. The following steps can be set up as docker agents with readily available docker images for easier integration and cost optimisation.
  1. Checkout - Checkouts all the code from the commit by a user where Jenkins will pull the latest changes using the webhook in gitlab .
  2. Build  and Unit Testing with Static Code Analysis -  Since the application is in Java , Maven Integration Plugin  could aid in building the application and Static code analysis with linting. For the unittest , JUnit plugin  could come in handy. 
  3. Code Scan - The code will be scanned for security reasons and security checks by running SonarQube Analysis. SonarQube as it is publicly hosted .
  4. Docker Image build - Creation of a docker image from the Dockerfile in the repository .
  5. Docker image scan -  Use of a docker agent with a scanning tool ie Clair , with an access to the docker daemon . To verify if the image created has any vulnerabilities ie in the base image , binaries or packages .
  6. Docker Image push - The docker image can then be pushed to Docker.io after authenticating Jenkins with docker.io .  
This steps written in the Jenkins pipeline using a declarative approach as is more flexible and collabration friendly .
The continuos delivery starts from the updated K8s helm charts which are pushed to the helm charts repository by Argo Image Updator. In our k8s cluster , Argo Image Adaptor and ARgoCD can be deployed as controllers . Argo Image Updator will listen to our container registry and if any  changes are made , it will update our helm charts repository. ArgoCD will listen for any changes in the Helm charts repository and push the changes to kubernetes.
  
  
  


## License

Specify the project's license.

---

![Project Image](./path/to/your/image.png)
