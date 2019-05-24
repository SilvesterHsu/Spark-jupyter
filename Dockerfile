FROM python:3.7

MAINTAINER Seel 459745355@qq.com

#
RUN apt-get update
RUN apt-get install curl nano tree -y

# COPY Files
COPY . /root/

# JAVA
RUN chmod 777 /root/install_java.sh
RUN /root/install_java.sh
RUN java -version

# SPARK
ARG SPARK_ARCHIVE=http://apache.spinellicreations.com/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
# ARG SPARK_ARCHIVE=https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
RUN curl -s $SPARK_ARCHIVE | tar -xz -C /usr/local/

ENV SPARK_HOME /usr/local/spark-2.4.3-bin-hadoop2.7
# ENV SPARK_HOME /usr/local/spark-2.2.0-bin-hadoop2.7
ENV PATH $PATH:$SPARK_HOME/bin

# PIP
RUN pip install -r /root/requirements.txt
RUN mkdir /root/.jupyter/ && \
    mv /root/jupyter_notebook_config.py /root/.jupyter/
EXPOSE 8888

# ENVIRONMENT VARIABLES
ENV JAVA_HOME /opt/jdk/jdk1.8.0_211
ENV PYSPARK_PYTHON /usr/local/bin/python
ENV PYTHONPATH /usr/local/spark-2.4.3-bin-hadoop2.7/python/lib/py4j-0.10.7-src.zip:/usr/local/spark-2.4.3-bin-hadoop2.7/python:PYSPARK_DRIVER_PYTHON=ipython
# ENV PYTHONPATH /usr/local/spark-2.2.0-bin-hadoop2.7/python/lib/py4j-0.10.4-src.zip:/usr/local/spark-2.2.0-bin-hadoop2.7/python:PYSPARK_DRIVER_PYTHON=ipython

RUN mkdir /notebooks
WORKDIR "/notebooks"
CMD ["/bin/bash", "-c", "jupyter notebook --allow-root"]
