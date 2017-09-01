#!groovy

@Library('github.com/pedroamador/jenkins-pipeline-library') _

// Initialize global config
cfg = jplConfig('sdk', 'ios', '', [hipchat: '', slack: '#integrations', email: 'qa+orchextra@gigigo.com'])
def develop = 'feature/orchextra_3.0'

pipeline {
    agent { label 'ios' }

    stages {
        stage ('Test') {
            when { branch 'feature/orchextra_3.0' }
            steps  {
                timestamps {
                    ansiColor('xterm') {
                        jplCheckoutSCM(cfg)
                        sh 'fastlane test'
                        step([$class: 'JUnitResultArchiver', allowEmptyResults: true, testResults: 'fastlane/test_output/report.junit'])
                        sh 'git checkout .'
                    }
                }
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

   options {
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}
