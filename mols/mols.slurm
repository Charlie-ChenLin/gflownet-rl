#!/bin/bash

#SBATCH --job-name=GFN-RL-mols
#SBATCH --time=12-00:00:00          # 运行时间
#SBATCH --partition=RTX3090,RTX4090,ADA6000,L40S
#SBATCH --nodes=1                  # 单节点
#SBATCH --ntasks-per-node=1        # 每个节点上并行 6 个任务
#SBATCH --cpus-per-task=24          # 每个任务分配 2 个 CPU 核心
#SBATCH --gres=gpu:1               # 每个节点分配 6 张 GPU
#SBATCH --mail-type=all            # 邮件通知类型
#SBATCH --mail-user=chenlin114514@sjtu.edu.cn
#SBATCH --output=/home/lchen/home/gflownet-rl/log/%j.out
#SBATCH --error=/home/lchen/home/gflownet-rl/log/%j.err
#SBATCH --array=23         

# 加载 Conda 环境
source /home/lchen/miniconda3/etc/profile.d/conda.sh
conda activate gflownet-rl

# 切换到项目目录
cd /home/lchen/home/gflownet-rl/mols

export https_proxy=http://192.168.102.20:7890
export http_proxy=http://192.168.102.20:7890
export all_proxy=socks://192.168.102.20:7890
export WANDB_MODE=offline
export WANDB_API_KEY="2e3f0cdfb6089a1e52ee117856ca6dfcf331858b"

entropy_coeff=1.0
methods=("db" "tb" "subtb")
alphas=(0.1 0.2 0.3 0.4 0.45 0.5 0.525 0.55 0.6 0.7 0.8 0.9)
train_seeds=(0 1 2 3)

# 展平所有组合到一个数组
combos=()
for m in "${methods[@]}"; do
  for a in "${alphas[@]}"; do
    for s in "${train_seeds[@]}"; do
      combos+=("$m,$a,$s")
    done
  done
done

total=${#combos[@]}
chunk_size=6
start=$(( SLURM_ARRAY_TASK_ID * chunk_size ))
end=$(( start + chunk_size - 1 ))
if [ $end -ge $(( total - 1 )) ]; then
  end=$(( total - 1 ))
fi

# 在本 array job 内并行启动这 chunk_size(=6) 个任务
for idx in $(seq $start $end); do
  IFS=, read method alpha train_seed <<< "${combos[$idx]}"
  echo "[$SLURM_ARRAY_TASK_ID:$idx] method=${method}, alpha=${alpha}, seed=${train_seed}"
  echo "molecule generation running method(${method})_alpha(${alpha})_seed(${train_seed})_ec(${entropy_coeff}) with wandb_mode ${WANDB_MODE}"
  python gflownet.py \
       --objective ${method} \
       --alpha ${alpha} \
       --train_seed ${train_seed} \
       --entropy_coeff ${entropy_coeff} &
done

wait
echo "All tasks in array $SLURM_ARRAY_TASK_ID done."
