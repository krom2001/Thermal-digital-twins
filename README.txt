This repository contains all the work completed for the Thermal Digital Twins project by krom2001. 
The purpose of the code is to demonstrate the use of pre-processing methods and neural networks for 
predicting the radii of 5 cylindrical conducting beam elements from temperature data recorded at 
nodes on the ends of the elements when a heat load is applied to the beam. The code does this by 
feeding the results of a 'score'-based pre-processing method or a PCA-based pre-processing method
into Feed Forward Neural Networks after the pre-processing methods are applied to some temperature
data from a target beam. The neural networks identify the differences in radii between individual 
beam elements, and the minimal radius of the beam elements. These results are then used to calculate
the predicted radii of the elements. Another use of the code in this repository is to predict future
temperatures at the nodes on the beam using past temperature data from a target beam. These predictions
are used to activate warnings of the temperature is forecast to exceed a certain threshold.

The structure, purpose and functionality of the folders and files in this repository are described below:

5_seg_beam_csv/		=> Contains files with the temperature data for 7776 beams with different
			   combinations of beam element radii. The radii of the 5 beam elements come in
			   increments of 10mm, between 10mm and 60mm. Hence 6^5 = 7776 possible combinations.

5_seg_beam_csv_v2/      => Similarly to '5_seg_beam_csv/' this files contains the temperature data 
			   for 7776 beams with element radii in 10mm increments between 10mm and 60mm.
	  		   However, this temperature data is generated using a different temperature model
			   with a different frequency of temperature variations.

extra_data/		=> Contains files with the temperature data for 11 extra beams with random beam
			   element radii. The radii do not come in increments of 10mm and can take any
			   any value. The radii are also no longer limited to a maximum of 60mm. This
			   data is useful for testing the robustness of the code.

save_net/		=> A file for storing any large .mat files containing processed data or trained 
			   neural networks. All code for training neural networks automatically saves the 
			   trained neural network to this location.





