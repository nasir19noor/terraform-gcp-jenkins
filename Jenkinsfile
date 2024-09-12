def getFolders() {
    def folders = sh(script: "find resources -mindepth 1 -maxdepth 1 -type d -printf '%f\n'", returnStdout: true).trim().split('\n')
    return folders
}

def getModifiedFolders() {
    def changedFiles = sh(script: "git diff --name-only HEAD HEAD~1 | grep '^resources/' || true", returnStdout: true).trim()
    def modifiedFolders = changedFiles.split('\n').collect { it.split('/')[1] }.unique()
    return modifiedFolders
}

pipeline {
    agent any
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
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
                    env.MODIFIED_FOLDERS = getModifiedFolders().join(' ')
                }
            }
        }
        stage('Terraform Operations') {
            steps {
                script {
                    def folders = env.MODIFIED_FOLDERS.split(' ')
                    folders.each { folder ->
                        stage("Terraform for ${folder}") {
                            dir("resources/${folder}") {
                                sh 'terraform init'
                                sh 'terraform plan -out=tfplan'
                                input message: "Do you want to apply the terraform plan for ${folder}?", ok: 'Yes'
                                sh 'terraform apply -auto-approve tfplan'
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