rankall <- function(outcome, num = "best") {
    ## Read outcome data
    
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
        
        ## Rename the column names for readability
        names(data) <- c("hospital",
                         "state",
                         "heart attack",
                         "heart failure",
                         "pneumonia")
    
    
    ## Check that 'outcome' is valid

        ## Create a list of valid 'outcomes'
        validOutcomes <- c("heart attack", "heart failure", "pneumonia")
        
        ## Create a list of valid 'states'
        validStates <- sort(unique(data$state))
    
        ## Check for invalid 'outcome' value
        if (!outcome %in% validOutcomes) {
            stop("invalid outcome")
        }
    
    
    ## For each state, find the hospital of the given rank

        ## For processing efficiency, pre-allocate space for the 
        ## data frame containing the result
        df <- data.frame(hospital=character(length(validStates)),
                         state=character(length(validStates)),
                         row.names=validStates,
                         stringsAsFactors=FALSE)
    
        ## Order the data frame by state
        data <- data[order(data$state),]
        
        ## Split the data frame into a list of data frames by 'state'
        s <- split(data,data$state)
    
        ## Loop through the states
        for (i in 1:length(validStates)) {
            
            ## Extract out the 'state' from the list
            s1 <- s[[validStates[i]]]
                       
            ## Order the 'state' data frame by 'outcome' and then
            ## by 'hospital name' while removing all NA values
            s1 <- s1[order(s1[[outcome]],
                           s1$hospital,
                           na.last=NA),]
            
            ## Set the row index value
            if (num=="best") {
                row <- 1
            } else if (num=="worst") {
                row <- nrow(s1)
            } else {
                row <- num
            }

            ## Insert the 'hospital name' and 'state' into the data frame
            df$hospital[i] <- s1[row,1]
            df$state[i] <- validStates[i]
            
        }
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    
        return(df)
    
}