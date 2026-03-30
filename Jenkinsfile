pipeline {
    agent any

    environment {
        WORKSPACE_DIR = "${env.WORKSPACE}"
        ARTIFACTS_DIR = "${env.WORKSPACE}\\Artifacts"
        RESULTS_DIR = "${env.WORKSPACE}\\Test_Results"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                echo 'Checking out source code from Git'
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          userRemoteConfigs: [[url: 'https://github.com/Shubh-art278/MIL_Automation.git']]])
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo 'Creating Results & Artifacts directories'
                bat "mkdir \"${ARTIFACTS_DIR}\" || echo Artifacts exists"
                bat "mkdir \"${RESULTS_DIR}\" || echo Test_Results exists"
            }
        }

        stage('Run MIL Tests') {
            steps {
                echo 'Running MATLAB tests and simulations'
                // Add workspace to MATLAB path and run your tests
                bat """
                matlab -batch "cd('${WORKSPACE_DIR}'); addpath(genpath(pwd)); run_all_tests('${ARTIFACTS_DIR}', '${RESULTS_DIR}'); exit"
                """
            }
        }

        stage('Publish Test Results') {
            steps {
                echo 'Publishing test results'
                // Update the path to your JUnit-compatible XML if MATLAB generates it
                junit allowEmptyResults: true, testResults: "${RESULTS_DIR}\\*.xml"
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving generated artifacts'
                archiveArtifacts artifacts: "${ARTIFACTS_DIR}\\**", fingerprint: true
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Build passed!'
        }
        failure {
            echo 'Build failed. Check console output.'
        }
    }
}