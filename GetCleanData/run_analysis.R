## This module prepares a data set with averages for different measures taken
## from accelerometers tested on various subjects. The averages are split into
## several activities.

make_dataset <- function() {

## read names for features:
	names <- readLines("UCI HAR Dataset/features.txt")

## read lines from training set into a variable data_train:
	data_train <- readLines("UCI HAR Dataset/train/X_train.txt")

## read lines from test set into a variable data_test:
	data_test  <- readLines("UCI HAR Dataset/test/X_test.txt")

## clean up the training data
	data_train <- 	sapply(1:length(data_train),
			function(x) {
				t <- strsplit(data_train[x], " ")[[1]];
				t <- t[t != ""]
			})

## take the transpose to get the 561 features as columns
	data_train <- t(data_train)

## clean up the test data
	data_test <-	sapply(1:length(data_test),
			function(x) {
				t <- strsplit(data_test[x], " ")[[1]];
				t <- t[t != ""]
			})

## take the transpose to get the 561 features as columns
	data_test <- t(data_test)

## bind the training and test data sets into one data set
	data <- rbind(data_train, data_test)
	
## trim out feature number in the front
	names <- sapply(1:length(names),
		 function(x) sub("\\d+ (\\w+)", "\\1", names[x]))

## apply the variable names
	colnames(data) <- names

## choose the columns matching the pattern "mean" or "std"
	data <- data[, c(grep("std|mean[^Freq]", colnames(data)))]

## We want to retrieve the activity names
	activities <- readLines("UCI HAR Dataset/activity_labels.txt")

## Time to trim out number in the front like we did with features 
	activities <- sapply(1:length(activities),
		      function(x) sub("\\d+ (\\w+)", "\\1", activities[x]))

## We want to read the activities for training and test sets and combine them
	train_acts <- readLines("UCI HAR Dataset/train/y_train.txt")
	test_acts  <- readLines("UCI HAR Dataset/test/y_test.txt")
	acts <- c(train_acts, test_acts) # putting our acts together
	
## We want to also read the subjects for training and test sets and combine
	train_subj <- readLines("UCI HAR Dataset/train/subject_train.txt")
	test_subj  <- readLines("UCI HAR Dataset/test/subject_test.txt")
	subj <- c(train_subj, test_subj) # putting subjects together

## Add activity and subject columns
	data <- cbind(Subject = subj, Activity = acts, data)
	
## Taking the average of all records, per measurement on each subject / activity
	avgs <- sapply(1:ncol(data), function(x)
            tapply(as.numeric(data[,x]), list(acts, subj), mean))

## Append "AVG" (for average) to each activity name
	actv <- sapply(1:length(activities), ## set descriptive activity name
                function(x) sprintf("%s_%s", activities[x], "AVG"))

## Set the column names again, since we lost them at some point
	colnames(avgs) <- colnames(data)

## Tidy data to be returned with "Activity" and "Subject" columns
	avgs <- data.frame(avgs)
		
## Cute way to map activity name to the activity number for each record
	avgs[,2] <- sapply(1:length(avgs[,2]), function(x) actv[avgs[,2][x]])
}
