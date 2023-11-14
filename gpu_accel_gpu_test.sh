#!/bin/bash

# 기본값 설정
model=""
gap=1  # 기본 gap 값 설정

# 파라미터 처리
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -model)
            model="$2"
            shift
            ;;
        -gap)
            gap="$2"
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift
done

# model 값에 따른 layer_num 값 설정
if [ "$model" == "densenet201" ]; then
    data_file="imagenet1k"
    layer_num=305
elif [ "$model" == "resnet152" ]; then
    data_file="imagenet1k"
    layer_num=205
elif [ "$model" == "enetb0" ]; then
    data_file="imagenet1k"
    layer_num=135
elif [ "$model" == "csmobilenet-v2" ]; then
    data_file="imagenet1k"
    layer_num=80
elif [ "$model" == "squeezenet" ]; then
    data_file="imagenet1k"
    layer_num=49
elif [ "$model" == "yolov7" ]; then
    data_file="coco"
    layer_num=142
elif [ "$model" == "yolov7-tiny" ]; then
    data_file="coco"
    layer_num=98
elif [ "$model" == "yolov4" ]; then
    data_file="coco"
    layer_num=161
elif [ "$model" == "yolov4-tiny" ]; then
    data_file="coco"
    layer_num=37
elif [ -z "$model" ]; then
    echo "Model not specified. Use -model to specify the model."
    exit 1
else
    echo "Unknown model: $model"
    exit 1
fi

# gap 값이 유효한지 확인
if ! [[ "$gap" =~ ^[0-9]+$ ]]; then
    echo "Error: Gap value must be an integer"
    exit 1
fi

# gap 값이 layer_num을 초과하지 않는지 확인
if [ "$gap" -gt "$layer_num" ]; then
    echo "Error: Gap value must not exceed layer number ($layer_num)"
    exit 1
fi

# GPU-accelerated with optimal_core
for var in $(seq 1 $gap $layer_num)
do
    sleep 3s
    ./darknet detector gpu-accel_gpu ./cfg/${data_file}.data ./cfg/${model}.cfg ./weights/${model}.weights data/dog.jpg -num_thread 11 -glayer 305 -num_exp 20 
    sleep 3s
done
