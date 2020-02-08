
PACKAGE	:= lavista
VERSION	:= $(shell grep version setup.py |cut -d\' -f2)

PIP	:= pip
PIPFLAGS	:=

PYTHON	:= python
PYTHONFLAGS	:=

TARGZ	:= $(PACKAGE)-$(VERSION).tar.gz

VIRTUALENV	:= python -m venv
VIRTUALENVFLAGS	:=
VENV	:= venv


%:	%.in Makefile
	m4 -D M4_VERSION=$(VERSION) $< > $@

all:	dist

$(VENV)/bin/activate:
	$(VIRTUALENV) $(VIRTUALENVFLAGS) $(VENV)

$(VENV)/bin/$(PACKAGE):	setup.py $(VENV)/bin/activate
	. $(VENV)/bin/activate && $(PIP) $(PIPFLAGS) install -r requirements_dev.txt

dev:	$(VENV)/bin/$(PACKAGE)

python_test:	dev setup.py
	. $(VENV)/bin/activate && \
		$(PYTHON) setup.py test -q && \
		tox

bandit:	dev
	. $(VENV)/bin/activate && \
		bandit -r $(PACKAGE)/*.py

safety:	dev
	. $(VENV)/bin/activate && \
		pip freeze > safety.txt && \
		safety check -r safety.txt ; \
		rm -f safety.txt

check:	safety bandit

dist/$(TARGZ):	setup.py
	$(PYTHON) $(PYTHONFLAGS) setup.py sdist

dist:	dist/$(TARGZ) setup.py

install:	dist
	$(PIP) $(PIPFLAGS) install -U dist/$(TARGZ)
	
clean:
	rm -fr .tox dist *.egg-info venv safety.txt

.PHONY:	all bandit check clean dev dist python_test safety

