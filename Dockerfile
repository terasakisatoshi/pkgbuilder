FROM julia:1.5.3

RUN apt-get update && apt-get install -y build-essential

RUN julia -e 'using Pkg; Pkg.add(["Example", "PackageCompiler"]); Pkg.precompile()'
RUN julia -e 'using PackageCompiler; create_sysimage(:Example, sysimage_path="sys.so")'
