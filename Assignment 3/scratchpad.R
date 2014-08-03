##
## Read outcome data (Old Way)
##

    ## Read the .csv file
    outcomeData <- read.csv("outcome-of-care-measures.csv",
                            na.strings = "Not Available",
                            colClasses = "character")
    
    ## Convert 30-day mortality rates to numeric
    ##  outcomeData[,11] = Mortality Rates from Heart Attack
    ##  outcomeData[,17] = Mortality Rates from Heart Failure
    ##  outcomeData[,23] = Mortality Rates from Pneumonia
    outcomeData[,11] <- as.numeric(outcomeData[,11])
    outcomeData[,17] <- as.numeric(outcomeData[,17])
    outcomeData[,23] <- as.numeric(outcomeData[,23])


##
## Read outcome data (New Way)
##

    ## Create a vector identifying the columns to be read from the file.
    ## A "NULL" will skip a column while an NA will read a column.
    ##
    ## Only the following columns are to be read from the file:
    ##     2. Hospital Name
    ##     7. State
    ##    11. Hospital 30-Day Death (Mortality) Rates from Heart Attack
    ##    17. Hospital 30-Day Death (Mortality) Rates from Heart Failure
    ##    23. Hospital 30-Day Death (Mortality) Rates from Pneumonia
    ##
    mycols <- rep("NULL",46)        ## Populate vector to skip all columns
    mycols[c(2,7,11,17,23)] <- NA   ## Specify columns to read
    
    ## Read the .csv file
    data <- read.csv("outcome-of-care-measures.csv",
                     colClasses = mycols,
                     stringsAsFactors = FALSE,
                     na.strings = "Not Available")
    
    ## Rename the columns for readability
    names(data) <- c("hospital",
                     "state",
                     "heart attack",
                     "heart failure",
                     "pneumonia")

    
##    
## Split the data frame by state
##
    ## Hardcode arguments for now
    state <- "AL"
    outcome <- "heart attack"
    
    ## Order the data frame by state
    data <- data[order(data$state),]

    ## Split the data frame into a list of data frames by state
    s <- split(data,data$state)

    ## Extract out the state from the list
    s1 <- s[[state]]
    
    ## Order the 'state' data frame by 'outcome' and then by
    ## 'hospital name' while removing all NA values
    s1 <- s1[order(s1[[outcome]],
                   s1$hospital,
                   na.last=NA),]


##
## Test loop
##
    for (state in validStates) {
        print(state)
    }