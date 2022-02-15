#HK 12th March 2019.
#Based on DE's code from 23rd Jan:
#'/My files/Research/Potato Cyst Nematodes Models/DaveEwing/Code/PCN Model - PBSddesolve.R'

rm(list=ls())
graphics.off()

library(PBSddesolve)

srcFolder='../ModelFunctions/' 
source('../ModelFunctions/srcFiles.R')

source('parameters.R')
source('settings.R')


pcn.function <- function(parms,initial,timeVec){
    require(PBSddesolve)
    ts <- timeVec
    as.data.frame(dde(y=initial,times=ts,func=pcn.equations,parms=parms,hbsize=100000))
}

Testing=1 #When testing, temperature is fixed (see below), gender ratio fixed and 3 figures are produced using quickPlot()


if (Testing){ #-------------------------------------TESTING--------------------
    speciesVec=c('rosto','pallida')[1]
    tempChangeVec=0
    fixTemp=18 #NULL leave this as null if you want temperature to vary through the year. 
    fixedGenderRatio=0.4 #NULL leave as null if you want M:F to be dependent on M density. 
    resistanceFactor=c(rosto=0,'pallida'=0)
    plotAbundance=0
    plotStages=0
    runQuickPlot=1
    noPotatoYearsList=list(c(start=0,fin=0))
    numYears=2
    saveFig=FALSE
}else{
    fixTemp=NULL 
    fixedGenderRatio=NULL
}#----------------------------------------------------------------------



##########################run model###################################

stageNames=c('cysts','juveniles','females','males')

timeVec=seq(0,numYears*365,by=0.5) #model time starts at zero, time interval is 0.5 day

# check functions
#dev.new()
#par(mfrow=c(2,2))
#plotPotato(timeVec,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsVec)
#plotTemperature(timeVec,tempChangeVec,simStartDay,constantTemp)


for (species in speciesVec){
    
    for (deltaT in tempChangeVec){

        if (!is.null(fixTemp)){
            constantTemp=fixTemp+deltaT
        }else{
            constantTemp=NULL
        }
        
        for (pot in 1:length(noPotatoYearsList)){

            noPotStart=noPotatoYearsList[[pot]]['start']
            noPotFinish=noPotatoYearsList[[pot]]['fin']

            Evec=paste('E',1:kEvec[species],sep='')
            Jvec=paste('J',1:kJ,sep='')
            Afvec=paste('A',1:kA,'.f',sep='')
            Amvec=paste('A',1:kA,'.m',sep='')
            
            parms = list(
                deltaT = deltaT,
                kE = kEvec[species],
                kJ = kJ,
                kA = kA,
                tauA=adultStageDuration,
                PA=1,
                deathC=cystDeathRate,
                eggs_per_cyst=eggs_per_cyst,
                species=species,
                resistanceFactor=resistanceFactor[species],
                simStartDay=simStartDay,
                constantTemp=constantTemp,
                plantingDOY=plantingDOY,
                harvestingDOY=harvestingDOY,
                noPotatoYearsStart=noPotStart,
                noPotatoYearsFinish=noPotFinish,
                optHatch=optHatch,
                Evec=Evec,
                Jvec=Jvec,
                Afvec=Afvec,
                Amvec=Amvec
            )
            
            initial=initFunc(parms)

            parms$tauE.init=initial['tauE']

            if (runModel){

                output <- pcn.function(parms,initial,timeVec)

                if (length(noPotatoYearsList)==1){
                    run.name=paste('output.pcn',species,'dT',deltaT,sep='.')
                }else{
                   run.name=paste('output.pcn',species,'dT',deltaT,noPotStart,noPotFinish,sep='.')
                }
                
                assign(run.name,output)
            }

        }
    }
}


#####################   plots   #########################################################


if (runQuickPlot){
    #just plot the last model run to check it's ok - look at J and E compartments
    quickPlot(output,species,eggs_per_cyst,stageNames,parms)
}
    
if (plotAbundance){

    if (saveFig & figType == "png") {
        dev.new(bg = "white", horizontal = FALSE, onefile = FALSE, paper = "special", 
                width = 7, height = 7)
    } else {
        dev.new()
    }

    if (comparePotatoPresence){
        figName='Planting'
        par(mfrow=c(2,2),mar=c(5,4,2,1))
        #ymax=c(170000,8000000,25000,80000); names(ymax)=stageNames
        for (stage in stageNames){
            plotCompareAbundanceFunc(stage,speciesVec,tempChangeVec,
                                     simStartDay,stageNames,eggs_per_cyst=300,
                                     parms,
                                     runList=noPotatoYearsList)#,ymax[stage])
        }
    }
    
    if (compareSpeciesAndTemp){
        figName='Climate'
        par(mfrow=c(2,2))
        #ymax=c(150000,8000000,25000,80000); names(ymax)=stageNames
        for (stage in stageNames){
            plotCompareAbundanceFunc(stage,speciesVec,tempChangeVec,
                                     simStartDay,stageNames,eggs_per_cyst=300,
                                     parms,
                                     runList=noPotatoYearsList)#,ymax[stage])
        }
    }

    if (saveFig) {
        if (figType == "pdf") {dev.copy2pdf(file = paste(figName,"pdf", sep = "."))}
        if (figType == "eps") {dev.copy2eps(file = paste(figName, "eps", sep = "."))}
        if (figType == "png") {
            dev.print(png, filename = paste(figName, "png", sep = "."), res = 100, 
                width = 7, height = 7, units = "in")
        }
        if (figType == "tiff") {
            dev.print(tiff, filename = paste(figName, "tiff", sep = "."), 
                      res = 100, width = 7, height = 7, units = "in")
        }
    }
 

}

if (plotStages){

    dev.new()
    par(mfrow=c(length(speciesVec),length(tempChangeVec)),mar=c(5,5,2,1))
    for (species in speciesVec){
        for (deltaT in tempChangeVec){
            run.name=paste('output.pcn',species,'dT',deltaT,sep='.')
            plotStageProgression(get(run.name),species,eggs_per_cyst,stageNames,simStartDay,parms,deltaT)
        }
    }

}


if (!Testing){
#normalisedPlot(output,species,eggs_per_cyst,stageNames,parms)
#runNamesVec=c(paste('output.pcn',species,'dT.0',sep='.'),paste('output.pcn',species,'dT.1',sep='.'))
runNamesVec=c(paste('output.pcn',species,'dT.0.0.0',sep='.'),paste('output.pcn',species,'dT.0.2.6',sep='.'))
               
progressionPlot(runNamesVec=runNamesVec,
                lineTypes=1:2,
                lineCols=c('black','red','blue'),
                legendText=c('constant planting','no planting from 2-6 yr'),
                stageNames=c('cysts','juveniles','females'),
                Ymax=2.5,
                species=species,
                saveFig=TRUE,
                figType='png')


comparisonPlot(runNamesVec=runNamesVec,
               lineTypes=1:2,
               lineCols=c('red','red'),
                legendText=c('constant planting','no planting from 2-6 yr'),
               stageNames=stageNames,
               saveFig=TRUE,
               figType='png',
               figName='planting')



}
