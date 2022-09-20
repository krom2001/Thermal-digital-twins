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


*****


The structure, purpose and functionality of the folders and files in this repository are described below:



Folders:

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
			   neural networks for the '5_seg_beam_csv/' data set. All code for training 
			   neural networks automatically saves the trained neural network to this location.

save_net(v2)/		=> A file for storing any large .mat files containing processed data or trained 
			   neural networks for the '5_seg_beam_csv_v2/' data set. To run the code for this
			   data set or to allow the code to access this file change its name to save_net/.



Neural network training files:

effectiveRadiusNNtrainer.m	=> A file for training a neural network to identify the minimum element radius
				   of a target beam from its temperature data. Running this code saves the 
				   trained neural network to save_net/ automatically.

relativeRadiusNNtrainer.m 	=> A file for training neural networks to identify the differences in radius 
				   between pairs of beam elements and using the score-based pre-processing 
				   method. Running this code saves the trained neural network to save_net/ 
				   automatically.

PCA_relativeRadiusNNtrainer.m	=> Same as 'relativeRadiusNNtrainer.m' but this time using the PCA-based 
				   pre-processing method.

LSTM_trainer_stateReset.m	=> A file for training an LSTM neural network to predict future temperatures
				   using past temperature data. Running this code saves the trained neural 
				   network to save_net/ automatically.



Data formatting code:

fileReader.m		=> A function for converting .csv files with temperature data into a 'data.mat' file.
			   The function takes as an argument the name of the folder containing the .csv files
			   and saves the resultant data.mat file to save_net.

uniformCaseGenerator.m	=> Running this code, creates and saves the uniformcases.mat file to save_net. This file
			   contains the 'scores' of the elements of a beam with equal element radii. These are used
			   as reference scores in the code.



Utility functions:

percent.m		=> Calculates and outputs the element 'scores' of a set of temperature data. Takes as
			   arguments the data.mat file and the radii combination of the target beam.

numtocomb.m		=> A function for converting a file number (1-7776) for the set of available beams and
			   their temperature data into the combination of radii of the elements of the beam.
			   The following format is used by the function:
			   numtocomb(1234) = [1, 6, 5, 2, 4] ie: file number 1234 represent a beam with elements
			   of radii 10mm, 60mm, 50mm, 20mm and 40mm. 

combinationFinder.m	=> A function which takes as input a set of temperature readings from the 6 nodes on a beam
			   (any number of time steps), a threshold probability (a confidence level below which a 
			   neural network output is considered invalid), and the necessary neural network files.
			   The function calculates possible predictions of the target beams element radii and outputs
			   them with a confidence level. The output comes in the same format as the output of the 
			   numtocomb.m function.

combinationFinderPCA.m	=> Same as 'combinationFinder.m' but designed for the PCA-pre-processing method.



Code for evalauting algorithm performance:

MAIN.m				=> A demonstration of how to use the 'combinationFinder.m' function for a given
				   temperature data file.

PCAMAIN.m			=> A demonstration of how to use the 'combinationFinderPCA.m' function for a given
				   temperature data file.

MAIN2.m				=> A demonstration of how to use the 'combinationFinder.m' function for a range of
				   temperature data files and recording how many radii combinations are correctly
				   predicted.

PCAMAIN2.m			=> A demonstration of how to use the 'combinationFinderPCA.m' function for a range of
				   temperature data files and recording how many radii combinations are correctly
				   predicted.

performanceNoiseLevels.m	=> A file used to measure and plot a graph how many radii combinations out of 7776
				   are correctly predicted by the score-based algorithm when different levels of 
				   brownian noise are applied to the temperature data. 

PCAperformanceNoiseLevels.m	=> A file used to measure and plot a graph how many radii combinations out of 7776
				   are correctly predicted by the PCA-based algorithm when different levels of 
				   brownian noise are applied to the temperature data. 

noiseAnalysis.m			=> A file used to calculate how many differences between element radii are correctly
				   predicted (out of 7776) by the 4 feed forward neural networks trained to use the
				   score-based pre-processing method. This is evaluated for different levels of
				   Brownian noise. The average magnitude of the noise applied is stored in 'overallnoise'
				   and the number of correctly identified radii differences for the respective noise
				   levels for each 4 neural networks is stored in 'results'.

PCAnoiseAnalysis.m		=> A file used to calculate how many differences between element radii are correctly
				   predicted (out of 7776) by the 4 feed forward neural networks trained to use the
				   PCA-based pre-processing method. This is evaluated for different levels of
				   Brownian noise. The average magnitude of the noise applied is stored in 'overallnoise'
				   and the number of correctly identified radii differences for the respective noise
				   levels for each 4 neural networks is stored in 'results'.

absnetnoiseAnalysis.m		=> A file used to calculate how many minimum element radii are correctly
				   predicted (out of 7776) by the 'absnet.mat' neural network. This is evaluated for
				   different levels of Brownian noise. The average magnitude of the noise applied 
				   is stored in 'overallnoise' and the number of correctly identified minimum radii 
				   for the respective noise levels is stored in 'results'.

LSTM_trainer_stateReset.m	=> Along with training the LSTM neural network for temperature prediction, this file
				   also plots the temperature predictions and displays warnings if the temperature 
				   exceeds a threshold. The code has 3 levels of warning for a predicted exceeding
				   of the threshold in 100, 200 and 300 time steps. If the temperature is predicted 
				   to exceed the threshold, the time step at which this event is predicted is marked 
				   on the temperature plot.

LSTM_stateReset_RMSE.m		=> A file for generating a histogram of prediction errors for the LSTM temperature
				   prediction code. The root mean squared error of the predictions for 300 random
				   temperature data files is calculated by the code. The code can be run in open loop
				   and closed loop mode. The file is saved in closed loop mode. To switch to open loop
				   mode change 'Xcopy' to 'X' on line 63, comment line 68 and uncomment line 69.

extra_case_evaluation.m		=> A file for running 'combinationFinder.m' for the data in the 'extra_data' folder.


*****


Startup instructions:

Option1:
If the pre-generated save_net files and trained neural networks are available, save all of the files into the 'save_net/'
folder. Once this is done, all code will be able to run. The files required are:

absnet.mat
data.mat
extradata.mat		(only required for extra_case_evaluation.m)
extradataAnswers.mat	(only required for extra_case_evaluation.m)
net.mat
net2.mat
net3.mat
net4.mat
pcanet.mat
pcanet2.mat
pcanet3.mat
pcanet4.mat
sensor_LSTM_lite.mat
uniformcases.mat

All of these files must have been generated or trained using the data set that is being investigated (5_seg_beam_csv/
or 5_seg_beam_csv_v2/).



Option 2:
If the files in save_net/ are unavailable they must first be generated:

1. Run the following code in the MATLAB command window:

[~, ~, data] = fileReader("5_seg_beam_csv") - to generate a data.mat file for the first data set

OR

[~, ~, data] = fileReader("5_seg_beam_csv_v2") - to generate a data.mat file for the second data set

2. Run these files in the following order:

uniformCaseGenerator.m
effectiveRadiusNNtrainer.m
relativeRadiusNNtrainer.m
PCA_relativeRadiusNNtrainer.m
LSTM_trainer_stateReset.m

This will generate all remaining data files and train all required neural networks.

Once this is done, all code should be able to run.





