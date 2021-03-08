### Darknet V3 on cuda10.1-cudnn7
- Based on [AlexeyAB YoloV3](https://github.com/AlexeyAB/darknet.git)
- Compiled on **cuda 10.1 ** and **cudnn7**
- Compiled with **OpenCV 3.4.8**
- **Python3.7** with pillow, opencv-python, pandas, numpy

### Usage
```sh
docker pull sebitworld/darknet_v3:latest

docker run -it --rm --gpus all sebitworld/darknet_v3:latest bash

root@338872906f3e:/usr/workspace# ll darknet/darknet
-rwxr-xr-x 1 root root 907888 Mar  8 12:47 darknet
```

------------
Made with <span style="color: #e25555;">&hearts;</span> in Hong Kong by [sebit.world](https://www.sebit.world)

