FROM python:3-stretch

RUN pip install pipenv

WORKDIR /app

ADD vendor /app/vendor
ADD Pipfile /app/Pipfile
ADD Pipfile.lock /app/Pipfile.lock
RUN pipenv install --system --deploy

ADD . /app

EXPOSE 8080
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["webhook_server"]
