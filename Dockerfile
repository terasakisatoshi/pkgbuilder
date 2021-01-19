FROM julia:1.5.3

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

USER ${NB_USER}

RUN julia -e '\
using Pkg; \
Pkg.add(["Plots", "PackageCompiler"]); \
Pkg.add(["PyCall", "IJulia", "Conda"]); \
using Conda; Conda.add("jupyter"); \
Pkg.precompile(); \
'

USER root

RUN julia -e 'using PackageCompiler; create_sysimage([:Plots,], replace_default=true)'
RUN chown -R ${NB_UID} /usr/local/julia

USER ${NB_USER}
ENV PATH=${HOME}/.julia/conda/3/bin:${PATH}

EXPOSE 8888
