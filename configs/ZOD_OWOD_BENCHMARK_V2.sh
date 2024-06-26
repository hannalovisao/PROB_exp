#!/usr/bin/env bash

echo running training of prob-detr, M-OWODB dataset

set -x

EXP_DIR=exps/ZOD_clear/PROB_V2
PY_ARGS=${@:1}
WANDB_NAME=PROB_ZOD
DATASET="ZOD"
DATASET_ROOT="./data/OWOD_V2"

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
'''
#TASK 1
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1" --dataset $DATASET --data_root $DATASET_ROOT\
    --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4\
    --train_set 't1_train_improved' --test_set 'zod_cropped_val_clear' --epochs 61\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1" --exemplar_replay_selection --exemplar_replay_max_length 850\
    --exemplar_replay_dir ${WANDB_NAME} --exemplar_replay_cur_file "learned_zod_t1_ft.txt"\
    --lr 2e-4 \
    --wandb_project PROB_ZOD_V2\
    ${PY_ARGS}


#TASK 2
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2" --dataset $DATASET --data_root $DATASET_ROOT\
    --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2\
    --train_set 't2_train_improved' --test_set 'zod_cropped_val_clear' --epochs 51\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
    --wandb_name "${WANDB_NAME}_t2"\
    --exemplar_replay_selection --exemplar_replay_max_length 1743 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "learned_zod_t1_ft.txt" --exemplar_replay_cur_file "learned_zod_t2_ft.txt"\
    --pretrain "${EXP_DIR}/t1/checkpoint0040.pth" --lr 2e-5\
    --wandb_project PROB_ZOD_V2
     ${PY_ARGS}
    

PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t2_ft" --dataset $DATASET --data_root $DATASET_ROOT\
     --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2 \
     --train_set "${WANDB_NAME}/learned_zod_t2_ft" --test_set 'zod_cropped_val_clear' --epochs 111 --lr_drop 40\
     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t2_ft"\
     --pretrain "${EXP_DIR}/t2/checkpoint0050.pth"\
     --lr 2e-4\
     --wandb_project PROB_ZOD_V2
     ${PY_ARGS}
    

#TASK 3 
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3" --dataset $DATASET --data_root $DATASET_ROOT\
     --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4\
     --train_set 't3_train_improved' --test_set 'zod_cropped_val_clear' --epochs 121\
     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3"\
     --exemplar_replay_selection --exemplar_replay_max_length 2361 --exemplar_replay_dir ${WANDB_NAME}\
     --exemplar_replay_prev_file "learned_zod_t2_ft.txt" --exemplar_replay_cur_file "learned_zod_t3_ft.txt"\
     --pretrain "${EXP_DIR}/t2_ft/checkpoint0100.pth" --lr 2e-5 \
     --wandb_project PROB_ZOD_V2
     ${PY_ARGS}
    


#181 epochs originally 
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3_ft" --dataset $DATASET --data_root $DATASET_ROOT\
     --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4 \
     --train_set "${WANDB_NAME}/learned_zod_t3_ft" --test_set 'zod_cropped_val_clear' --epochs 181 --lr_drop 35\
     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3_ft"\
     --pretrain "${EXP_DIR}/t3/checkpoint0120.pth"\
     --wandb_project PROB_ZOD_V2
     ${PY_ARGS}



#TASK 4
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4" --dataset $DATASET --data_root $DATASET_ROOT\
    --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set 't4_train_improved' --test_set 'zod_cropped_val_clear' --epochs 191 \
    --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4"\
    --exemplar_replay_selection --exemplar_replay_max_length 2749 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "learned_zod_t3_ft.txt" --exemplar_replay_cur_file "learned_zod_t4_ft.txt"\
    --num_inst_per_class 40\
    --pretrain "${EXP_DIR}/t3_ft/checkpoint0180.pth" --lr 2e-5\
    --wandb_project PROB_ZOD_V2
    ${PY_ARGS}
'''
    
    
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4_ft" --dataset $DATASET --data_root $DATASET_ROOT\
    --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set "${WANDB_NAME}/learned_zod_t4_ft" --test_set 'zod_cropped_val_clear' --epochs 261 --lr_drop 50\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4_ft"\
    --pretrain "${EXP_DIR}/t4/checkpoint0190.pth" \
    --wandb_project PROB_ZOD_V2
    ${PY_ARGS}


