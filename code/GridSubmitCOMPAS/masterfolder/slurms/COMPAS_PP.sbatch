#!/bin/bash
#SBATCH --job-name=COMPAS_PP                #job name
#SBATCH --nodes=1                           # Number of nodes
#SBATCH --ntasks=1                          # Number of cores
#SBATCH --output=COMPAS_PP.out              # output storage file
#SBATCH --error=COMPAS_PP.err               # error storage file
#SBATCH --time=1:00:00                      # Runtime in minutes
#SBATCH --mem=2G                            # use 2 GB of Memory per cpu 
#SBATCH -p cca,gen,genx                     # Partitions
#SBATCH --mail-user=aac.van.son@gmail.com   # Send email to user
#SBATCH --mail-type=FAIL                    # Only if failed

#Print some stuff on screen
echo $SLURM_JOB_ID
echo $SLURM_JOB_NAME
echo $SLURM_ARRAY_TASK_ID

#Set variables
export QT_QPA_PLATFORM=offscreen # To avoid the X Display error

#Load modules
module load python

#Set data directories
root_script_dir=/mnt/home/lvanson/NSNS_masses/code/GridSubmitCOMPAS/masterfolder/
data_dir='/mnt/ceph/users/lvanson/CompasOutput/v02.41.06/N1e7_Fiducial_NSNS/'

# Make postProcessing directory and copy scripts
mkdir -p $data_dir/postProcessing

cp $root_script_dir/postProcessing/h5copy.py         $data_dir/postProcessing/
cp $root_script_dir/postProcessing/append_weights.py $data_dir/postProcessing/

#CD to output directory
cd $data_dir/postProcessing/

# Combine the COMPAS batches into one file COMPAS_Output
python h5copy.py  $data_dir/MainRun/ -r 2 -o $data_dir/MainRun/COMPAS_Output.h5 > COMPAS_PP.log


#Run append weight
python append_weights.py  > $data_dir/postProcessing/append_weights.log

# copy the slurm you used for your run to the output directory
cp $root_script_dir/slurms/COMPAS_PP.sbatch $data_dir/postProcessing/
mv $root_script_dir/slurms/COMPAS_PP.err $data_dir/postProcessing/
mv $root_script_dir/slurms/COMPAS_PP.out $data_dir/postProcessing/