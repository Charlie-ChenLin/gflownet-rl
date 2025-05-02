#!/bin/bash

#SBATCH --job-name=GFN-RL-bitseq
#SBATCH --time=12-00:00:00          # 运行时间
#SBATCH --partition=RTX3090,RTX4090,ADA6000,L40S,A100
#SBATCH --nodes=1               # 单节点
#SBATCH --ntasks-per-node=1     # 每个节点上的任务数，2张GPU对应2个任务
#SBATCH --cpus-per-task=12    # 每个任务分配的CPU核数
#SBATCH --gres=gpu:1            
#SBATCH --mail-type=all         # 邮件通知类型
#SBATCH --mail-user=chenlin114514@sjtu.edu.cn # 邮件地址
#SBATCH --output=/home/lchen/home/gflownet-rl/log/%j.out
#SBATCH --error=/home/lchen/home/gflownet-rl/log/%j.err
#SBATCH --array=0-65


# 加载 Conda 环境
source /home/lchen/miniconda3/etc/profile.d/conda.sh
conda activate gflownet-rl-raw

# 切换到项目目录
cd /home/lchen/home/gflownet-rl/bitseq

# 设置随机 MASTER_PORT 避免端口冲突
export WANDB_MODE=offline
export WANDB_API_KEY="2e3f0cdfb6089a1e52ee117856ca6dfcf331858b"
export MASTER_PORT=$((20000 + RANDOM % 10000))


# 定义参数空间
ks=(1 2 4 6 8 10)
methods=("db" "tb" "subtb")
alphas=(0.1 0.2 0.3 0.4 0.45 0.5 0.55 0.6 0.7 0.8 0.9)
seeds=(0 1 2 3 4)

batch_size=15
per_k_tasks=$(( ${#methods[@]} * ${#alphas[@]} * ${#seeds[@]} ))   # =3×11×5=165
batches_per_k=$(( (per_k_tasks + batch_size - 1) / batch_size ))  # =11

# 当前 array 号
g=$SLURM_ARRAY_TASK_ID
# 计算 k 组号 和 该 k 组内的 batch 序号
k_idx=$(( g / batches_per_k ))
sub_batch=$(( g % batches_per_k ))

# 该组 k 值
k=${ks[$k_idx]}

# 在该 k 组内，计算本 batch 的全局起止 idx（仅针对该 k 组）
start=$(( k_idx*per_k_tasks + sub_batch*batch_size ))
end=$(( start + batch_size - 1 ))

# launch 15 tasks sharing same k
for idx in $(seq $start $end); do
    # 防止最后一个 batch 越界
    if [ $idx -ge $(( (k_idx+1)*per_k_tasks )) ]; then
        break
    fi

    # 在该 k 组内，用 idx' 计算 method/alpha/seed
    relative=$(( idx - k_idx*per_k_tasks ))
    m_idx=$(( relative / ( ${#alphas[@]} * ${#seeds[@]} ) ))
    a_idx=$(( (relative / ${#seeds[@]}) % ${#alphas[@]} ))
    s_idx=$(( relative % ${#seeds[@]} ))

    method=${methods[$m_idx]}
    alpha=${alphas[$a_idx]}
    seed=${seeds[$s_idx]}

    cmd="python run.py \
        --objective ${method} \
        --k ${k} \
        --learning_rate 0.002 \
        --alpha ${alpha} \
        --seed ${seed}"
    if [ "$method" = "subtb" ]; then
        cmd+=" --subtb_lambda 1.9"
    fi

    echo "[$SLURM_ARRAY_JOB_ID:$SLURM_ARRAY_TASK_ID:$idx] $cmd"
    echo "running method(${method})_alpha(${alpha})_k(${k})_seed(${seed})"

    $cmd &
done

wait