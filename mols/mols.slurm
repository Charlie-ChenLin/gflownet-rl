#!/bin/bash

#SBATCH --job-name=GFN-RL-mols
#SBATCH --time=12-00:00:00          # 运行时间
#SBATCH --partition=RTX4090
#SBATCH --nodes=1               # 单节点
#SBATCH --ntasks-per-node=1     # 每个节点上的任务数，2张GPU对应2个任务
#SBATCH --cpus-per-task=2    # 每个任务分配的CPU核数
#SBATCH --gres=gpu:1            
#SBATCH --mail-type=all         # 邮件通知类型
#SBATCH --mail-user=chenlin114514@sjtu.edu.cn # 邮件地址
#SBATCH --output=/home/lchen/home/gflownet-rl/log/%j.out
#SBATCH --error=/home/lchen/home/gflownet-rl/log/%j.err

# 加载 Conda 环境
source /home/lchen/miniconda3/etc/profile.d/conda.sh
conda activate gflownet-rl-raw

# 切换到项目目录
cd /home/lchen/home/gflownet-rl
pip install -r requirements_mols.txt

# 设置随机 MASTER_PORT 避免端口冲突
# export WANDB_API_KEY="2e3f0cdfb6089a1e52ee117856ca6dfcf331858b"
# export MASTER_PORT=$((20000 + RANDOM % 10000))