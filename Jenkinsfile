pipeline {
    agent any

    environment {
        MATLAB_CMD = "matlab -batch"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning repository"
                checkout scm
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo "Creating Results & Artifacts dirs"
                bat 'mkdir Artifacts || echo Artifacts exists'
                bat 'mkdir Test_Results || echo Test_Results exists'
            }
        }

        stage('Run MIL Tests') {
            steps {
                echo "Running MATLAB tests and simulations"
                bat "${env.MATLAB_CMD} \"run_all_tests\""
            }
        }

        stage('Publish Test Results') {
            steps {
                echo "Publishing test results"
                junit 'Test_Results/*.xml'
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "Archiving simulation artifacts"
                archiveArtifacts artifacts: 'Artifacts/**', allowEmptyArchive: true
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed — check console output!"
        }
        always {
            echo "Pipeline finished"
        }
    }
}
