complete <- function(directory, id = 1: 332, data = NULL) {
        ## directory is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an inoeger vector indicating the monitor ID numbers
        ## to be used

        ## return a data frame of the form: 
        ## id nobs
        ## 1 117
        ## 2 1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases

        ## the hard part... fasten your seat belts

        if (length(data) == 0) {
                files <- lapply(id,
                                function(x) 
                                        sprintf("%s/%03d.csv",directory,id[x]))
                data <- do.call(rbind, lapply(files, read.csv))
        }

        ## slow down, now... 

        no <- split(data$nitrate, data$ID) ; so <- split(data$sulfate, data$ID)

        rets <- sapply(id, 
                       function(x) { 
                                complete <- !is.na(no[[x]]) & !is.na(so[[x]]) ;
                                length(complete[complete == TRUE])
                       })

        ## here we go...

        rets <- data.frame(id = id, nobs = rets)

        ## see? that wasn't too bad
        rets
}
