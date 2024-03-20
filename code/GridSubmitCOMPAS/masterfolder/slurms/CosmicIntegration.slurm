#!/bin/bash
#SBATCH --job-name=CosmicIntegration
#SBATCH --output=CosmicIntegration%j.out
#SBATCH --error=CosmicIntegration%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=aac.van.son@gmail.com
#SBATCH --partition=cca
#SBATCH --time=0-12:00:00


#Set data directories
root_script_dir=/mnt/home/lvanson/NSNS_masses/code/GridSubmitCOMPAS/masterfolder/
data_dir=/mnt/ceph/users/lvanson/CompasOutput/v02.35.02/N1e7_Fiducial_AllDCO_AIS/

# check if CosmicIntegration folder exists, and copy scripts to output directory
mkdir -p $data_dir/CosmicIntegration/
cp $root_script_dir/CosmicIntegration/* $data_dir/CosmicIntegration/

#CD to the root directory
cd $data_dir/CosmicIntegration/

# Activate the python virtual environment
source /mnt/home/lvanson/venvs/Jupyter_venv/bin/activate

# Call the Cosmic Integration script with the input parameters and flags (dco_type = ["all", "BBH", "BHNS", "BNS"])
python -u FastCosmicIntegration.py --path $data_dir/MainRun/ --filename COMPAS_Output_wWeights.h5 --outfname $data_dir/CosmicIntegration/Rate_info.h5 --weight mixture_weight --zstep 0.01 --sens O3 --m1min 5. --dco_type all --BinAppend --redshiftBinSize 0.1 --maxzdet 10 --mu0 0.025 --muz -0.049 --sigma0 1.129 --sigmaz 0.048 --alpha -1.79 --aSF 0.017 --bSF 1.487 --cSF 4.442 --dSF 5.886 &> CosmicIntegration.log 

# # # Srun commands in parallel
# srun -n 1 -c 1 python -u FastCosmicIntegration.py --path $data_dir/MainRun/ --filename COMPAS_Output_wWeights.h5 --outfname $data_dir/CosmicIntegration/Rate_info_NSNS.h5 --weight mixture_weight --zstep 0.01 --sens O3 --m1min 5. --dco_type BNS --BinAppend --redshiftBinSize 0.1 --maxzdet 10 --mu0 0.025 --muz -0.049 --sigma0 1.129 --sigmaz 0.048 --alpha -1.79 --aSF 0.017 --bSF 1.487 --cSF 4.442 --dSF 5.886 &> CosmicIntegration_NSNS.log 
# srun -n 1 -c 1 python -u FastCosmicIntegration.py --path $data_dir/MainRun/ --filename COMPAS_Output_wWeights.h5 --outfname $data_dir/CosmicIntegration/Rate_info_BHNS.h5 --weight mixture_weight --zstep 0.01 --sens O3 --m1min 5. --dco_type BHNS --BinAppend --redshiftBinSize 0.1 --maxzdet 10 --mu0 0.025 --muz -0.049 --sigma0 1.129 --sigmaz 0.048 --alpha -1.79 --aSF 0.017 --bSF 1.487 --cSF 4.442 --dSF 5.886 &> CosmicIntegration_BHNS.log 
# srun -n 1 -c 1 python -u FastCosmicIntegration.py --path $data_dir/MainRun/ --filename COMPAS_Output_wWeights.h5 --outfname $data_dir/CosmicIntegration/Rate_info_BBH.h5 --weight mixture_weight --zstep 0.01 --sens O3 --m1min 5. --dco_type BBH --BinAppend --redshiftBinSize 0.1 --maxzdet 10 --mu0 0.025 --muz -0.049 --sigma0 1.129 --sigmaz 0.048 --alpha -1.79 --aSF 0.017 --bSF 1.487 --cSF 4.442 --dSF 5.886 &> CosmicIntegration_BBH.log 