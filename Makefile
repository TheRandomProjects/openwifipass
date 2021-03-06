.PHONY: ci checkformat isort lint pylint test autoformat

VENV=venv
PYTHON=$(VENV)/bin/python3

ci: isort checkformat lint pylint test

$(VENV): $(VENV)/bin/activate

$(VENV)/bin/activate: setup.py requirements-dev.txt Makefile
ifeq (, $(shell which virtualenv))
	$(error "`virtualenv` is not installed, consider running `pip3 install virtualenv`")
endif
	test -d $(VENV) || virtualenv -p python3 $(VENV)
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements-dev.txt
	$(PYTHON) -m pip install -e .
	touch $(VENV)/bin/activate

checkformat: $(VENV)
	$(PYTHON) -m black . --check --diff --exclude $(VENV)

lint: $(VENV)	
	$(PYTHON) -m flake8 . --count --show-source --statistics --exclude $(VENV)

pylint: $(VENV)
	$(PYTHON) -m pylint --rcfile=setup.cfg openwifipass tests

isort: $(VENV)
	$(PYTHON) -m isort -c openwifipass/**.py
	$(PYTHON) -m isort -c tests/**.py

test: $(VENV)
	$(PYTHON) -m pytest

autoformat: $(VENV)
	$(PYTHON) -m isort openwifipass/**.py
	$(PYTHON) -m isort tests/**.py
	$(PYTHON) -m black . --exclude $(VENV)
