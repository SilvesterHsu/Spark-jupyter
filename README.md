# Spark-jupyter
This is a Docker image for the course COM6012 Scalable Machine Learning of the University of Sheffield.

By request, this image is build based on **python 3.6** and **spark 2.3.2**.

Docker Link: [spark-jupyter](https://cloud.docker.com/u/silvesterhsu/repository/docker/silvesterhsu/spark-jupyter)

Github Link: [spark-jupyter](https://github.com/SilvesterHsu/Spark-jupyter)

# How to run it?

```
docker run -it --name spark --restart=always -p "$PORT":8888 -v "$PWD":/notebooks silvesterhsu/spark-jupyter:"$TAG"
```

`$PORT`: Port mapping. It is the port that needs to link the local to the image. In docker, jupyter will open port `8888` as a web access. If the local port `8888` is not occupied, it is recommended to use `8888`.

`$PWD`: File mapping. Project work path

`$TAG`: For the time being, only `latest` and `slim`, if not filled in, the latest version is downloaded by default. (Recommend `slim`) The ARM version may be available in the future.

**Example:**

```
docker run -it --name spark --restart=always -p 8888:8888 -v ~/new_project:/notebooks silvesterhsu/spark-jupyter:slim
```

## Set password

Once you start container, an unique`token` will be shown in the terminal.

![token](https://tva1.sinaimg.cn/large/006y8mN6gy1g7i9d2cyisj30nz07y451.jpg)

Use the `token` to setup a password when you open the browser `127.0.0.1:8888`.

**note:** The port number depends on the port you are mapping

![set password](https://tva1.sinaimg.cn/large/006y8mN6gy1g7i9ghwmaxj30gg06tdg8.jpg)

Once the password is set and successfully logged in, jupyter completes the password configuration. You need to terminate and restart the spark container in the terminal.

Use `control+C` to stop the spark container, and restart spark container:

```
docker restart spark
```

It is necessary to restart the container. After the password is stored, it needs to be restarted to apply.

Then, setting the password is complete.
