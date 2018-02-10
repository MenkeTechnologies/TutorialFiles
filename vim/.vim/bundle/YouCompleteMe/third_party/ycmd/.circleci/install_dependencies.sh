#!/bin/bash

# Exit immediately if a command returns a non-zero status.
set -e

################
# Homebrew setup
################

# There's a homebrew bug which causes brew update to fail the first time. Run
# it twice to workaround. https://github.com/Homebrew/homebrew/issues/42553
brew update || brew update

# List of homebrew formulae to install in the order they appear.
# We require CMake, Node, Go, Mono and Ninja for our build and tests, and all
# the others are dependencies of pyenv.
REQUIREMENTS="cmake
              node.js
              go
              mono
              ninja
              readline
              autoconf
              pkg-config
              openssl"

# Install CMake, Node, Go, Mono, Ninja, pyenv and dependencies.
for pkg in $REQUIREMENTS; do
  # Install package, or upgrade it if it is already installed.
  brew install $pkg || brew outdated $pkg || brew upgrade $pkg
done

##############
# Python setup
##############

PYENV_ROOT="${HOME}/.pyenv"

if [ ! -d "${PYENV_ROOT}/.git" ]; then
  rm -rf ${PYENV_ROOT}
  git clone https://github.com/yyuu/pyenv.git ${PYENV_ROOT}
fi
pushd ${PYENV_ROOT}
git fetch --tags
git checkout v1.2.1
popd

PATH="${PYENV_ROOT}/bin:${PATH}"

eval "$(pyenv init -)"

if [ "${YCMD_PYTHON_VERSION}" == "2.7" ]; then
  # We need a recent enough version of Python 2.7 on macOS or an error occurs
  # when installing the psutil dependency for our tests.
  PYENV_VERSION="2.7.14"
else
  PYENV_VERSION="3.4.7"
fi

# In order to work with ycmd, python *must* be built as a shared library. The
# most compatible way to do this on macOS is with --enable-framework. This is
# set via the PYTHON_CONFIGURE_OPTS option.
export PYTHON_CONFIGURE_OPTS="--enable-framework"

pyenv install --skip-existing ${PYENV_VERSION}
pyenv rehash
pyenv global ${PYENV_VERSION}

# Initialize pyenv in other steps. See
# https://circleci.com/docs/2.0/env-vars/#interpolating-environment-variables-to-set-other-environment-variables
# and https://github.com/pyenv/pyenv/issues/264
echo "export PATH=${PYENV_ROOT}/bin:\$PATH" >> $BASH_ENV
echo 'if [ -z "${PYENV_LOADING}" ]; then' >> $BASH_ENV
echo '  export PYENV_LOADING=true' >> $BASH_ENV
echo '  eval "$(pyenv init -)"' >> $BASH_ENV
echo '  unset PYENV_LOADING' >> $BASH_ENV
echo 'fi' >> $BASH_ENV

pip install -U pip wheel setuptools
pip install -r test_requirements.txt

# Enable coverage for Python subprocesses. See:
# http://coverage.readthedocs.io/en/latest/subprocess.html
echo -e "import coverage\ncoverage.process_startup()" > \
  ${PYENV_ROOT}/versions/${PYENV_VERSION}/lib/python${YCMD_PYTHON_VERSION}/site-packages/sitecustomize.py

############
# Rust setup
############

curl https://sh.rustup.rs -sSf | sh -s -- -y

CARGO_PATH="${HOME}/.cargo/bin"
PATH="${CARGO_PATH}:${PATH}"
rustup update
rustc -Vv
cargo -V

echo "export PATH=${CARGO_PATH}:\$PATH" >> $BASH_ENV

##################
# TypeScript setup
##################

npm install -g typescript

#################
# Java 8 setup
#################

java -version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ "$JAVA_VERSION" < "1.8" ]]; then
  echo "Java version $JAVA_VERSION is too old" 1>&2
  exit 1
fi

set +e
