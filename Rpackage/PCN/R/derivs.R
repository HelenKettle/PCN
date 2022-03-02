#' pcn.equations
#'
#' rate of change equations for DDE solver 
#'
#' @param t time (d)
#' @param x vector of state variables
#' @param parms list of paramter values 

pcn.equations <- function(t,x,parms){

    tauE <- x["tauE"] # Egg delay
    tauJ <- x["tauJ"] # Juvenile delay
    PE <- x["PE"] # Egg "survival"
    C.pre <- x["C.pre"] # Pre-mature cysts
    C <- x["C"] # Active cysts
    C.d <- x["C.d"] # Dormant cysts
    sum.J <- x["sum.J"] # Total juveniles

    with(as.list(c(parms)),{

        dayOfYr=t+simStartDay
        
        # Define temperatures at different time points
        if (is.finite(constantTemp)){
            Tempnow = constantTemp
            TempE = constantTemp
            TempJ = constantTemp
            Temp0 = constantTemp
        }else{
            Tempnow <- tempFunc(t,deltaT,simStartDay,temperatureSpline)
            TempE <- tempFunc(t-tauE,deltaT,simStartDay,temperatureSpline)
            TempJ <- tempFunc(t-tauJ,deltaT,simStartDay,temperatureSpline)
            Temp0 <- tempFunc(0,0,simStartDay,temperatureSpline)
        }
    
        # Define lags
        if((t-tauE) < 0){
            lagtauE <- 1/vitalRates$growthE(Temp0)
        } else {
            lagtauE <- pastvalue(t-tauE)[1]
        }
        if((t-tauJ) < 0){
            lagtauEJ <- 1/vitalRates$growthE(Temp0)
            lagtauJ <- 1/vitalRates$growthJ(Temp0,tauE.init)
            lagPE <- exp(-1/vitalRates$growthE(Temp0)*
                         vitalRates$deathE(Temp0,1/vitalRates$growthE(Temp0),Copt))
            lagJ <- 0
        } else {
            lagtauEJ <- pastvalue(t-tauJ)[1]
            lagtauJ <- pastvalue(t-tauJ)[2]
            lagPE <- pastvalue(t-tauJ)[3]
            lagJ <- pastvalue(t-tauJ)[(3+kE+1):(3+kE+kJ)]
        }
        if((t-tauE-tauJ-tauA.f) < 0){
            lagsumJ <- 0
            lagPEfullcycle <- 0
        } else {
            lagsumJ <- pastvalue(t-tauJ-tauA.f)[3+kE]
            lagPEfullcycle <- pastvalue(t-tauJ-tauA.f)[3]
        }
        
        # Define derivatives for egg and juvenile delays
        dtauE <- 1 - vitalRates$growthE(Tempnow)/vitalRates$growthE(TempE)
        dtauJ <- 1 - vitalRates$growthJ(Tempnow,tauE)/vitalRates$growthJ(TempJ,lagtauEJ)

        # Define number of juveniles, females and males
        Njuv = sum(x[Jvec[]])
        Nfem = sum(x[Afvec[]])
        Nmal = sum(x[Amvec[]])
        
        # Were potatoes present at given time point
        potato.presence <- potato(t,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish)
        potato.presence.cystpause <- potato(t-cyst.pause,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish)
        potato.presence.tauJ <- potato(t-tauJ,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish)
        
        # Determine initial egg density for each growing season
        if(t < (365+plantingDOY)){
          P.i <- initialEggsPerGram
        } else {
          init.C.pre <- pastvalue(((t-plantingDOY) %/% 365)*365+plantingDOY-1)[3+kE+kJ+2*kA+1]
          init.C <- pastvalue(((t-plantingDOY) %/% 365)*365+plantingDOY-1)[3+kE+kJ+2*kA+2]
          init.C.d <- pastvalue(((t-plantingDOY) %/% 365)*365+plantingDOY-1)[3+kE+kJ+2*kA+3]
          total_initial_eggs <- (init.C.pre+init.C+init.C.d)*eggs_per_cyst
          P.i <- total_initial_eggs/(root.length/roots.per.cm*soil.density)
        }
        # Calculate the root length
        actual.root.length = rootdamage(root.length, P.i)
        total.root.length = N.plants * actual.root.length
        
        # Determine death rates at different time points
        deathJnow = vitalRates$deathJ(Tempnow,PE,tauJ,potato.presence)
        deathJ.tauJ = vitalRates$deathJ(TempJ,lagPE,lagtauJ,potato.presence.tauJ)
        deathEnow = vitalRates$deathE(Tempnow,tauE,Copt)
        
        # Calculate egg "survival"
        dPE <- PE*((vitalRates$growthE(Tempnow)*vitalRates$deathE(TempE,lagtauE,Copt)/vitalRates$growthE(TempE)) - vitalRates$deathE(Tempnow,tauE,Copt))
        
        # Egg ODEs
        all.dE=rep(NA,kE)
        all.dE[1]=(kE/tauE)*(potato.presence*eggs_per_cyst*C - x[Evec[1]]*(1 + dtauE/kE))
        if (kE > 1){
            for (k in 2:kE){
                all.dE[k] = (kE/tauE)*(x[Evec[k-1]]-x[Evec[k]]*(1 + dtauE/kE))
            }
        }
        
        # Calculate the number of juveniles invading the roots.  Done by calculating the number of juveniles invading at this point in time minus the number of juveniles which invaded a full cycle ago.  This is because the sex ratio is determined by the total number of juveniles which invaded in a season.
        dsum.J <- x[Evec[kE]]*PE - lagsumJ*lagPEfullcycle
        
        # Juvenile ODEs
        all.dJ=rep(NA,kJ)
        all.dJ[1]=(kJ/tauJ)*(x[Evec[kE]]*PE - x[Jvec[1]]*(1 + dtauJ/kJ + deathJnow*tauJ/kJ))
        if (kJ > 1){
            for (k in 2:kJ){
              all.dJ[k] = (kJ/tauJ)*(x[Jvec[k-1]]-x[Jvec[k]]*(1 + dtauJ/kJ + deathJnow*tauJ/kJ))
            }
        }

        # Adult female ODEs
        all.dA.f=rep(NA,kA)
        all.dA.f[1]=(kA/tauA.f)*(x[Jvec[kJ]]*female.prop(sum.J,total.root.length,resistanceFactor,fixedGenderRatio) - x[Afvec[1]])
        if (kA > 1){
            for (k in 2:kA){
                all.dA.f[k] = (kA/tauA.f)*(x[Afvec[k-1]] - x[Afvec[k]])
            }
        }

        # Adult male ODEs
        all.dA.m=rep(NA,kA)
        all.dA.m[1]=(kA/tauA.m)*(x[Jvec[kJ]]*(1-female.prop(sum.J,total.root.length,resistanceFactor,fixedGenderRatio))-x[Amvec[1]])
        if (kA > 1){
            for (k in 2:kA){
                all.dA.m[k] = (kA/tauA.m)*(x[Amvec[k-1]] - x[Amvec[k]])
            }
        }
        
        # Pre-mature cyst equation
        if((t-cyst.pause) < 0){
          dC.pre <- (1-gen2)*PA*potato.presence*x[Afvec[kA]]
        } else {
          dC.pre <- (1-gen2)*PA*potato.presence*x[Afvec[kA]] - (1-gen2)*PA*pastvalue(t-cyst.pause)[3+kE+kJ+kA]*potato.presence.cystpause
        }

        # Active cyst equations
        if((t-cyst.pause) < 0){
          dC <- gen2*PA*potato.presence*x[Afvec[kA]] -potato.presence * C + dormancy * C.d - deathC * C
        } else {
          dC <- gen2*PA*potato.presence*x[Afvec[kA]] + (1-gen2)*PA*pastvalue(t-cyst.pause)[3+kE+kJ+kA]*potato.presence.cystpause - deathC * C - potato.presence * C + dormancy * C.d
        }
        
        # Dormant cyst equations
        dC.d <- (Copt-PE)*x[Evec[kE]]/eggs_per_cyst - deathC * C.d - dormancy * C.d
        
        der <- c(dtauE,dtauJ,dPE,all.dE,all.dJ,all.dA.f,all.dA.m,dC.pre,dC,dC.d,dsum.J)
        list(der)
    })
}
