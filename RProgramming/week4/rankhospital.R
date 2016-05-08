source("best.R")

## description

rankhospital <- function(state, outcome, num = "best")
{
        ret = NA
        data <- read.csv("outcome-of-care-measures.csv", 
                            colClasses = "character")

        states <- unique(data$State) ## valid states
        outcomes <- c("heart attack", "heart failure", "pneumonia") ## valid

        ## Check that state and outcome are valid
        if (!(state %in% states))
                stop("invalid state")   ## Oops! This is not a good state

        if (!(outcome %in% outcomes))
                stop("invalid outcome") ## Oops! This is not a good outcome

        base = "Hospital.30.Day.Death..Mortality..Rates.from."

        simple = simpleCap(outcome)     ## Need to get the column name
        s = sprintf("%s%s", base, simple)

        # fl1 <- data[[s]] != "Not Available"

        # data = data.frame(Hospital.Name = data$Hospital.Name[fl1],
        #                 Hospital.Rate = data[[s]][fl1],
        #                 State = data$State[fl1])

        dat <- data[order(suppressWarnings(as.numeric(data[[s]])),
                                data$Hospital.Name), ]
        fl1 = dat[[s]] != "Not Available" ## Wanna keep these entries
        fl2 = dat$State == state    ## This is the state we want
        tmp <- data.frame(Hospital.Name = dat$Hospital.Name[fl1 & fl2],
                                Rate = dat[[s]][fl1 & fl2],
                                State = dat$State[fl1 & fl2],
                                Rank = 1:length(dat$Hospital.Name[fl1 & fl2])
                         )

        if (num == "best") {
                ret <- tmp$Hospital.Name[1]
        }

        else if (num == "worst") {
                ret <- tmp$Hospital.Name[nrow(tmp)]
        }

        else if (as.numeric(num) <= nrow(data)) {
                ret <- tmp$Hospital.Name[num]
        }

        as.character(ret)
}
