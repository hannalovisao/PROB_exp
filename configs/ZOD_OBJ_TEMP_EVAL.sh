#!/usr/bin/env bash

echo running eval ofnano prob-detr, M-OWODB dataset

set -x

EXP_DIR=exps/ZOD_clear/PROB
PY_ARGS=${@:1}
WANDB_NAME=PROB_eval
DATASET="ZOD"
DETS_DIR="./results/normal"

#!/bin/bash

# Try to use python3 by default
if command -v python3 &>/dev/null; then
    PYTHON_CMD=python3
elif command -v python &>/dev/null; then
    # Fallback to python if python3 is not available
    PYTHON_CMD=python
else
    echo "Python is not installed."
    exit 1
fi

# Use $PYTHON_CMD for your Python command
echo "Using $PYTHON_CMD"
$PYTHON_CMD -c "print('Hello, World!')"

# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4 \
#     --train_set "CL/t1/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.9\
#     --pretrain "${EXP_DIR}/t1_100/checkpoint0040.pth" --eval \
#     #--dets_out_dir $DETS_DIR --dets_filename 't1_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}

# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2 \
#     --train_set "CL/t2/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.9\
#     --pretrain "${EXP_DIR}/t2_ft_100/checkpoint0095.pth" --eval \
#     #--dets_out_dir $DETS_DIR --dets_filename 't2_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}

start=0.1
end=2.9
increment=0.4

# Loop by using bc for floating point math
for i in $(seq $start $increment $end); do
    PY_ARGS=${@:1}
    $PYTHON_CMD -u main_open_world.py \
        --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4 \
        --train_set "CL/t1/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
        --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp $i\
        --pretrain "${EXP_DIR}/t1_100/checkpoint0040.pth" --eval \
        #--dets_out_dir $DETS_DIR --dets_filename 't1_dets.json'\
        --wandb_project 'ZOD_eval'\
        ${PY_ARGS}
done

for i in $(seq $start $increment $end); do
    PY_ARGS=${@:1}
    $PYTHON_CMD -u main_open_world.py \
        --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2 \
        --train_set "CL/t2/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
        --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp $i\
        --pretrain "${EXP_DIR}/t2_ft_100/checkpoint0095.pth" --eval \
        #--dets_out_dir $DETS_DIR --dets_filename 't2_dets.json'\
        --wandb_project 'ZOD_eval'\
        ${PY_ARGS}
done
 
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4 \
#     --train_set "CL/t1/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --pretrain "${EXP_DIR}/t1_100/checkpoint0040.pth" --eval \
#     #--dets_out_dir $DETS_DIR --dets_filename 't1_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2 \
#     --train_set "CL/t2/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --pretrain "${EXP_DIR}/t2_ft_100/checkpoint0095.pth" --eval \
#     #--dets_out_dir $DETS_DIR --dets_filename 't2_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4 \
#     --train_set "CL/t3/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --pretrain "${EXP_DIR}/t3_ft_100/checkpoint0180.pth" --eval \
#     --dets_out_dir $DETS_DIR --dets_filename 't3_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset $DATASET --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4 \
#     --train_set "CL/t4/train_easy_medium_hard" --test_set 'zod_cropped_val_clear' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --pretrain "${EXP_DIR}/t4_ft_100/checkpoint0260.pth" --eval \
#     --dets_out_dir $DETS_DIR --dets_filename 't4_dets.json'\
#     --wandb_project 'ZOD_eval'\
#     ${PY_ARGS}
    
    