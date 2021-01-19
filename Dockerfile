FROM julia:1.5.3

RUN apt-get update && apt-get install -y \
    build-essential \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN julia -e '\
using Pkg; \
Pkg.add(["Plots", "PackageCompiler"]); \
Pkg.add(["PyCall", "IJulia", "Conda"]); \
using Conda; Conda.add("jupyter"); \
Pkg.precompile(); \
'

RUN julia -e 'using PackageCompiler; create_sysimage([:Plots,], sysimage_path="sys.so")'

ENV PATH=/root/.julia/conda/3/bin:${PATH}

EXPOSE 8888
