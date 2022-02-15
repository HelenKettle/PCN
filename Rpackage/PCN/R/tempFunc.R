tempFunc <- function(t,deltaT,simStartDay,constantTemp=NA,temperaturefile=NULL,init.temp=14.5){
    # t is model time
    # simStartDay is the day of the year that the simulation starts (when t=0)

    if (is.na(constantTemp)){
    
      if(is.null(temperaturefile)){
        
        dayOfYear=(t+simStartDay)%%365
        if(t >= 0){
            Temp = 13 + 2*(1-cos(2*pi*(t-182.5)/365))+deltaT
        } else {
            Temp = 13 + 2*(1-cos(2*pi*(0-182.5)/365))+deltaT
        }
      } else {
        
        if(t > 0){
            Temp = predict(temperaturefile,t)$y+deltaT
        } else {
            Temp = median(predict(temperaturefile,0:14)$y)+deltaT
        }
        
      }
        
    }else{
        Temp = constantTemp
    }
    return(Temp)
}
