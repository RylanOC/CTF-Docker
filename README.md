# Container for CTF Tools

Collection of tools I use for CTFs

- gdb/GEF
- RR
- b7
- pwntools
- angr



install:

```
docker build -t ctf/base -f Dockerfile .
```



run:

```
docker run -it --rm -v"$(pwd):/home/ctf/challenge" --name ctf ctf/base
```

