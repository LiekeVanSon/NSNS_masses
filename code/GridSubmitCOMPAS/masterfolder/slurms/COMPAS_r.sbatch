#!/bin/bash
#SBATCH --job-name=COMPAS_r                 #job name
#SBATCH --ntasks=25                         # Number of cores (this should match what stroopwafel_interface_Lieke.py wants to use +1)
#SBATCH --output=SW.out                     # output storage file
#SBATCH --error=SW.err                      # error storage file
#SBATCH --time=1-00:00:00                   # Runtime format: D-HH:MM:SS use 1-00:00:00  for N1e7 sim
#SBATCH -p cca                              # Partitions
#SBATCH --mail-user=aac.van.son@gmail.com   # Send email 
#SBATCH --mail-type=FAIL                    # Only if failed

#Print some stuff on screen
echo $SLURM_JOB_ID
echo $SLURM_JOB_NAME
echo $SLURM_ARRAY_TASK_ID

#Set variables
export QT_QPA_PLATFORM=offscreen # To avoid the X Display error

#Set data directories
root_script_dir=/mnt/home/lvanson/NSNS_masses/code/GridSubmitCOMPAS/masterfolder/
data_dir='/mnt/ceph/users/lvanson/CompasOutput/v02.35.02/N1e6_Fiducial_BHNS_AIS/'

#Load modules
module load gsl boost hdf5 gcc python

#CD to the root directory
cd $root_script_dir/MainRun/

# Run your job
python stroopwafel_interface_Lieke.py   > SW.log

# copy the scripts you used for your run to the output directory
cp $root_script_dir/MainRun/* $data_dir/MainRun/
cp COMPAS_r.sbatch $data_dir/MainRun/
