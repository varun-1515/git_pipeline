pipeline {
    agent { label 'linuxgitaws' }

    options {
        timestamps()
    }

    environment {
        GIT_REPO = 'https://github.com/varun-1515/git_pipeline.git'
        BRANCH   = 'main'
    }

    stages {
        stage('Checkout repo') {
            steps {
                git branch: BRANCH,
                    url: GIT_REPO,
                    credentialsId: '079e68d6-b157-4e64-b109-21d6085c3483'
            }
        }

        stage('Prepare tools') {
            steps {
                echo 'Installing required tools on Ubuntu...'
                sh '''
                    set -e

                    sudo apt-get update -y
                    sudo apt-get install -y \
                        build-essential \
                        python3 \
                        python3-pip \
                        cmake \
                        curl \
                        pipx

                    pipx ensurepath
                    export PATH="$HOME/.local/bin:$PATH"

                    pipx install cmakelint || pipx upgrade cmakelint
                '''
            }
        }

        stage('Lint') {
            steps {
                sh '''
                    set -e
                    export PATH="$HOME/.local/bin:$PATH"

                    if [ -f CMakeLists.txt ]; then
                        cmakelint --version
                        cmakelint CMakeLists.txt > lint_report.txt 2>&1 || true
                    else
                        echo "CMakeLists.txt not found" > lint_report.txt
                    fi
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'lint_report.txt', fingerprint: true
                }
            }
        }

        stage('Build') {
            steps {
                sh '''
                    set -e

                    if [ ! -f CMakeLists.txt ]; then
                        echo "CMakeLists.txt not found!"
                        exit 1
                    fi

                    mkdir -p build
                    cd build
                    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
                    make -j$(nproc)

                    cp compile_commands.json ..
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    set -e
                    cd build
                    ctest --output-on-failure --test-output-junit test-results.xml || true
                '''
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'build/test-results.xml'
                }
            }
        }
    }
}

