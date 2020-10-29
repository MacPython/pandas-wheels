function setup_test_venv {
    # Create a new empty venv dedicated to testing for non-Linux platforms. On
    # Linux the tests are run in a Docker container.
    if [ $(uname) != "Linux" ]; then
        deactivate || echo ""
        $PYTHON_EXE -m venv test_venv
        if [ $(uname) == "Darwin" ]; then
            source test_venv/bin/activate
        else
            source test_venv/Scripts/activate
        fi
        # Note: the idiom "python -m pip install ..." is necessary to upgrade
        # pip itself on Windows. Otherwise one would get a permission error on
        # pip.exe.
        python -m pip install --upgrade pip wheel
        if [ "$TEST_DEPENDS" != "" ]; then
            pip install $TEST_DEPENDS
        fi
    fi
}

function teardown_test_venv {
    if [ $(uname) != "Linux" ]; then
        deactivate || echo ""
        if [ $(uname) == "Darwin" ]; then
            source venv/bin/activate
        fi
    fi
} 

# Work around bug in multibuild. This is copied from NumPy-wheels
# https://github.com/MacPython/numpy-wheels/blob/34c2cdaca98d020081f5d03983d1c78b3b2a828c/extra_functions.sh#L50
if [ ! -o PIP_CMD ]; then PIP_CMD="$PYTHON_EXE -m pip"; fi
