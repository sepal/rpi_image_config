FROM ubuntu:14.04

# Update and install dependencies
RUN apt-get update && apt-get install -y vim python-pip

RUN pip install -U pip

# Clean up.
RUN rm -r /var/lib/apt/lists/*

CMD ["python", "rpi_config.py"]
