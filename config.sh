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
    python --version
    python -c 'import pandas; pandas.show_versions()'
    # See: https://travis-ci.org/MacPython/pandas-wheels/jobs/142409427#L657
    # for ascii decoding error on Python 3, so test skipped here.
    local py_ver=$(python --version 2>&1 | awk '{print $2}')
    if [ $(lex_ver $py_ver) -ge $(lex_ver 3) ]; then
        local extra_nose="-e test_to_latex_filename"
    fi
    nosetests pandas \
        -A "not slow and not network and not disabled" \
        -e test_abs -e test_order -e test_argsort -e test_numpy_argsort \
        $extra_nose
}
