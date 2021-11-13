FROM julia:1.6.3

EXPOSE 8888

RUN apt update && apt upgrade -y

# Install Python 3.10
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

RUN wget https://www.python.org/ftp/python/3.9.8/Python-3.9.8.tgz

RUN tar -xf Python-3.9.*.tgz

WORKDIR /Python-3.9.8

RUN ./configure --enable-optimizations && make -j 4 && make install

# Install IJulia
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("IJulia");'

# Set up Jupyter    
RUN apt install -y python3-pip
RUN pip3 -q install pip --upgrade

RUN pip3 install jupyter jupyterlab

# Setup remote volume
RUN mkdir /data

WORKDIR /data

# Start Jupyter Notebook 
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]