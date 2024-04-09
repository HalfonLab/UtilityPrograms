#!/bin/bash -l
#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=48000

#SBATCH --output="output_postProcRun1.txt"
#SBATCH --mail-user=
#SBATCH --mail-type=ALL

module load foss
module load scipy-bundle
module load pybedtools/0.8.0 
module load MACS2

ulimit -s unlimited

echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURM_NPROCS"=$SLURM_NPROCS
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "SLURM_SUBMIT_DIR="$SLURM_SUBMIT_DIR



python postProcessingScrmshawPipeline.py -num 5000 -topN Median -so scrmshawOutput_offset_0to240.bed 



echo "All Done!"
