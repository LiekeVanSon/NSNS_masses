##################################################
# Created 18 November 2020
# Lieke van son
# This folder contains the scripts that are needed
# to do the cosmic integration
#################################################


#################################################
##			Step 3 CosmicIntegration		   ##
#################################################

This folder contains:

# # # # # # # # # # # # # # # 
3.1) FastCosmicIntegration.py:
	This is Tom's cleaned up version of Ilya's cosmic integration code

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!!!!!! Make sure you check the flags set in this file !!!!!!!

	 Do all the default constants match what you set in stroopwafel_interface.py & pythonSubmit.py?

	# Constants must match you COMPAS settings!
	M1_min=10
	M1_max=150
	M2_min=0.1

	# What would you like to compute for cosmic integration?
	Fbin=0.7
	Max_redshift=10.0
	Max_redshift_detection=1.0
	Redshift_step=0.001
	Sensitivity="O3"
	Snr_threshold=8
	Dco_type="BHBH"


# # # # # # # # # # # # # # # 
3.2) ClassCOMPAS.py:
	This class is needed for FastCosmicIntegration.py
	 (You don't have to set anything here)


# # # # # # # # # # # # # # # 
3.3) selection_effects.py :

    Returns the detection probability of a CBC event with given
    masses and distance.

    This function is a convenience function to generate the
    interpolator with 'SNR_Grid_IMRPhenomPv2_FD_all_noise.hdf5'
    and 'SimNoisePSDaLIGODesignSensitivityP1200087', redshift the
    masses, rescale the SNR using the distance, and then call
    'detection_probability_from_snr' to return the probability.

	 (You don't have to set anything here)


# # # # # # # # # # # # # # # 
3.4) SNR_Grid_IMRPhenomPv2_FD_all_noise.hdf5 :

	Lookup SNR grid from LIGO/Virgo
	 (You don't have to set anything here)


# # # # # # # # # # # # # # # 
3.5) ComputeCIweights.py (DEPRICATED):
This uses Coen Neijssels cosmic integration scripts (in $COMPAS_ROOT_DIR/postProcessing/Folders/CosmicIntegration/) to do the same calculations. It only works for discrete metallicity samples (because it contains loops over unique metallicities) BUT it has many more options for the SFR, mass-metallicity and metallicity densitty dsitributions.

 (You don't have to set anything here)

