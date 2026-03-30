pipeline {
    agent any

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
