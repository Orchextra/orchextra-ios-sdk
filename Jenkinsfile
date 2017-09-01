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
        // stage ('Deploy to Staging') {
        //     when { branch 'feature/orchextra_3.0' }
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
            when { expression { (env.BRANCH_NAME == 'feature/orchextra_3.0') || env.BRANCH_NAME.startsWith('PR-') } }
            steps {
                //jplSonarScanner ('SonarQube')
                echo "ToDo: SonarQube Scanner"
            }
        }
        // stage ('Confirm Release') {
        //     agent none
        //     when { branch 'release/*' }
        //     steps {
        //         timeout(time: 1, unit: 'DAYS') {
        //             input(message: 'Waiting for approval - Upload to Play Store?')
        //         }
        //     }
        // }
        // stage ('Close release') {
        //     when { branch 'release/*' }
        //     steps {
        //         // ToDo: Release to Play Store
        //         jplCheckoutSCM(cfg)
        //         jplCloseRelease()
        //     }
        // }
        // stage ('Clean') {
        //     when { branch 'PR-' }
        //     steps {
        //         deleteDir();
        //     }
        // }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

   options {
        buildDiscarder(logRotator(artifactNumToKeepStr: ‘20’,artifactDaysToKeepStr: ‘30’))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: ‘DAYS’)
    }
}
