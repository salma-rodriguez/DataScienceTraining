pollutantmean <- function(directory, pollutant, id = 1:332) {
        ## directory is a character vector of length 1 indicating
        ## the location of the CSV files

        ## polutant is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the 
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used

        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)

        start <- Sys.time()

        ## the hard part... fasten your seat belts

        files <- lapply(id, function(x)
                        sprintf("%s/%03d.csv", directory, id[x]))
        data <- lapply(files, read.csv)
        data <- do.call(rbind, data)

        print(Sys.time() - start)

        ## easy daisy...
        mean(data[[pollutant]], na.rm = TRUE)  # see? that wasn't rough!!!
}
