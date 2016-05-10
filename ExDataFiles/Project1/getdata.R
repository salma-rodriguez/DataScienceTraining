# This function reads data for electric power consumption

# Assumption: we are pointing to the directory containing 
# household_power_consumption.txt

getdata <- function() {

        filename <- "household_power_consumption.txt"
        
        con <- file(filename)
        colnames <- read.table(con, nrow=1, sep=";")
        con <- file(filename)
        data <- read.table(con,
                           skip=66637,
                           nrow=2880,
                           na.strings="?",
                           col.names=colnames, sep=";")
        
        data <- setNames(data, sapply(1:ncol(colnames),
                         function(x) as.character(colnames[[x]])))
}
