A Data Analysis Codebook
========================

### Author
        Salma Y Rodriguez

### Course
        Getting and Cleaning Data 2014

### Instructor
        Jeffrey T. Leek

### Date
        December 20, 2014

## I. DESCRIPTION

This data is the average of various sensor signals read from the
Samsung Galaxy S II (check README for details on original study).
The averages captured in this analysis are for the signal length and
frequency per sliding window of 2.56 sec, for each of the activities
described under the corresponding "Activity Type" in sections 3-8,


## II. DATA DICTIONARY FOR NAVIGATING THROUGH DATASET

### 1. Subject [Column 1]

        The data type in this set is [numeric].

Identifies the subject who carried out the experiment.

### 2. Activity [Column 2]

        The data type in this set is [character].

One of six activities described in sections 4-9.

### 3. Variables [Columns 3-68]

        The data type in this set is [numeric].

These are the standard deviation and mean for various sensor signals
in the Samsung Galaxy apparatus (66 in total). The signals are for the
accelerometer and gyroscope 3-axial.


        tBodyAcc-X
        tBodyAcc-Y
        tBodyAcc-Z
        tGravityAcc-X
        tGravityAcc-Y
        tGravityAcc-Z
        tBodyAccJerk-X
        tBodyAccJerk-Y
        tBodyAccJerk-Z
        tBodyGyro-XYZ
        tBodyGyroJerk-X
        tBodyGyroJerk-Y
        tBodyGyroJerk-Z
        tBodyAccMag
        tGravityAccMag
        tBodyAccJerkMag
        tBodyGyroMag
        tBodyGyroJerkMag
        fBodyAcc-X
        fBodyAcc-Y
        fBodyAcc-Z
        fBodyAccJerk-X
        fBodyAccJerk-Y
        fBodyAccJerk-Z
        fBodyGyro-X
        fBodyGyro-Y
        fBodyGyro-Z
        fBodyAccMag
        fBodyAccJerkMag
        fBodyGyroMag
        fBodyGyroJerkMag


Here the prefixes 'f' and 't' are for frequency domain and time domain
signals respectively (measured in standard SI units of sec and Hertz).
*-mean() and *-std() are appended to each of the measurements for the
mean and standard deviation, respectively.

### 4. WALKING_AVG [Activity Type]

This attribute represents a walking activity, for each
of 66 sensor signals described under Variable
(section 3), and each participant identified under Subject (section 2).

### 5. WALKING_UPSTAIRS_AVG [Activity Type]

This attribute represents a "walking upstairs" activity,
for each of 66 sensor signals described under Variable (section 3),
and each participant identified under Subject (section 2).

### 6. WALKING_DOWNSTAIRS_AVG [Activity Type]

This attribute represents a "walking downstairs" activity,
for each of 66 sensor signals described under Variable (section 3),
and each participant identified under Subject (section 2).

### 7. SITTING_AVG [Activity Type]

This attribute represents a sitting activity,
for each of 66 sensor signals described under Variable (section 3),
and each participant identified under Subject (section 2).

### 8. STANDING_AVG [Activity Type]

This attribute represents a standing activity,
for each of 66 sensor signals described under Variable (section 3),
and each participant identified under Subject (section 2).

### 9. LAYING_AVG [Activity Type]

This attribute represents a laying activity,
for each of 66 sensor signals described under Variable (section 3),
and each participant identified under Subject (section 2).
