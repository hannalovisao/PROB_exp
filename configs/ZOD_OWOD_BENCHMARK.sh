#!/usr/bin/env bash

echo running training of prob-detr, M-OWODB dataset

set -x

EXP_DIR=exps/ZOD/PROB
PY_ARGS=${@:1}
WANDB_NAME=PROB_ZOD

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

$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1" --dataset ZOD --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 14\
    --train_set 'zod_train' --test_set 'zod_all_task_test' --epochs 10\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1" --exemplar_replay_selection --exemplar_replay_max_length 850\
    --exemplar_replay_dir ${WANDB_NAME} --exemplar_replay_cur_file "learned_zod_t1_ft.txt"\
    ${PY_ARGS}
    

# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t2" --dataset TOWOD --PREV_INTRODUCED_CLS 20 --CUR_INTRODUCED_CLS 20\
#     --train_set 'owod_t2_train' --test_set 'owod_all_task_test' --epochs 51\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
#     --wandb_name "${WANDB_NAME}_t2"\
#     --exemplar_replay_selection --exemplar_replay_max_length 1743 --exemplar_replay_dir ${WANDB_NAME}\
#     --exemplar_replay_prev_file "learned_owod_t1_ft.txt" --exemplar_replay_cur_file "learned_owod_t2_ft.txt"\
#     --pretrain "${EXP_DIR}/t1/checkpoint0040.pth" --lr 2e-5\
#     ${PY_ARGS}
    

# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t2_ft" --dataset TOWOD --PREV_INTRODUCED_CLS 20 --CUR_INTRODUCED_CLS 20 \
#     --train_set "${WANDB_NAME}/learned_owod_t2_ft" --test_set 'owod_all_task_test' --epochs 111 --lr_drop 40\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t2_ft"\
#     --pretrain "${EXP_DIR}/t2/checkpoint0050.pth"\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t3" --dataset TOWOD --PREV_INTRODUCED_CLS 40 --CUR_INTRODUCED_CLS 20\
#     --train_set 'owod_t3_train' --test_set 'owod_all_task_test' --epochs 121\
#     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t3"\
#     --exemplar_replay_selection --exemplar_replay_max_length 2361 --exemplar_replay_dir ${WANDB_NAME}\
#     --exemplar_replay_prev_file "learned_owod_t2_ft.txt" --exemplar_replay_cur_file "learned_owod_t3_ft.txt"\
#     --pretrain "${EXP_DIR}/t2_ft/checkpoint0110.pth" --lr 2e-5 \
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t3_ft" --dataset TOWOD --PREV_INTRODUCED_CLS 40 --CUR_INTRODUCED_CLS 20 \
#     --train_set "${WANDB_NAME}/learned_owod_t3_ft" --test_set 'owod_all_task_test' --epochs 181 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t3_ft"\
#     --pretrain "${EXP_DIR}/t3/checkpoint0120.pth"\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t4" --dataset TOWOD --PREV_INTRODUCED_CLS 60 --CUR_INTRODUCED_CLS 20\
#     --train_set 'owod_t4_train' --test_set 'owod_all_task_test' --epochs 191 \
#     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t4"\
#     --exemplar_replay_selection --exemplar_replay_max_length 2749 --exemplar_replay_dir ${WANDB_NAME}\
#     --exemplar_replay_prev_file "learned_owod_t3_ft.txt" --exemplar_replay_cur_file "learned_owod_t4_ft.txt"\
#     --num_inst_per_class 40\
#     --pretrain "${EXP_DIR}/t3_ft/checkpoint0180.pth" --lr 2e-5\
#     ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# $PYTHON_CMD -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t4_ft" --dataset TOWOD --PREV_INTRODUCED_CLS 60 --CUR_INTRODUCED_CLS 20\
#     --train_set "${WANDB_NAME}/learned_owod_t4_ft" --test_set 'owod_all_task_test' --epochs 261 --lr_drop 50\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t4_ft"\
#     --pretrain "${EXP_DIR}/t4/checkpoint0190.pth" \
#     ${PY_ARGS}