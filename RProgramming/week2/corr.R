corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all variables)
        ## required to compute the correlation between nitrate and
        ## sulfate; the default is 0

        ## Return a numeric vector of correlations

        id <- 1:332 ## find correlation across all dataset members

        files <- lapply(id,
                                function(x) 
                                        sprintf("%s/%03d.csv",directory,id[x]))
        data <- do.call(rbind, lapply(files, read.csv))

        com  <- complete(directory, data = data)
        monitor <- com$id[com$nobs > threshold]

        no <- split(data$nitrate, data$ID) ; so <- split(data$sulfate, data$ID)

        ret <- sapply(monitor,
                                function(m) {
                                        na <- !is.na(no[[m]]) & !is.na(so[[m]])
                                        cor(no[[m]][na], so[[m]][na])
                                })

        ret
}

