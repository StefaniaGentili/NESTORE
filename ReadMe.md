![logo](NESTORE_logo.png)
#  NESTORE PACKAGE README [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.7472134.svg)](https://zenodo.org/badge/doi/10.5281/zenodo.7472134.svg)
MATLAB package able to forecast strong aftershocks starting from the first hours after the mainshocks

##  Software Description 

NESTORE is a MATLAB package capable to estimate, during 
ongoing of an aftershock sequence following a damaging
earthquake, the likelihood of the occurrence of another strong 
earthquake.

The code is based on the seismicity characteristics and uses a
machine learning approach to provide forecasting for the 
ongoing seismic sequence. 

Starting from an input catalogue, the package
1. Provides an identification of clusters by a window based 
   method (Cluster Identification Module)
2. Trains the algorithm by machine learning on cluster's 
   features (Training Module)
3. Tests the algorithm performances (Testing Module)
4. Classifies in near-real-time new clusters (Near-Real-Time 
   Classification Module) 

For further details see the paper: 
NESTOREv1.0: A Matlab package to identify patterns for strong 
following earthquake forecasting
S. Gentili, P. Brondi, R. Di Giovambattista



##  Installation 

Download NESTOREv1.0.zip and extract in a folder you prefer
(e.g. NESTORE_FOLDER)or clone NESTORE repository on your 
computer; no other action is required. 
NESTORE has been tested on Matlab R2018a and later versions. 


##   Usage

To run NESTORE code start MATLAB, move in your sub-directory 
NESTOREv1.0/user(e.g. NESTORE_FOLDER/NESTOREv1.0/user); in the 
MATLAB command line, type the corresponding run you need (e.g. 
run_training); examples are provided. See Folder_struc.txt 
and Fileinput_format.txt for further details.


##  Software Support 

This package is the first online version of NESTORE, so any 
suggestions or bug reporting are welcome. 
Please contact sgentili@ogs.it


##  Credits

Please use the following citation for any use of this software: 
Stefania Gentili, Piero Brondi, Rita Di Giovambattista; 
NESTOREv1.0: A MATLAB Package for Strong Forthcoming Earthquake Forecasting. 
Seismological Research Letters 2023; doi: https://doi.org/10.1785/0220220327

##  References
* Gentili, S., and R. Di Giovambattista (2017). Pattern recognition
approach to the subsequent event of damaging earthquakes in
Italy, Phys. Earth Planet. In. 266, 1–17.

* Gentili, S., and R. Di Giovambattista (2020). Forecasting strong aftershocks
in earthquake clusters from northeastern Italy and western
Slovenia, Phys. Earth Planet. In. 303, doi: 10.1016/j.pepi.2020.106483.

* Gentili, S., and R. Di Giovambattista (2022). Forecasting strong subsequent
earthquakes in California clusters by machine learning,
Phys. Earth Planet. In. 327, doi: 10.1016/j.pepi.2022.106879.

* Gentili, S., E. Anyfadi, P. Brondi, and F. Vallianatos (2023).
Forecasting strong subsequent earthquakes in Greece using
NESTORE machine learning algorithm, EGU General Assembly
2023, Vienna, Austria, 23–28 April 2023.


##  Acknowledgments

The NESTORE software improvement for making it more robust and 
for distributing to the scientific community has been funded 
by a grant from the Italian Ministry of Foreign Affairs and 
International Cooperation.


##  License

GNU General Public License as published by the Free Software 
Foundation; version 3 of the License or any later version.
