FROM amd64/python:3.7-buster
COPY /libs /libs
COPY /api /api

RUN pip3 install --upgrade pip 
RUN pip3 install -e /libs
WORKDIR /api
RUN pip3 install -r requirements.txt
EXPOSE 80
CMD [ "uvicorn", "main:app", "--port=80", "--host", "0.0.0.0"]
