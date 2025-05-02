#!/bin/bash

#SBATCH --job-name=GFN-RL-bitseq
#SBATCH --time=12-00:00:00          # 运行时间
#SBATCH --partition=A100
#SBATCH --nodes=1               # 单节点
#SBATCH --ntasks-per-node=1     # 每个节点上的任务数，2张GPU对应2个任务
#SBATCH --cpus-per-task=8    # 每个任务分配的CPU核数
#SBATCH --gres=gpu:1            
#SBATCH --mail-type=all         # 邮件通知类型
#SBATCH --mail-user=chenlin114514@sjtu.edu.cn # 邮件地址
#SBATCH --output=/home/lchen/home/gflownet-rl/log/%j.out
#SBATCH --error=/home/lchen/home/gflownet-rl/log/%j.err




# 加载 Conda 环境
source /home/lchen/miniconda3/etc/profile.d/conda.sh
conda activate gflownet-rl-raw

# 切换到项目目录
cd /home/lchen/home/gflownet-rl/bitseq

# 设置随机 MASTER_PORT 避免端口冲突
export WANDB_API_KEY="2e3f0cdfb6089a1e52ee117856ca6dfcf331858b"
export MASTER_PORT=$((20000 + RANDOM % 10000))



# methods=("db" "tb" "subtb")
# alphas=(0.2 0.3 0.4 0.45 0.5 0.55 0.6 0.7 0.8 0.9)
# ks=(1 2 4 6)
# seeds=(1 2 3 4)

# # 计算索引
# method_idx=$(( SLURM_ARRAY_TASK_ID / 160 ))
# alpha_idx=$(( (SLURM_ARRAY_TASK_ID % 160) / 16 ))
# k_idx=$(( (SLURM_ARRAY_TASK_ID % 16) / 4 ))
# seed_idx=$(( SLURM_ARRAY_TASK_ID % 4 ))

# method=${methods[$method_idx]}
# alpha=${alphas[$alpha_idx]}
# k=${ks[$k_idx]}
# seed=${seeds[$seed_idx]}

# echo "Running with method=${method}, alpha=${alpha}, k=${k}, seed=${seed}"

# cmd="python run.py --objective ${method} --k ${k} --learning_rate 0.002 --alpha ${alpha} --seed ${seed}"

# if [ "$method" == "subtb" ]; then
#     cmd="${cmd} --subtb_lambda 1.9"
# fi

# echo "Executing command: ${cmd}"
# $cmd


# 91297 90753 fix requeued tasks 测试单卡多任务的速度
python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0 &
python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.2 --seed 0 &
python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.2 --seed 0 &
python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0 &
python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.3 --seed 0 &
python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.3 --seed 0 &
python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0 &
python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.3 --seed 0 &

python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.3 --seed 0 &
python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0 &
python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.55 --seed 0 &
python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0 &
python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0 &
python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.9 --seed 0 &
python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.9 --seed 0 &
python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0 &
wait




# RTX4090 83860
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# RTX4090 83862
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# RTX4090 83864
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0

# rerun experiments with seed=1
# RTX4090 83867
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.5 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.5 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.2 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.2 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.3 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.3 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 1

# RTX4090 83869
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.4 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.4 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.45 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.45 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.55 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.55 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 1

# RTX4090 83870
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.6 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.6 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.7 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.7 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.8 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.8 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 1

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.9 --seed 1
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.9 --seed 1
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 1

# rerun experiments with seed=2
# RTX4090 83871
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.5 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.5 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.2 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.2 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.3 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.3 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 2

# RTX4090 83872
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.4 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.4 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.45 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.45 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.55 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.55 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 2

# RTX4090 83873
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.6 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.6 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.7 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.7 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.8 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.8 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 2

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.9 --seed 2
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.9 --seed 2
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 2

# rerun experiments with seed=3
# RTX4090 85042
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.5 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.5 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.2 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.2 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.3 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.3 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 3

# RTX4090 85044
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.4 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.4 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.45 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.45 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.55 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.55 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 3

# RTX4090 85046
# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.6 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.6 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.7 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.7 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.8 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.8 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 3

# python run.py --objective tb --k 8 --learning_rate 0.002 --alpha 0.9 --seed 3
# python run.py --objective db --k 8 --learning_rate 0.002 --alpha 0.9 --seed 3
# python run.py --objective subtb --k 8 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 3



# 88743
# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# 88744
# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# 88745
# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0

# python run.py --objective tb --k 1 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 1 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 1 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0

# 88746
# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.5 --seed 0 # done
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.5 --seed 0 # done
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0 # not done,deleted

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# 88747
# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# 88748
# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0

# python run.py --objective tb --k 2 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 2 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 2 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0

# 88749
# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# 88750
# python run.py --objective tb --k  --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# 88751
# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective subtb --k 4 --learning4_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0

# python run.py --objective tb --k 4 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 4 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 4 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0 # not done

# 88752
# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.5 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.5 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.2 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.2 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.3 --seed 0 # not done，deleted
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# 88753
# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.4 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.4 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.45 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.45 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.55 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.55 --seed 0 # not done,deleted
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# 88754
# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.6 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.6 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.7 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.7 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0 # done

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.8 --seed 0 # done
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.8 --seed 0 # done
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0 # not done,deleted

# python run.py --objective tb --k 6 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 6 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 6 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0

# 88755
# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.5 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.5 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.2 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.2 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.3 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.3 --seed 0

# 88756
# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.4 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.4 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.45 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.45 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.55 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.55 --seed 0

# 88757
# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.6 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.6 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.7 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.7 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.8 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.8 --seed 0

# python run.py --objective tb --k 10 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective db --k 10 --learning_rate 0.002 --alpha 0.9 --seed 0
# python run.py --objective subtb --k 10 --learning_rate 0.002 --subtb_lambda 1.9 --alpha 0.9 --seed 0

# # 89485 for k=10
# methods=("db" "tb" "subtb")
# alphas=(0.2 0.3 0.4 0.45 0.5 0.55 0.6 0.7 0.8 0.9)
# seeds=(1 2 3 4)

# method_idx=$(( SLURM_ARRAY_TASK_ID / 40 ))
# alpha_idx=$(( (SLURM_ARRAY_TASK_ID % 40) / 4 ))
# seed_idx=$(( SLURM_ARRAY_TASK_ID % 4 ))

# method=${methods[$method_idx]}
# alpha=${alphas[$alpha_idx]}
# seed=${seeds[$seed_idx]}

# echo "Running with method=${method}, alpha=${alpha}, seed=${seed}"

# cmd="python run.py --objective ${method} --k 10 --learning_rate 0.002 --alpha ${alpha} --seed ${seed}"

# if [ "$method" == "subtb" ]; then
#     cmd="${cmd} --subtb_lambda 1.9"
# fi

# echo "Executing command: ${cmd}"
# $cmd

# 89490 for k=8
# methods=("db" "tb" "subtb")
# alphas=(0.2 0.3 0.4 0.45 0.5 0.55 0.6 0.7 0.8 0.9)

# method_idx=$(( SLURM_ARRAY_TASK_ID / 10 ))
# alpha_idx=$(( SLURM_ARRAY_TASK_ID % 10 ))

# method=${methods[$method_idx]}
# alpha=${alphas[$alpha_idx]}
# k=8
# seed=4

# echo "Running with method=${method}, alpha=${alpha}, k=${k}, seed=${seed}"

# cmd="python run.py --objective ${method} --k ${k} --learning_rate 0.002 --alpha ${alpha} --seed ${seed}"

# if [ "$method" == "subtb" ]; then
#     cmd="${cmd} --subtb_lambda 1.9"
# fi

# echo "Executing command: ${cmd}"
# $cmd