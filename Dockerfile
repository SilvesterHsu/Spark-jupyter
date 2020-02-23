FROM debian:buster-slim as build

# Essential tools
RUN apt update && \
    apt install wget -y

# JDK 8
ARG JDK_ARCHIVE=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u242b08.tar.gz
RUN wget $JDK_ARCHIVE && \
    tar -C /usr/local -xzvf OpenJDK8U-jdk_x64_linux_hotspot_8u242b08.tar.gz

# SPARK
RUN wget http://archive.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz && \
    tar -C /usr/local -xzvf spark-2.3.2-bin-hadoop2.7.tgz && \
    mv /usr/local/spark-2.3.2-bin-hadoop2.7 /usr/local/spark-2.3.2

FROM python:3.6-slim

MAINTAINER Seel 459745355@qq.com

COPY --from=build /usr/local/ /usr/local/

# PIP
COPY requirements.txt /root/
COPY jupyter_notebook_config.py /root/
RUN pip install -r /root/requirements.txt
RUN mkdir /root/.jupyter/ && \
    mv /root/jupyter_notebook_config.py /root/.jupyter/  && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter nbextension enable splitcell/splitcell && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable snippets_menu/main && \
    jupyter nbextension enable code_prettify/autopep8 && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable latex_envs/latex_envs

# ENVIRONMENT VARIABLES
ENV SPARK_HOME /usr/local/spark-2.3.2
ENV PYSPARK_PYTHON /usr/local/bin/python
ENV PYTHONPATH /usr/local/spark-2.3.2/python/lib/py4j-0.10.7-src.zip:/usr/local/spark-2.3.2/python:PYSPARK_DRIVER_PYTHON=ipython
ENV PATH $PATH:$SPARK_HOME/bin

ENV JAVA_HOME /usr/local/jdk8u242-b08/jre
ENV PATH $PATH:/usr/local/jdk8u242-b08/bin

RUN mkdir /notebooks
WORKDIR "/notebooks"

EXPOSE 8888
VOLUME ["/notebooks"]
CMD ["/bin/bash", "-c", "jupyter notebook --allow-root"]
