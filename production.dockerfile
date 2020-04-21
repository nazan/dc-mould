FROM py38int

COPY dc-mould /home/user/app

ENTRYPOINT ["python", "/home/user/app/__main__.py"]