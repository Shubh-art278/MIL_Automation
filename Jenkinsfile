pipeline {
    agent any

    environment {
        MATLAB_SCRIPT = ""  // will be set dynamically
        ARTIFACTS_DIR = "Artifacts"
        RESULTS_DIR = "Test_Results"
    }

    stages {
        stage('Checkout Source') {
            steps {
                echo 'Checking out source from Git'
                git 'https://github.com/Shubh-art278/MIL_Automation.git'
            }
        }

        stage('Prepare Workspace') {
            steps {
                echo 'Creating Artifacts & Test Results directories'
                bat "mkdir ${ARTIFACTS_DIR} || echo ${ARTIFACTS_DIR} exists"
                bat "mkdir ${RESULTS_DIR} || echo ${RESULTS_DIR} exists"
            }
        }

        stage('Detect MATLAB Test Script') {
            steps {
                script {
                    def testScript = ""
                    if (fileExists("run_all_test.m")) {
                        testScript = "run_all_test"
                    } else if (fileExists("run_all_tests.m")) {
                        testScript = "run_all_tests"
                    } else {
                        error "No test script found! Make sure run_all_test.m or run_all_tests.m exists."
                    }
                    env.MATLAB_SCRIPT = testScript
                    echo "MATLAB test script detected: ${env.MATLAB_SCRIPT}"
                }
            }
        }

        stage('Run MIL Model Tests') {
            steps {
                echo 'Running MATLAB MIL model tests'
                bat """
                matlab -batch "cd('%WORKSPACE%'); addpath(genpath(pwd)); ${MATLAB_SCRIPT}; exit"
                """
            }
        }

        stage('Archive Results & Artifacts') {
            steps {
                echo 'Archiving artifacts and test results'
                archiveArtifacts artifacts: "${ARTIFACTS_DIR}/**/*, ${RESULTS_DIR}/**/*", allowEmptyArchive: true
            }
        }
    }

    post {
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed! Check MATLAB output and console logs.'
        }
        always {
            echo 'Pipeline finished'
        }
    }
}
