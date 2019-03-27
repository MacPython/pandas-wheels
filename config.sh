# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        # Override pandas minimum MACOSX_DEPLOYEMENT_TARGET=10.9 so we can
        # build for older Pythons
        # See https://github.com/pandas-dev/pandas/pull/24274
        export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-$(get_macpython_osx_ver)}
    fi
}

function build_wheel {
    # Override common_utils build_wheel function to fix version error
    # Version error due to versioneer inside submodule
    build_bdist_wheel $@
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    export PYTHONHASHSEED=$(python -c 'import random; print(random.randint(1, 4294967295))')
    python -c 'import pandas; pandas.show_versions()'
    python -c 'import pandas; pandas.test(extra_args=["--skip-slow", "--skip-network", "--skip-db", "-n=2"])'
}
