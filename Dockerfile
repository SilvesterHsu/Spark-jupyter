From silvesterhsu/raspberrypi-jdk as build

# Essential tools
RUN apt update && \
    apt install wget -y

# JDK 8 use the prebuild images(silvesterhsu/raspberrypi-jdk), and the packages are stored
# in /usr/local/jdk8u241

# SPARK
RUN wget http://archive.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz && \
    tar -C /usr/local -xzvf spark-2.3.2-bin-hadoop2.7.tgz && \
    mv /usr/local/spark-2.3.2-bin-hadoop2.7 /usr/local/spark-2.3.2

FROM python:3.6

MAINTAINER Seel 459745355@qq.com

COPY --from=build /usr/local/ /usr/local/

# install essential software & oh-my-zsh
RUN apt update && \
    apt-get install zsh curl git tree nano -y && \
    chsh -s /bin/zsh && \
    echo y|sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc && \
    zsh && \
    rm -rf rm -rf /var/lib/apt/lists/*

# Python packages build dependence
RUN pip install cpython pybind11 && \
    easy_install cython && \
    apt update && \
    apt install -y cython3 python-pip python3-dev python-setuptools build-essential \
    libblas3 liblapack3 liblapack-dev libblas-dev gfortran libopenblas-dev \
    gcc cython libopenblas-base libatlas3-base python3-lxml libxml2-dev libxslt1-dev \
    libssl-dev libffi-dev zlib1g-dev \
    libfreetype6 libfreetype6-dev pkg-config python3-matplotlib && \
    rm -rf rm -rf /var/lib/apt/lists/*

# PIP
RUN pip install pyspark==2.3.2 numpy scipy pandas jupyter notebook==5.7.8 \
    jupyter_contrib_nbextensions jupyter_nbextensions_configurator autopep8 \
    matplotlib scikit-learn
RUN jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter nbextension enable splitcell/splitcell && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable execute_time/ExecuteTime && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable snippets_menu/main && \
    jupyter nbextension enable code_prettify/autopep8 && \
    jupyter nbextension enable toggle_all_line_numbers/main && \
    jupyter nbextension enable latex_envs/latex_envs && \
    echo "c.NotebookApp.terminado_settings = {'shell_command': ['/bin/zsh']}" >> ~/.jupyter/jupyter_notebook_config.py

# ENVIRONMENT VARIABLES
ENV SPARK_HOME /usr/local/spark-2.3.2
ENV PYSPARK_PYTHON /usr/local/bin/python
ENV PYTHONPATH /usr/local/spark-2.3.2/python/lib/py4j-0.10.7-src.zip:/usr/local/spark-2.3.2/python:PYSPARK_DRIVER_PYTHON=ipython
ENV PATH $PATH:$SPARK_HOME/bin

ENV JAVA_HOME /usr/local/jdk8u241/jre
ENV PATH $PATH:/usr/local/jdk8u241/bin

EXPOSE 8888
RUN mkdir /notebooks
WORKDIR "/notebooks"
VOLUME ["/notebooks"]

CMD ["/bin/bash", "-c", "jupyter notebook --ip=0.0.0.0 --allow-root"]
