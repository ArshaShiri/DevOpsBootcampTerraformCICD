# CI/CD Demo with Terraform

## Jenkins Setup

* Plugins:
  * All the default suggested plugins when setting Jenkins up
  * 

* Tools:
  * maven-3.8.6
  * Add Jenkins library under `Manage Jenkins->Configure System->Global Pipeline Libraries`

Make sure the job is of type multi-branch pipeline. Moreover, install docker on the Jenkins container and add `docker-hub-repo` and `git-credentials` credentials.