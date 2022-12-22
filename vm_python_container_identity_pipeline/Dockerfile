# Executed on machine running terraform
# Build image from this and then push to ACR
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y gcc
RUN mkdir /app
RUN chmod 775 /app
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY ./app /app
EXPOSE 8081
ENTRYPOINT ["python3", "app.py"]