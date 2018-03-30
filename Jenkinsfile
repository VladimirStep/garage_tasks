pipeline {
    agent { docker { image 'ruby:2.4.1' } }
    stages {
        stage('build') {
            steps {
                sh 'ruby --version'
            }
        }
    }
}