#!/bin/bash
#SBATCH --job-name=COMPAS_r               #job name
#SBATCH --nodes=1                  # Number of nodes
#SBATCH --ntasks=1                 # Number of cores
#SBATCH --output=COMPAS_r.out                 # output storage file
#SBATCH --error=COMPAS_r.err                  # error storage file
#SBATCH --time=01:00:00                   # Runtime in minutes
#SBATCH --mem=1000                    # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH -p gen, cca
#SBATCH --mail-user=aac.van.son@gmail.com              # Send email to user
#SBATCH --mail-type=FAIL            #

#Print some stuff on screen
echo $SLURM_JOB_ID
echo $SLURM_JOB_NAME
echo $SLURM_ARRAY_TASK_ID

#Load modules
module load python

#Set variables
export QT_QPA_PLATFORM=offscreen # To avoid the X Display error

data_dir=/mnt/home/lvanson/ceph/CompasOutput/v02.41.06/test/

#CD to output directory
cd $data_dir
#
# Run your job
python runSubmit.py   > COMPAS_r.log
