#!/bin/bash -l
#SBATCH --partition=general-compute --qos=supporters
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name="Slurm_scrmshawHd_"
#SBATCH --array=1-25
#SBATCH --mem=48000
#SBATCH --requeue



#SBATCH --output="outputScrmshawHD_.txt"
#SBATCH --mail-user=
#SBATCH --mail-type=ALL

module load gcc
module load bioperl
module load perl

ulimit -s unlimited

echo "SLURM_ARRAY_JOB_ID="$SLURM_JOB_ID
echo "SLURM_ARRAY_TASK_ID"=$SLURM_ARRAY_TASK_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURM_NPROCS"=$SLURM_NPROCS
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "SLURM_SUBMIT_DIR="$SLURM_SUBMIT_DIR

mytempNUM=`expr ${SLURM_ARRAY_TASK_ID} - 1 `
myNUM=`expr $mytempNUM \* 10 `
echo "myNUM="$myNUM

SLURM_TASK_DIR=${SLURM_SUBMIT_DIR}/task_offset_${myNUM}_${SLURM_ARRAY_TASK_ID}
echo "SLURM_TASK_DIR="$SLURM_TASK_DIR


EXE="perl ~project1/SCRMshaw_HD/code/scrm.pl"
ARGS="--thitw 5000 --gff project1/gene.gff3 \
--genome project1/genome.fa \
--traindirlst project1/trainingSet.lst --imm --hexmcd --pac --lb $myNUM --outdir $SLURM_TASK_DIR --step 123"

OUTFILE=Predictions_offset_${myNUM}_jobId_${SLURM_ARRAY_JOB_ID}_taskId_${SLURM_ARRAY_TASK_ID}.out

module list
ulimit -s unlimited

$EXE $ARGS > $OUTFILE 2>&1

echo "All Done!"
