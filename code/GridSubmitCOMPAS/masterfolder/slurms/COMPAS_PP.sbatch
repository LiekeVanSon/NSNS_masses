#!/bin/bash
#SBATCH --job-name=COMPAS_PP                #job name
#SBATCH --ntasks=1                          # Number of cores
#SBATCH --output=COMPAS_PP%j.out              # output storage file
#SBATCH --time=0-4:00:00                    # use 0-4:00:00 for N1e7 sim
#SBATCH -p cca                              # Partitions
#SBATCH --mail-user=aac.van.son@gmail.com   # Send email to user
#SBATCH --mail-type=FAIL                    # Only if failed

#Print some stuff on screen
echo $SLURM_JOB_ID
echo $SLURM_JOB_NAME
echo $SLURM_ARRAY_TASK_ID

#Set variables
export QT_QPA_PLATFORM=offscreen # To avoid the X Display error

#Load modules
module load modules/2.1.1 # COMPAS was set with older version of modules (updated on rusty)
module load python

#Set data directories
root_script_dir=/mnt/home/lvanson/NSNS_masses/code/GridSubmitCOMPAS/masterfolder/
data_dir='/mnt/ceph/users/lvanson/CompasOutput/v02.46.01/N1e5_Fid_WDWD_AIS/'

# Make postProcessing directory and copy scripts
mkdir -p $data_dir/postProcessing

cp $root_script_dir/postProcessing/h5copy.py         $data_dir/postProcessing/
cp $root_script_dir/postProcessing/append_weights.py $data_dir/postProcessing/

#CD to output directory
cd $data_dir/postProcessing/

# Combine the COMPAS batches into one file COMPAS_Output
python h5copy.py  $data_dir/MainRun/ -r 2 -o $data_dir/MainRun/COMPAS_Output.h5 > COMPAS_PP.log

#Run append weight
python append_weights.py  &> $data_dir/postProcessing/append_weights.log

