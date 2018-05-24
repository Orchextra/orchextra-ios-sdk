#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@v1.4.2') _

// Initialize global config
cfg = jplConfig('sdk', 'ios', '', [hipchat: '', slack: '#integrations', email: 'qa+orchextra@gigigo.com'])
def develop = 'feature/orchextra_3.0'

pipeline {
    agent none

    stages {
        stage ('Initialize') {
            agent { label 'ios' }
            steps  {
                jplCheckoutSCM(cfg)
            }
        }
        stage ('Test') {
            agent { label 'ios' }
            when { branch 'feature/orchextra_3.0' }
            steps  {
                sh 'fastlane test'
                step([$class: 'JUnitResultArchiver', allowEmptyResults: true, testResults: 'fastlane/test_output/report.junit'])
                sh 'git checkout .'
            }
        }
        stage ('Applivery Staging') {
            agent { label 'ios' }
            when { branch 'feature/orchextra_3.0' }
            steps  {
                sh 'git clean -fd'
                sh 'fastlane staging'
                sh 'git checkout .'
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

   options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}
