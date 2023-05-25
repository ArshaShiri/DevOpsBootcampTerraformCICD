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

        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'

                    // Run server-cmds.sh
                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"

                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ec2-user@3.71.176.75:/home/ec2-user"
                        sh "scp docker-compose.yaml ec2-user@3.71.176.75:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.71.176.75 ${shellCmd}"
                    }
            }
            }
        }
    }
}