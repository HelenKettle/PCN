#' initialConditions
#'
#' Creates the initial conditions vector.
#' Assume that all life stages are empty apart from active cysts
#' Temperature at t=0 is used for calculating initial stage durations
#'
#' @param parms input parameter list
#'
#' @return initialVec for tauE, tauJ, PE, Einit, Jinit, Afinit, Aminit, C.pre, C, C.d, sum.J

initialConditions=function(parms){
    

    initial = with(parms,{


        if (is.finite(constantTemp)){
            Temp0=constantTemp
        }else{
            Temp0 <- tempFunc(0,deltaT,simStartDay,temperatureSpline)
        }
        
        tauE.init <- 1/growthE(Temp0)

        PE.init <- exp(-1/growthE(Temp0)*deathE(Temp0,1/growthE(Temp0),Copt))
            
        tauJ.init <- 1/growthJ(Temp0,tauE.init)

         #Eq 20 Ewing et al 2021:
        Cyst.init <- initialEggsPerGram*N.plants*root.length/roots.per.cm*soil.density/eggs_per_cyst

        Evec=paste('E',1:kE,sep='')
        Einit=rep(0,kE); names(Einit)=Evec
        
        Jvec=paste('J',1:kJ,sep='')
        Jinit=rep(0,kJ); names(Jinit)=Jvec
        
        Afvec=paste('A',1:kA,'.f',sep='')
        Afinit=rep(0,kA); names(Afinit)=Afvec
        
        Amvec=paste('A',1:kA,'.m',sep='')
        Aminit=rep(0,kA); names(Aminit)=Amvec
        
        initialVec <- c(tauE = tauE.init, 
                        tauJ = tauJ.init, 
                        PE = PE.init, 
                                        #PJ = PJ.init, 
                        Einit,
                        Jinit,
                        Afinit,
                        Aminit,
                        C.pre=0,
                        C=Cyst.init,
                        C.d=0,
                        sum.J=0
                        )
    })


    return(initial)
}

    
