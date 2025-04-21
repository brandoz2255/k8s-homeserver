### How to build it

1. run this command

```bash
docker buildx build -t <your_image_name> .
```

#### How to run it

```bash
docker run -it --rm \
    -v "$(pwd)":/app/output \
    <your_image_name> \
```
