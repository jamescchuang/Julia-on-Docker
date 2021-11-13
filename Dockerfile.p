FROM python:3.9-slim

EXPOSE 8888

RUN apt update && apt -y upgrade && apt install -y wget

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-x86_64.tar.gz && \
    tar zxvf julia-1.6.3-linux-x86_64.tar.gz

RUN mkdir /data

WORKDIR /julia-1.6.3/bin

RUN ./julia -e 'import Pkg; Pkg.update()' && \
    ./julia -e 'import Pkg; Pkg.add("IJulia");'

RUN pip3 install jupyter jupyterlab

WORKDIR /data

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
