# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        # Override pandas' default minimum MACOSX_DEPLOYEMENT_TARGET=10.9,
        # so we can build for older Pythons if we really want to.
        # See https://github.com/pandas-dev/pandas/pull/24274
        local _plat=$(get_distutils_platform)
        if [[ -z $MACOSX_DEPLOYMENT_TARGET && "$_plat" =~ macosx-(10\.[0-9]+)-.* ]]; then
            export MACOSX_DEPLOYMENT_TARGET=${BASH_REMATCH[1]}
        fi
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
    echo $PATH
    which -a python
    pip list
    python -c 'import pandas; pandas.show_versions()'
    # Skip test_maybe_promote_int_with_int: https://github.com/pandas-dev/pandas/issues/31856
    # test_missing_required_dependencies: https://github.com/pandas-dev/pandas/issues/33999
    python -c 'import pandas; pandas.test(extra_args=["-m not clipboard", "--skip-slow", "--skip-network", "--skip-db", "-n=2", "-k not test_maybe_promote_int_with_int", "-k not test_missing_required_dependency"])'
}
