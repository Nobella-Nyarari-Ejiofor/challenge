# Interintel Technologies DevOps Challenge - Nobella Nyarari Ejiofor

## Table of Contents
1. [Introduction](#introduction)
2. [Setting up a Highly Available K8s Cluster](#k8scluster)
3. [Setting up a big-data streaming data service](#big-data)
4. [Setting up a CI/CD Pipeline](#pipeline)
6. [License](#license)

## Introduction



## Setting up a Highly Available K8s Cluster

Include installation instructions here.

## Setting up a big-data streaming data service

Explain how to use your project.

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
