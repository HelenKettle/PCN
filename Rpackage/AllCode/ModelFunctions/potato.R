potato <- function(t,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish){

    #t is model time
    #simStartDay is the day of the year the simulation starts (where t=0)
    #plantingDOY is day of year potatoes are planted
    #harvestingDOY is day of year potatoes are harvested
    #missingYears is a vector of years (starting from 1) that potatoes aren't planted
    
    dayOfYear=(t+simStartDay)%%365

    year=1+((t+simStartDay)%/%365) 
    
    # Add this line to run things on a six year rotation with potatoes in year 1,7,13,...
    year = ((year-1) %% 6)+1

    potatoPresent = 1
    
    if (year>=noPotatoYearsStart & year<=noPotatoYearsFinish){
        potatoPresent = 0
    }

    if (dayOfYear > harvestingDOY | dayOfYear < plantingDOY){
        potatoPresent = 0
    }
    
    return(potatoPresent)
}

