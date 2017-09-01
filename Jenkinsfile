#!groovy

@Library('github.com/pedroamador/jenkins-pipeline-library') _

// Initialize global config
cfg = jplConfig('orchextra_core','ios')
def develop = 'feature/orchextra_3.0'

pipeline {
    agent { label 'ios' }

    stages {
        stage ('Test') {
            when { branch develop }
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
        // stage ('Deploy to Staging') {
        //     when { branch develop }
        //     steps  {
        //         timestamps {
        //             ansiColor('xterm') {
        //                 sh 'git clean -f'
        //                 sh 'fastlane ' + staging
        //                 archive '**/*.ipa'
        //                 sh 'git checkout .'
        //             }
        //         }
        //     }
        // }
        stage('SonarQube Analysis') {
            when { expression { (env.BRANCH_NAME == develop) || env.BRANCH_NAME.startsWith('PR-') } }
            steps {
                //jplSonarScanner ('SonarQube')
                echo "ToDo: SonarQube Scanner"
            }
        }
        stage ('Confirm Release') {
            agent none
            when { branch 'release/*' }
            steps {
                timeout(time: 1, unit: 'DAYS') {
                    input(message: 'Waiting for approval - Upload to Play Store?')
                }
            }
        }
        stage ('Close release') {
            when { branch 'release/*' }
            steps {
                // ToDo: Release to Play Store
                jplCheckoutSCM(cfg)
                jplCloseRelease()
                jplNotify('Jenkins QA','','qa+orchextra@gigigo.com')
            }
        }
        stage ('Clean') {
            when { branch 'PR-' }
            steps {
                deleteDir();
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Build OK'
            jplNotify('Jenkins QA','','')
        }
        failure {
            echo 'Build failed!'
            jplNotify('Jenkins QA','','qa+orchextra@gigigo.com')
        }
    }

    options {
        buildDiscarder(logRotator(artifactNumToKeepStr: '5'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 2, unit: 'DAYS')
    }
}
