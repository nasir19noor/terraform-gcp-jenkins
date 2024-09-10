pipeline {
    agent any
    
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
    }
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Detect Changes') {
            steps {
                script {
                    def changedFolders = sh(
                        script: """
                            git diff --name-only origin/main..HEAD | 
                            grep 'resources/.*\\.tf' | 
                            xargs -I {} dirname {} | 
                            sort -u
                        """,
                        returnStdout: true
                    ).trim().split("\n")
                    
                    changedFolders.each { folder ->
                        stage("Pipeline for ${folder}") {
                            dir(folder) {
                                stage('Terraform Init') {
                                    steps {
                                        sh 'terraform init'
                                    }
                                }
                                stage('Terraform Plan') {
                                    steps {
                                        sh 'terraform plan -out=tfplan'
                                    }
                                }
                                stage('Approval') {
                                    steps {
                                        input message: "Do you want to apply the plan for ${folder}?"
                                    }
                                }
                                stage('Terraform Apply') {
                                    steps {
                                        sh 'terraform apply -auto-approve tfplan'
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}