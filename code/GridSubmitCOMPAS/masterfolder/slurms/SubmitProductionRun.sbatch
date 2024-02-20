#!/bin/bash

# Step 1: Change output dirs in stroopwafel_interface_Lieke.py, COMPAS_r.sbatch, and COMPAS_PP.sbatch
new_dir="/mnt/ceph/users/lvanson/CompasOutput/v02.41.06/N1e6_Fiducial_NSNS/"
sed -i "s|output_folder = .*|output_folder = '$new_dir/MainRun/'|g" ../MainRun/stroopwafel_interface_Lieke.py
sed -i "s|data_dir=.*|data_dir='$new_dir'|g" COMPAS_r.sbatch
sed -i "s|data_dir=.*|data_dir='$new_dir'|g" COMPAS_PP.sbatch

# Step 2: Submit COMPAS_r.sbatch and get the PID of the submitted job
pid=$(sbatch --parsable COMPAS_r.sbatch)

# Step 3: Submit COMPAS_PP.sbatch after COMPAS_r.sbatch
sbatch --dependency=afterok:$pid COMPAS_PP.sbatch
