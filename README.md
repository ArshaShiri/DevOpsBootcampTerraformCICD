# CI/CD Demo with Terraform

## Jenkins Setup

* Plugins:
  * All the default suggested plugins when setting Jenkins up
  * ssh agent

* Tools:
  * maven-3.8.6
  * Add Jenkins library under `Manage Jenkins->Configure System->Global Pipeline Libraries`

Make sure the job is of type multi-branch pipeline. Moreover, install docker on the Jenkins container and add `docker-hub-repo` and `git-credentials` credentials.

## Creating a Key Pair for sshing from Jenkins

We can create a new key pair under `ec2->key pairs` and dowload the pem file.
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/6791cee0-c4f2-432c-8640-3edcf79a04c8)

Subsequently, we are going to add the pem file to Jenkins under the multibranch pipeline credentials:
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/a0e877ec-031c-4a53-840d-3371dec1a2fb)
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/4c81fd81-970c-4fc1-95f5-bfb3d7b7af97)

## Installing Terraform on Jenkins Container

After sshing into our droplet on digital ocean:

    docker exec -it -u 0 {jenkins-container-id} bash
    
    # Check os on the container by 
    cat /etc/os-release 
    
The installation process can be followed [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).


## Terraform Configuration Files and Jenkins Step

The configuration files and the associated step to Jenkinsfile is added and can be inspected in the commit history.
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/9ed80660-9548-4b57-a15d-a9a85d7d6f95)

## Docker Login to Pull Docker Image

Necessary configurations are added to `server-cmds.sh` and Jenkinsfile.

## Destroy the Resources

Easiest way is to do this from jenkins by running destroy command in replay feature.

![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/b0d288b2-ab99-40c9-8f36-64117150aad1)
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/ed0d8e31-4828-4ada-8f80-013a1a47c622)
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/dc624617-c028-4dec-a195-0c20e58c3eab)

## Storing Terraform State

It would be very convenient so share Terraform sate. So far the state has been stored in Jenkins server only which can be unsafe in case the server crashes etc. An S3 bucket should then be created on AWS.
![image](https://github.com/ArshaShiri/DevOpsBootcampTerraformCICD/assets/18715119/0a66e060-d8cd-421b-865b-1d947cab8b30)

Make sure that `Bucket Versioning` is actiaveted as well.
