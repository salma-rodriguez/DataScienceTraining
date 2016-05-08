## Best is a function that returns the best hospital in a state
## for one of "heart attack", "heart failure", or "pneumonia"

## @state: a state
## @outcome: one of "heart attack", "heart failure", or "pneumonia"
best <- function(state, outcome) {

        ## Read outcome data
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

        f1 <- data$State == state
        f2 <- data[[s]] != "Not Available"

        # mydata <- as.numeric(data[[s]][f1 & f2])
        # print(mydata)

        ## Return hospital name in that state with lowest 30-day death rate
        lowest <- min(as.numeric(data[[s]][f1 & f2]))
        ret <- data$Hospital.Name[data[[s]] == lowest & f1]

        if (length(ret) > 1)
              ret <- sort(ret)[1]
        ret
}

## borrowed from Stack Overflow with slight modification
simpleCap <- function(x) {
        s <- strsplit(x, " ")[[1]]
        paste(toupper(substring(s, 1, 1)), substring(s, 2),
                      sep = "", collapse = ".")
}
