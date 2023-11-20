pipeline {
    agent { 
        label "swarm"
    }

    environment {
        PROJECT_NAME = "ruoyi"
        PROJECT_ENV = "dev"

        REPOSITORY_AUTH = "gitlab"
        REPOSITORY_URL = "http://gitlab.devops.local/devops/ruoyi.git"

        REGISTRY_HOST = "172.16.115.11:5000"
    }

    parameters{
        string(
            description: "Version of RuoYi-Cloud ?",
            name: "version",
            defaultValue: "v3.6.2",
        )
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    stages {
        stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: "refs/tags/${params.version}"]], extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: "RuoYi-Cloud"]], userRemoteConfigs: [[url: "https://gitee.com/y_project/RuoYi-Cloud.git"]])
            }
        }

        stage('maven') {
            steps {
                dir('RuoYi-Cloud') {
                    withDockerContainer(image: 'registry.cn-hangzhou.aliyuncs.com/buxiaomo/maven:3.9.0', args: '-v m2:/app/.m2') {
                        sh "mvn clean package -Dmaven.test.skip=true"
                    }
                }
            }
        }

        stage('build image') {
            parallel {
                stage('build ruoyi-gateway') {
                    steps {
                        sh label: 'Build', script: "nerdctl build --platform=amd64 --output type=image,name=${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-gateway:${params.version},push=true . -f gateway.Dockerfile"
                    }
                }
                stage('build ruoyi-auth') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-auth:${params.version} -f auth.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-auth:${params.version}"
                    }
                }
                stage('build ruoyi-modules-system') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-system:${params.version} -f modules-system.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-system:${params.version}"
                    }
                }
                stage('build ruoyi-modules-gen') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-gen:${params.version} -f modules-gen.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-gen:${params.version}"
                    }
                }
                stage('build ruoyi-modules-job') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-job:${params.version} -f modules-job.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-job:${params.version}"
                    }
                }
                stage('build ruoyi-modules-file') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-file:${params.version} -f modules-file.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-modules-file:${params.version}"
                    }
                }
                stage('build ruoyi-visual-monitor') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-visual-monitor:${params.version} -f visual-monitor.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-visual-monitor:${params.version}"
                    }
                }
                stage('build ruoyi-vue') {
                    steps {
                        sh label: 'Build', script: "buildah bud -t ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-ui:${params.version} -f ruoyi-ui.Dockerfile ."
                        sh label: 'Push', script: "buildah push --tls-verify=false ${env.REGISTRY_HOST}/${env.PROJECT_NAME}/ruoyi-ui:${params.version}"
                    }
                }
            }
        }

        stage('deploy service') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: 'default', credentialsId: 'kubeconfig', namespace: 'ruoyi', restrictKubeConfigAccess: false, serverUrl: 'https://172.16.115.11:6443') {
                    sh "helm upgrade -i ruoyi --set hub=${env.REGISTRY_HOST}/${env.PROJECT_NAME} --set tag=${params.version} --set nacos.addr=nacos.infra.svc.cluster.local:8848 ruoyi --create-namespace --namespace ${env.PROJECT_NAME}-${env.PROJECT_ENV}"
                }
            }
        }
    }
    // post { 
    //     cleanup{
    //         cleanWs()
    //     }
    // }
}