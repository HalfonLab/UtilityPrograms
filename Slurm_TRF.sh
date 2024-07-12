#!/bin/bash -l

### Note: the path to the proper Genome file needs to be provided on the command line when running this script! ###

#SBATCH --partition=general-compute
#SBATCH --qos=general-compute
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1


#SBATCH --output="output_TRF.txt"
#SBATCH --mail-user=
#SBATCH --mail-type=ALL


ulimit -s unlimited

echo $0 $@
echo " "
echo "SLURM_JOB_ID="$SLURM_JOB_ID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURM_NPROCS"=$SLURM_NPROCS
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "SLURM_SUBMIT_DIR="$SLURM_SUBMIT_DIR

if [ "$#" -ne 1 ]; then
  echo "Missing Genome file on command line"
fi 


genome_file=$1

#run TRF
/projects/academic/mshalfon/Scripts/trf409.linux64 $genome_file 2 7 7 80 10 50 500 -m -h




echo "All Done!"
