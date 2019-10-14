# Container for CTF Tools

install:

```
docker build -t ctf/base -f Dockerfile .
```



run:

```
docker run -it --rm -v"$(pwd):/ctf" --name ctf ctf/base
```

