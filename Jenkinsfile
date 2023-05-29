library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'https://github.com/ArshaShiri/DevOpsBootcampJenkinsSharedLibraryDemo.git',
     credentialsId: 'gitlab-credentials'
     ]
)

def gv

pipeline {
    agent any

    tools {
        // We need this to make the maven command availble in our build.
        // The name can be retrieved from Dashboard->Manage Jenkins->Credentials
        maven 'maven-3.8.6'
    }

    stages {
        stage('increment version') {
            steps {
                script {
                    echo "incrementing app version..."

                    // This command will update the version in pom.xml
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'

                    // Matcher will contain an array of matched text
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "arshashiri/demo-app:java-maven-$version-$BUILD_NUMBER"
                }
            }
        }
    
        stage("init") {
            steps{
                script {
                    gv = load "script.groovy"
                }
            }
        }
        
        stage("build jar") {
            steps {
                script {
                    // The same name as the function in Shared Library repository (DevOpsBootcampJenkinsSharedLibraryDemo/vars/buildJar.groovy)
                    buildJar()
                }
            }
        }

        stage("build image") {
            steps {
                script {
                    echo 'building docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }

        stage('provision server') {
            environment {
                // Create the fllowing "secrete text" credentials for accessing AWS
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')

                // This way we can override a terraform variable.
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                    // Navigate to terraform folder.
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        // Get the public ip as output of terraform and assing it to EC2_PUBLIC_IP env var
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output ec2_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    // Ideally this wait should be executed only when the server is being created not when it is already there
                    // and the pipeline is running again.
                    echo "waiting for EC2 server to initialize" 
                    sleep(time: 90, unit: "SECONDS") 

                    echo 'deploying docker image to EC2...'
                    echo "${EC2_PUBLIC_IP}"

                    // Run server-cmds.sh
                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                    sshagent(['server-ssh-key']) {
                       sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                       sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                       sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
            }
            }
        }
    }
}