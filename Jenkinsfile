pipeline {
    agent { 
        label "swarm"
    }

    environment {
        PROJECT_NAME = "ruoyi"
        PROJECT_ENV = "dev"

        REPOSITORY_AUTH = "gitlab"
        REPOSITORY_URL = "https://gitee.com/y_project/RuoYi-Cloud.git"

        REGISTRY_HOST = "172.16.115.11:5000"
    }

    parameters{
        string(
            description: "Version of RuoYi-Cloud ?",
            name: "version",
            defaultValue: "v3.6.2",
        )
        string(
            description: "deploy for env?",
            name: "env",
            defaultValue: "dev",
        )
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    stages {
        stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: "refs/tags/${params.version}"]], extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: "RuoYi-Cloud"]], userRemoteConfigs: [[url: "${env.REPOSITORY_URL}"]])
            }
        }

        stage('compile') {
            steps {
                dir('RuoYi-Cloud') {
                    withDockerContainer(image: 'maven:3.9.0', args: '--net host -v m2:/root/.m2') {
                        sh "mvn clean package -Dmaven.test.skip=true -q"
                    }
                }
            }
        }

        stage('build image') {
            parallel {
                stage('ruoyi-gateway') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-gateway:${params.version},push=true -f gateway.Dockerfile ."
                    }
                }
                stage('ruoyi-auth') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-auth:${params.version},push=true -f auth.Dockerfile ."
                    }
                }
                stage('ruoyi-modules-system') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-system:${params.version},push=true -f modules-system.Dockerfile ."
                    }
                }
                stage('ruoyi-modules-gen') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-gen:${params.version},push=true -f modules-gen.Dockerfile ."
                    }
                }
                stage('ruoyi-modules-job') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-job:${params.version},push=true -f modules-job.Dockerfile ."
                    }
                }
                stage('ruoyi-modules-file') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-file:${params.version},push=true -f modules-file.Dockerfile ."
                    }
                }
                stage('ruoyi-visual-monitor') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-visual-monitor:${params.version},push=true -f visual-monitor.Dockerfile ."
                    }
                }
                stage('ruoyi-vue') {
                    steps {
                        sh label: 'build image', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-ui:${params.version},push=true -f ruoyi-ui.Dockerfile ."
                    }
                }
            }
        }

        // stage('deploy service') {
        //     steps {
        //         input 'is ready to deploy prod'
        //         withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: 'default', credentialsId: 'kubeconfig', namespace: 'ruoyi', restrictKubeConfigAccess: false, serverUrl: 'https://172.16.115.11:6443') {
        //             sh "helm upgrade -i ruoyi --set hub=${env.REGISTRY_HOST}/${env.PROJECT_NAME} --set tag=${params.version} --set nacos.addr=nacos.infra.svc.cluster.local:8848 ruoyi --create-namespace --namespace ${env.PROJECT_NAME}-${env.PROJECT_ENV}"
        //         }
        //     }
        // }
    }
    // post { 
    //     cleanup{
    //         cleanWs()
    //     }
    // }
}