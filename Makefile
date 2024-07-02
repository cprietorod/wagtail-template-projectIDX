install:
	if [ ! -d .venv ]; then \
		python -m venv .venv; \
		source $(PWD)/.venv/bin/activate; \
		pip install -r requirements.txt; \
	fi

migrate:
	source .venv/bin/activate && \
	python manage.py migrate

makemigrations:
	source .venv/bin/activate && \
	export DJANGO_SETTINGS_MODULE='mysite.dev'; \
	python manage.py makemigrations

run:
	source .venv/bin/activate && \
	export DJANGO_SETTINGS_MODULE='mysite.dev'; \
	python manage.py runserver $(PORT)

install-oh-my-bash:
	if [ ! -d ~/.oh-my-bash ]; then \
		git clone https://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash; \
		cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc; \
	fi
