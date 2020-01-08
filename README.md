# Container for CTF Tools

Collection of tools I use for CTFs

- gdb/GEF
- RR
- b7
- pwntools
- angr
- one_gadget



install:

```
docker build -t ctf -f Dockerfile .
```



run:

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm -v"$(pwd):/home/ctf/challenge" --name ctf ctf
```

