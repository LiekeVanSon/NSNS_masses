import h5py
import numpy as np
import os
import shutil

from astropy.table import vstack, Table
from astropy import units as u
from astropy import constants as const

#Plotting parameters
import matplotlib
from matplotlib import rc
from matplotlib import gridspec
from matplotlib.legend import Legend
import matplotlib.pyplot as plt


types = Table()
types['stellar_types'] = ['MS_low', 'MS' ,'HG', 'AGB', 'CHeB', 'EAGB','TPAGB','HeMS','HeHG','HeGB','HeWD','COWD','ONeWD','NS','BH','massless remnant']
types['indices'] = np.arange(len(types))
tik = ['- -','- A','- B','- C','A -','A A','A B','A C','B -','B A','B B','B C','C -','C A','C B','C C']

# For when COMPAS changes names again
stellar_type1, stellar_type2 = 'Stellar_Type(1)', 'Stellar_Type(2)'
mass_1, mass_2               = 'Mass(1)', 'Mass(2)'
Separation                   = 'SemiMajorAxis'

UnitDict = {
    "-": None,
    "Rsol": u.Rsun,
    "Msol": u.Msun,
    "Myr": u.Myr,
    "Myr\n": u.Myr,
    "yr^-1": u.yr**-1,
    "Tesla": u.Tesla,
    "rad/s": u.rad * u.s**-1,
    "rad/s^2": u.rad * u.s**-2,
    "Lsol": u.Lsun,
    "K": u.K,
    "Msol*AU^2*yr^-1": u.Msun*u.AU**2 *u.yr**-1,
    "Msol*AU^2*yr^-2": u.Msun*u.AU**2 *u.yr**-2,
    "Hz":u.Hz,
}


def Kepler3(a,m1,m2):
    #Separations to periods
    return np.sqrt((4 *np.pi**2 * a**3)*(const.G *(m1 + m2))**-1)

def Kepler3table(table,sep_arg='separationPrior2ndSN',\
                 massarg1='totalMassDCOFormation1',massarg2='totalMassDCOFormation1', periodarg ='PeriodPrior2ndSN'):
    #Separations to periods
    # display(table['separationPrior2ndSN'])
    a = table[sep_arg]#*u.Rsun
    m1, m2 = table[massarg1] ,table[massarg2] #*u.Msun
    periods = np.sqrt((4 *np.pi**2 * a.to(u.m)**3)*(const.G *(m1.to(u.kg) + m2.to(u.kg)))**-1)
    table[periodarg] = periods.to(u.day)
    return table

def add_units(table, loc = ''):

    file = open(loc, "r")
    for i, line in enumerate(file):
        if i == 1: 
            unit_list = np.array(line.split(','))
            break
    units = [x.replace(" ", "") for x in unit_list]
    #print(np.unique(units))
    for i, key in enumerate(table.columns):
        table[key].unit = UnitDict[units[i]]
    return table


######################################
def plot_detail(input_dir_detailed,
                second_axis = 'SemiMajorAxis', second_axis2 = None, log_second_axis = False, 
                xlim=(None,None), secon_axisYlim = (None,None), share_y = False,
                save_plot = False):

    ###################
    # Open table and read units
    print('looking in ', input_dir_detailed)
    try:
        detail = Table.read(input_dir_detailed, header_start=2,data_start=3, format='csv', delimiter = ',')
        detail = add_units(detail, loc = input_dir_detailed)
    except:
        print('are you using an hdf5 table?')
        detail     = Table()
        detailh5   = h5py.File(input_dir_detailed,'r')
        for key in list(detailh5.keys()):
            detail[key]      =  detailh5[key]            

        detail['Teff1']                     = detailh5['SemiMajorAxis'][()]
        detailh5.close()

    ###################
    ##### Find points where the star changes Type
    #Boolean array of when star 1 changes type
    type_change        = np.zeros(len(detail))
    type_change[1:]    = detail[stellar_type1][1:] - detail[stellar_type1][:-1] > 0
    type_change_index1 = list(np.arange(len(detail))[type_change == 1])
    #Boolean array of when star 2 changes type
    type_change        = np.zeros(len(detail))
    type_change[1:]    = detail[stellar_type2][1:] - detail[stellar_type2][:-1] > 0
    type_change_index2 = list(np.arange(len(detail))[type_change == 1])

    try:
        #Get periods
        detail             = Kepler3table(detail,sep_arg=Separation,massarg1=mass_1,massarg2=mass_2, periodarg ='period')
    except:
        print('kepler failed, you probably miss units')
    
    
    ###################
    # Start plotting
    fig, ax = plt.subplots(figsize=(10,7.5))
    ax2     = ax.twinx()
    if share_y:
        ax.get_shared_y_axes().join(ax, ax2)

    ### ax 1###
    ax.plot(detail['Time'], detail[mass_1], label = 'M1', c = 'red',\
            linestyle = '--', marker = 'o',  markevery = type_change_index1 , ms = 10)
    for i in type_change_index1:
        ax.annotate(types['stellar_types'][detail[stellar_type1][i]],(detail['Time'][i]+0.05, detail[mass_1][i] + 0.5), size = 15 , color = 'red')
    ##    
    ax.plot(detail['Time'], detail[mass_2], label = 'M2', c = 'blue',\
            linestyle = '--', marker = 'o',  markevery = type_change_index2 ,ms = 10)
    for i in type_change_index2:
        ax.annotate(types['stellar_types'][detail[stellar_type2][i]],(detail['Time'][i]+0.05, detail[mass_2][i] + 0.5), size = 15 , color = 'blue')
    ##    
    ax.set_xlabel('Time [Myr]', size = 25)
    ax.set_ylabel('Mass Msun', size = 25)
    ax.legend(loc = 'upper left', fontsize = 20)
    ax.tick_params(axis='both', which='major', labelsize=25)
    

    ### ax 2 ### massTransferTracker
    y_second_ax = detail[second_axis]
    if log_second_axis:
        y_second_ax = np.log10(abs(y_second_ax))
    ax2.scatter(detail['Time'],y_second_ax , label = second_axis, c = 'orange')#Stellar_Type_1
    ax2.set_ylabel(second_axis +' '+ str(detail[second_axis].unit), size = 25, color = 'orange')
    if second_axis2 != None:
        ax2.scatter(detail['Time'], detail[second_axis2], label = second_axis2, c = 'green')#Stellar_Type_1

        
    # Plot values
    ax2.legend(fontsize = 20, loc = 'lower left')
    ax2.tick_params(axis='both', which='major', labelsize=25, color = 'orange')

    if secon_axisYlim[0] != None:
        ax2.set_ylim(secon_axisYlim[0],secon_axisYlim[1])

    if xlim[0] != None:
        ax.set_xlim(xlim)
        ax2.set_xlim(xlim)   
        
    if save_plot:
        plt.savefig('/'+input_dir_detailed[:-26] +'/Detail_'+second_axis +'.png', bbox_inches='tight')
        
    plt.show()

    return detail