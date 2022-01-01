python --version
pip install pytz six numpy python-dateutil
pip install --find-links=pandas/pandas/dist --no-index pandas
python -c "import pandas as pd; print(pd.__version__)"
