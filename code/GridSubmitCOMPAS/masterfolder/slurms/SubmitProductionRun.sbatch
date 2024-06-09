#!/bin/bash

# Step 1: Change output dirs in stroopwafel_interface_Lieke.py, COMPAS_r.sbatch, COMPAS_PP.sbatch, and CosmicIntegration.slurm
new_dir="/mnt/ceph/users/lvanson/CompasOutput/v02.35.02/N1e7_CEa05_AllDCO_AIS/"
sed -i "s|output_folder = .*|output_folder = '$new_dir/MainRun/'|g" ../MainRun/stroopwafel_interface_Lieke.py
sed -i "s|data_dir=.*|data_dir='$new_dir'|g" COMPAS_r.sbatch
sed -i "s|data_dir=.*|data_dir='$new_dir'|g" COMPAS_PP.sbatch
sed -i "s|data_dir=.*|data_dir='$new_dir'|g" CosmicIntegration.slurm


# Step 2: Submit COMPAS_r.sbatch (Stroopwafel run) and get the PID of the submitted job
pid=$(sbatch --parsable COMPAS_r.sbatch)

# Step 3: Submit COMPAS_PP.sbatch (postprocessing) after the completed run
pid_pp=$(sbatch --parsable --dependency=afterok:$pid COMPAS_PP.sbatch --kill-on-invalid-dep=yes) #kill on invalid dep makes sure your job doesnt get stranded

# Step 4: Submit CosmicIntegration after postprocessing completed
sbatch --dependency=afterok:$pid_pp CosmicIntegration.slurm --kill-on-invalid-dep=yes
