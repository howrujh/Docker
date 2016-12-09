# Docker

#build
#docker build --rm -t {NAME} {DOCKERFILE}
docker build --rm -t dev_image .

#run
#docker run -d -p 1204:22 --name {CONTAINER NAME} -v /d/project:/root/project -v /c/Freescale {IMAGE NAME}
docker run -d -p 2222:22 --name dev -v /d/project:/root/project -v /c/Freescale:/root/freescale dev_image
