Human Activity Recognition Using Smartphones
============================================

## Background Information
The data collected in this project is based on an experiment carried out with
a group of 30 volunteers within an age bracket of 19-48 years. Each volunteer
performed sixe activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, 3-axial linear
acceleration and 3-axial angular velocity were captured at a constant rate of
50 Hz. The experiments were video recorded to label the data manually.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying
noise filters and then sampled in fixed-width sliding windows of 2.56 secs and
50% overlap (128 readings/window). The sensor acceleration signal, which has
gravitational and body motion components, was separated using a Butterworth
low-pass filter into body acceleration and gravity. The gravitational force is
assumed to have only low frequency components, therefore a filter with 0.3 Hz
cuttoff frequency was used. For each sliding window, a vector of features was
obtained by calculating from the time and frequency domain.

Visit http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
for more invormation.

## Description of Analysis
The training set containing 70% of the volunteers and test set containing 30%
were combined into a single data set. Each individual was grouped into one of
the six activities. The accelerometer and gyroscope readings were averaged for
each activity. Check the codebook.md for further details about each field of
the data that was collected in this analysis.

## Walkthrough
1. Download and unzip the following data to a local directory:
        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Run the analysis script file as follows:
        R -e "source('./run_analysis.R'); make_dataset()" > outfile.txt
3. The output file 'outfile.txt' should contain the average of each measurement variable
   for each activity, per subject.

## Source 
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - UniversitA degli Studi di Genova, Genoa I-16145, Italy.
activityrecognition '@' smartlab.ws
www.smartlab.ws

## Citation Request
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra, and Jorge L.
Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
Hardware-Friendly Support Vector Machine. International Workshop of Ambient
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.

