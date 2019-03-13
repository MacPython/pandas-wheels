# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    :
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
    # --deselect for 0.24.x
    # https://travis-ci.org/MacPython/pandas-wheels/builds/505474702
    python -c 'import pandas; pandas.test(extra_args=["--skip-slow", "--skip-network", "--skip-db", "-n=2", "--deselect=pandas/tests/indexes/multi/test_analytics.py::test_numpy_ufuncs", "--deselect=pandas/tests/io/test_common.py::TestCommonIOCapabilities::test_write_fspath_all"])'
}
