#!/usr/bin/env bash

echo running training of prob-detr, M-OWODB dataset

set -x

EXP_DIR=exps/ZOD_clear/PROB
PY_ARGS=${@:1}
WANDB_NAME=PROB_ZOD
DATASET="ZOD"

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
# TASK 1
#i1 
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1_100/i1" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t1/train_easy' --test_set 'zod_cropped_val_clear' --epochs 14\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1_i1"\
    --lr 2e-4\
    --annotations_folder 'CL/T1/easy'\
    --wandb_project PROB_ZOD_CL
    ${PY_ARGS}
#i2
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1_100/i2" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t1/train_easy_medium' --test_set 'zod_cropped_val_clear' --epochs 28\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1_i2"\
    --lr 2e-4 --pretrain "${EXP_DIR}/t1_100/i1/checkpoint0013.pth"\
    --annotations_folder 'CL/T1/easy_medium'\
    --wandb_project PROB_ZOD_CL
    ${PY_ARGS}


#i3
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1_100/i3_new" --dataset $DATASET --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t1/train_easy_medium_hard' --test_set 'zod_cropped_val_clear' --epochs 68\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1_i3" --exemplar_replay_selection --exemplar_replay_max_length 850\
    --exemplar_replay_dir ${WANDB_NAME} --exemplar_replay_cur_file "learned_zod_t1_ft.txt"\
    --lr 2e-4 --pretrain "${EXP_DIR}/t1_100/i2/checkpoint0027.pth"\
    --annotations_folder 'CL/T1/easy_medium_hard'\
    --wandb_project PROB_ZOD_CL \
    --eval_every 1\
    ${PY_ARGS}


#TASK 2
#i1
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2_100/i1" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2\
    --train_set 'CL/t2/train_easy' --test_set 'zod_cropped_val_clear' --epochs 73\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
    --wandb_name "${WANDB_NAME}_t2_i2"\
    --pretrain "${EXP_DIR}/t1_100/i3_new/checkpoint0064.pth" --lr 2e-5\
    --annotations_folder 'CL/T2/easy'\
    --wandb_project PROB_ZOD_CL
     ${PY_ARGS}


#i2
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2_100/i2" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2\
    --train_set 'CL/t2/train_easy_medium' --test_set 'zod_cropped_val_clear' --epochs 81\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
    --wandb_name "${WANDB_NAME}_t2_i2"\
    --pretrain "${EXP_DIR}/t2_100/i1/checkpoint0072.pth" --lr 2e-5\
    --annotations_folder 'CL/T2/easy_medium'\
    --wandb_project PROB_ZOD_CL
     ${PY_ARGS}

#i3
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2_100/i3" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2\
    --train_set 'CL/t2/train_easy_medium_hard' --test_set 'zod_cropped_val_clear' --epochs 91\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
    --wandb_name "${WANDB_NAME}_t2_i3"\
    --exemplar_replay_selection --exemplar_replay_max_length 1743 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "learned_zod_t1_ft.txt" --exemplar_replay_cur_file "learned_zod_t2_ft.txt"\
    --pretrain "${EXP_DIR}/t2_100/i2/checkpoint0080.pth" --lr 2e-5\
    --annotations_folder 'CL/T2/easy_medium_hard'\
    --wandb_project PROB_ZOD_CL \
    --eval_every 1
     ${PY_ARGS}


#ft 
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t2_100/ft" --dataset $DATASET --PREV_INTRODUCED_CLS 4 --CUR_INTRODUCED_CLS 2 \
     --train_set "${WANDB_NAME}/learned_zod_t2_ft" --test_set 'zod_cropped_val_clear' --epochs 148 --lr_drop 40\
     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t2_ft"\
     --pretrain "${EXP_DIR}/t2_100/i3/checkpoint0087.pth"\
     --wandb_project PROB_ZOD_CL \
     --eval_every 1
     ${PY_ARGS}



# TASK 3
#i1
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3_100/i1" --dataset $DATASET --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4\
     --train_set 'CL/t3/train_easy' --test_set 'zod_cropped_val_clear' --epochs 156\
     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3_i1"\
     --pretrain "${EXP_DIR}/t2_100/ft/checkpoint0147.pth" --lr 2e-5 \
     --annotations_folder 'CL/T3/easy'\
     --wandb_project PROB_ZOD_CL
     ${PY_ARGS}

#i2
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3_100/i2" --dataset $DATASET --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4\
     --train_set 'CL/t3/train_easy_medium' --test_set 'zod_cropped_val_clear' --epochs 164\
     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3_i2"\
     --pretrain "${EXP_DIR}/t3_100/i1/checkpoint0155.pth" --lr 2e-5 \
     --annotations_folder 'CL/T3/easy_medium'\
     --wandb_project PROB_ZOD_CL
     ${PY_ARGS}

#i3
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3_100/i3" --dataset $DATASET --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4\
     --train_set 'CL/t3/train_easy_medium_hard' --test_set 'zod_cropped_val_clear' --epochs 174\
     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3_i3"\
     --exemplar_replay_selection --exemplar_replay_max_length 2361 --exemplar_replay_dir ${WANDB_NAME}\
     --exemplar_replay_prev_file "learned_zod_t2_ft.txt" --exemplar_replay_cur_file "learned_zod_t3_ft.txt"\
     --pretrain "${EXP_DIR}/t3_100/i2/checkpoint0163.pth" --lr 2e-5 \
     --annotations_folder 'CL/T3/easy_medium_hard'\
     --wandb_project PROB_ZOD_CL\
     --eval_every 1
     ${PY_ARGS}
    

#ft
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
     --output_dir "${EXP_DIR}/t3_100/ft" --dataset $DATASET --PREV_INTRODUCED_CLS 6 --CUR_INTRODUCED_CLS 4 \
     --train_set "${WANDB_NAME}/learned_zod_t3_ft" --test_set 'zod_cropped_val_clear' --epochs 234 --lr_drop 35\
     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
     --wandb_name "${WANDB_NAME}_t3_ft"\
     --pretrain "${EXP_DIR}/t3_100/i3/checkpoint0173.pth"\
     --wandb_project PROB_ZOD_CL\
     --eval_every 5
     ${PY_ARGS}



# TASK4
#i1
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4_100/i1" --dataset $DATASET --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t4/train_easy' --test_set 'zod_cropped_val_clear' --epochs 239 \
    --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4_i1"\
    --num_inst_per_class 40\
    --pretrain "${EXP_DIR}/t3_100/ft/checkpoint0230.pth" --lr 2e-5\
    --annotations_folder 'CL/T4/easy'\
    --wandb_project PROB_ZOD_CL
    ${PY_ARGS}

#i2
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4_100/i2" --dataset $DATASET --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t4/train_easy_medium' --test_set 'zod_cropped_val_clear' --epochs 247 \
    --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4_i2"\
    --num_inst_per_class 40\
    --pretrain "${EXP_DIR}/t4_100/i1/checkpoint0238.pth" --lr 2e-5\
    --annotations_folder 'CL/T4/easy_medium'\
    --wandb_project PROB_ZOD_CL
    ${PY_ARGS}

#i3
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4_100/i3" --dataset $DATASET --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set 'CL/t4/train_easy_medium_hard' --test_set 'zod_cropped_val_clear' --epochs 257 \
    --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4_i3"\
    --exemplar_replay_selection --exemplar_replay_max_length 2749 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "learned_zod_t3_ft.txt" --exemplar_replay_cur_file "learned_zod_t4_ft.txt"\
    --num_inst_per_class 40\
    --pretrain "${EXP_DIR}/t4_100/i2/checkpoint0246.pth" --lr 2e-5\
    --annotations_folder 'CL/T4/easy_medium_hard'\
    --wandb_project PROB_ZOD_CL\
    --eval_every 1 
    ${PY_ARGS}

    
''' 
#ft  
PY_ARGS=${@:1}
$PYTHON_CMD -u main_open_world.py \
    --output_dir "${EXP_DIR}/t4_100/ft" --dataset $DATASET --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 4\
    --train_set "${WANDB_NAME}/learned_zod_t4_ft" --test_set 'zod_cropped_val_clear' --epochs 325 --lr_drop 50\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t4_ft"\
    --pretrain "${EXP_DIR}/t4_100/i3/checkpoint0254.pth" \
    --wandb_project PROB_ZOD_CL\
    --eval_every 5 \
    ${PY_ARGS}
