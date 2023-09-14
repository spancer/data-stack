FROM python:3.9.6-bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter and other python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN mkdir -p /home/mds/data  /home/mds/notebooks 
RUN mkdir -p /root/.ipython/profile_default/startup
COPY ipython/startup/00-prettytables.py /root/.ipython/profile_default/startup

# setup dagster and dbt
ENV DAGSTER_HOME=/opt/dagster
ENV DAGSTER_DIR=/var/lib/mds/dagster
ENV DBT_DIR=/var/lib/mds/dbt
ENV NOTEBOOKS_DIR=/var/lib/mds/notebooks
ENV DATA_STAGE_DIR=/var/lib/mds/stage
ENV HTML_DIR=/var/lib/mds/html

RUN mkdir -p ${DAGSTER_HOME}  ${DAGSTER_DIR} ${DBT_DIR} ${DATA_STAGE_DIR} ${NOTEBOOKS_DIR} ${HTML_DIR} 
COPY dagster.yaml ${DAGSTER_HOME}

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
CMD ["notebook"]
