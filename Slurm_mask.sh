#!/bin/bash -l
#SBATCH --partition=general-compute --qos=supporters
#SBATCH --time=36:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1

#SBATCH --output="output_bimp.txt"
#SBATCH --mail-user=hasibaas@buffalo.edu
#SBATCH --mail-type=ALL

ulimit -s unlimited

echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURM_NPROCS"=$SLURM_NPROCS
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "SLURM_SUBMIT_DIR="$SLURM_SUBMIT_DIR



/projects/academic/mshalfon/supl_scripts/tandem_repeat_mask/trf409.linux64 GCF_000188095.3_BIMP_2.2_genomic.fna  2 7 7 80 10 50 500 -m -h



echo "All Done!"
