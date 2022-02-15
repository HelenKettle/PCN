#HK 12th March 2019.
#Based on DE's code from 23rd Jan:
#'/My files/Research/Potato Cyst Nematodes Models/DaveEwing/Code/PCN Model - PBSddesolve.R'
#'
#NOTE: THIS CODE IS FOR RUNNING THE MODEL ON THE LAPTOP/DESKTOP BUT SINCE UPDATING TO RUN SENS ANALYSIS
# ON AZOG THIS PROBABLY WON'T WORK AS IT STANDS.

rm(list=ls())
graphics.off()

#setwd("M:/My_files/Research/PCN/PCN")

setwd("//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/PCN")

library(PBSddesolve)

srcFolder='./ModelFunctions/' 
source('./ModelFunctions/srcFiles.R')

source('./Running/parametersDE.R')
source('./Running/settingsDE.R')


pcn.function <- function(parms,initial,timeVec){
    require(PBSddesolve)
    ts <- timeVec
    as.data.frame(dde(y=initial,times=ts,func=pcn.equations,parms=parms,hbsize=100000))
}

Testing=0 #When testing, temperature is fixed (see below), gender ratio fixed and 3 figures are produced using quickPlot()


if (Testing){ #-------------------------------------TESTING--------------------
    speciesVec=c('rosto','pallida')[2]
    tempChangeVec=0
    fixTemp=NULL #leave this as null if you want temperature to vary through the year. 
    fixedGenderRatio=NULL #leave as null if you want M:F to be dependent on M density. 
    resistanceFactor=c('rosto'=0,'pallida'=0)
    plotAbundance=1
    plotStages=1
    runQuickPlot=1
    noPotatoYearsList=list(c(start=0,fin=0))
    numYears=1
    saveFig=FALSE
}else{
    fixTemp=NULL 
    fixedGenderRatio=NULL
}#----------------------------------------------------------------------



##########################run model###################################

stageNames=c('cysts','eggs','juveniles','females','males')

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
                tauA.m=adultmaleStageDuration,
                tauA.f=adultfemaleStageDuration,
                PA=1,
                deathC=cystDeathRate,
                dormancy=dormancy,
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


# if (runQuickPlot){
#     #just plot the last model run to check it's ok - look at J and E compartments
#     quickPlot(output,species,eggs_per_cyst,stageNames,parms)
# }
#     
# if (plotAbundance){
# 
#     if (saveFig & figType == "png") {
#         dev.new(bg = "white", horizontal = FALSE, onefile = FALSE, paper = "special", 
#                 width = 7, height = 7)
#     } else {
#         dev.new()
#     }
# 
#     if (comparePotatoPresence){
#         figName='Planting'
#         par(mfrow=c(2,2),mar=c(5,4,2,1))
#         #ymax=c(170000,8000000,25000,80000); names(ymax)=stageNames
#         for (stage in stageNames){
#             plotCompareAbundanceFunc(stage,speciesVec,tempChangeVec,
#                                      simStartDay,stageNames,eggs_per_cyst=300,
#                                      parms,
#                                      runList=noPotatoYearsList)#,ymax[stage])
#         }
#     }
#     
#     #if (compareSpeciesAndTemp){
#     #    figName='Climate'
#     #    par(mfrow=c(2,2))
#     #    #ymax=c(150000,8000000,25000,80000); names(ymax)=stageNames
#     #    for (stage in stageNames){
#     #        plotCompareAbundanceFunc(stage,speciesVec,tempChangeVec,
#     #                                 simStartDay,stageNames,eggs_per_cyst=300,
#     #                                 parms,
#     #                                 runList=noPotatoYearsList)#,ymax[stage])
#     #    }
#     #}
# 
#     if (saveFig) {
#         if (figType == "pdf") {dev.copy2pdf(file = paste(figName,"pdf", sep = "."))}
#         if (figType == "eps") {dev.copy2eps(file = paste(figName, "eps", sep = "."))}
#         if (figType == "png") {
#             dev.print(png, filename = paste(figName, "png", sep = "."), res = 100, 
#                 width = 7, height = 7, units = "in")
#         }
#         if (figType == "tiff") {
#             dev.print(tiff, filename = paste(figName, "tiff", sep = "."), 
#                       res = 100, width = 7, height = 7, units = "in")
#         }
#     }
#  
# 
# }
# 
# if (plotStages){
# 
#     dev.new()
#     par(mfrow=c(length(speciesVec),length(tempChangeVec)),mar=c(5,5,2,1))
#     for (species in speciesVec){
#         for (deltaT in tempChangeVec){
#             run.name=paste('output.pcn',species,'dT',deltaT,sep='.')
#             plotStageProgression(get(run.name),species,eggs_per_cyst,stageNames,simStartDay,parms,deltaT)
#         }
#     }
# 
# }
# 
# 
# if (!Testing){
# #normalisedPlot(output,species,eggs_per_cyst,stageNames,parms)
# #runNamesVec=c(paste('output.pcn',species,'dT.0',sep='.'),paste('output.pcn',species,'dT.1',sep='.'))
# runNamesVec=c(paste('output.pcn',species,'dT.0.0.0',sep='.'),paste('output.pcn',species,'dT.0.2.6',sep='.'))
#                
# progressionPlot(runNamesVec=runNamesVec,
#                 lineTypes=1:2,
#                 lineCols=c('black','red','blue'),
#                 legendText=c('constant planting','no planting from 2-6 yr'),
#                 stageNames=c('cysts','juveniles','females'),
#                 Ymax=2.5,
#                 species=species,
#                 saveFig=TRUE,
#                 figType='png')
# 
# 
# comparisonPlot(runNamesVec=runNamesVec,
#                lineTypes=1:2,
#                lineCols=c('red','red'),
#                 legendText=c('constant planting','no planting from 2-6 yr'),
#                stageNames=stageNames,
#                saveFig=TRUE,
#                figType='png',
#                figName='planting')
# 
# 
# 
# }

output.ha <- output
save(output.ha, file="//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/Results/Mult_ratio_ha.Rdata")
load(file="//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/Results/Mult_ratio_luff.Rdata")

kacz.data <- read.csv("//212.219.57.223/HomeDirVol/dewing/My_files/Research/PCN/Data/Kaczmarek 2019 Seasonal Abundance.csv", header=T)
par(mfrow=c(1,1))
time.out <- output$time

juv.surv <- output$PJ
juv.out <- (output$tauJ/20)*rowSums(output[,25:44])
juv.dead <- output$J.dead

females.out <- (21/50)*rowSums(output[,46:95])
males.out <- (21/50)*rowSums(output[,96:145])

eggs.out.ha <- (output.ha$tauE/20)*(rowSums(output.ha[,5:24]))
cysts.pre.ha <- output.ha[,146]
cysts.out.ha <- output.ha[,147]
cysts.dormant.out.ha <- output.ha[,148]
cysts.eggs.out.ha <- rowSums(cbind(eggs.out.ha/300,cysts.pre.ha,cysts.out.ha,cysts.dormant.out.ha))

eggs.out.luff <- (output.luff$tauE/20)*(rowSums(output.luff[,6:25])/300)
cysts.pre.luff <- output.luff[,146]
cysts.out.luff <- output.luff[,147]
cysts.dormant.out.luff <- output.luff[,148]
cysts.eggs.out.luff <- rowSums(cbind(eggs.out.luff,cysts.pre.luff,cysts.out.luff,cysts.dormant.out.luff))

kacz.data.juv <- subset(kacz.data, Stage == "Juvenile")
kacz.data.juv.low <- subset(kacz.data.juv, Temperature == 14.3)
kacz.data.juv.high <- subset(kacz.data.juv, Temperature == 17.3)
kacz.data.juv.low.morag <- subset(kacz.data.juv.low, Potato == "Morag")
kacz.data.juv.low.des <- subset(kacz.data.juv.low, Potato == "Desiree")
kacz.data.juv.high.morag <- subset(kacz.data.juv.high, Potato == "Morag")
kacz.data.juv.high.des <- subset(kacz.data.juv.high, Potato == "Desiree")

kacz.data.males <- subset(kacz.data, Stage == "Males")
kacz.data.males.low <- subset(kacz.data.males, Temperature == 14.3)
kacz.data.males.high <- subset(kacz.data.males, Temperature == 17.3)
kacz.data.males.low.morag <- subset(kacz.data.males.low, Potato == "Morag")
kacz.data.males.low.des <- subset(kacz.data.males.low, Potato == "Desiree")
kacz.data.males.high.morag <- subset(kacz.data.males.high, Potato == "Morag")
kacz.data.males.high.des <- subset(kacz.data.males.high, Potato == "Desiree")

kacz.data.cysts <- subset(kacz.data, Stage == "Cysts")
kacz.data.cysts.low <- subset(kacz.data.cysts, Temperature == 14.3)
kacz.data.cysts.high <- subset(kacz.data.cysts, Temperature == 17.3)
kacz.data.cysts.low.morag <- subset(kacz.data.cysts.low, Potato == "Morag")
kacz.data.cysts.low.des <- subset(kacz.data.cysts.low, Potato == "Desiree")
kacz.data.cysts.high.morag <- subset(kacz.data.cysts.high, Potato == "Morag")
kacz.data.cysts.high.des <- subset(kacz.data.cysts.high, Potato == "Desiree")

plot(time.out,output$PE, type="l", main="Egg Survival")

plot(time.out,output$tauE, type="l", main="Egg Duration")

plot(time.out,output$tauJ, type="l", main="Juvenile Duration")

par(mfrow=c(3,1))
plot(time.out/7,eggs.out.ha, type="l", main="Eggs", ylab="Abundance", xlab="Week")

plot(time.out/7,juv.out, type="l", main="Juveniles", ylab="Abundance", xlab="Week")
plot(time.out/7,juv.out+juv.dead, type="l", main="Juveniles", ylab="Abundance", xlab="Week")


plot(time.out,females.out, type="l")
#points(kacz.data.males.low.des$Week*7, kacz.data.males.low.des$Count)

plot(time.out/7,males.out, type="l", main="Males", ylab="Abundance", xlab="Week")
points(kacz.data.males.low.des$Week, kacz.data.males.low.des$Count)

plot(time.out/7,cysts.eggs.out, type="l", main="Cysts", xlab="Week", ylab="Abundance")
points(kacz.data.cysts.low.des$Week, kacz.data.cysts.low.des$Count)

plot(time.out/7,cysts.eggs.out.ha/cysts.eggs.out.ha[1], type="l", main="Multiplication Ratios from Field Trials", xlab="Week", ylab="Multiplication Ratio")
harp.adams.wk <- seq(0,20,by=4)
harp.adams.mult <- c(1,0.9,0.4,1.2,4.9,5.1)
harp.adams.cara <- c(1,0.5,0.7,1.2,5,7.5)
harp.adams.des <- c(1,0.8,0.4,1.2,3.8,5.2)
harp.adams.est <- c(1,1,0.4,1.2,7,2.8)
harp.adams.pip <- c(1,1.3,0.6,2,3.5,5)

luffness.wk <- seq(0,20,by=4)
luffness.mult <- c(1,1,0.5,0.5,6.25,3.75)
luffness.cara <- c(1,1.5,0.5,0.5,4.75,5)
luffness.des <- c(1,0.25,0.2,1,7.5,2.5)
luffness.est <- c(1,0.8,0.6,0.4,6.5,3.5)
luffness.pip <- c(1,1.1,0.6,0.4,7.75,4.2)

points(luffness.wk,luffness.mult)
points(luffness.wk,luffness.cara,col="blue")
points(luffness.wk,luffness.des,col="red")
points(luffness.wk,luffness.est,col="orange")
points(luffness.wk,luffness.pip,col="purple")

points(harp.adams.wk,harp.adams.mult,pch=3)
points(harp.adams.wk,harp.adams.cara,col="blue",pch=3)
points(harp.adams.wk,harp.adams.des,col="red",pch=3)
points(harp.adams.wk,harp.adams.est,col="orange",pch=3)
points(harp.adams.wk,harp.adams.pip,col="purple",pch=3)

lines(time.out/7,cysts.eggs.out.luff/1000, lty=2)
legend("topleft",c("Average","Cara","Desiree","Estima","M. Piper"),pch=c(1,1,1,1,1),col=c("black","blue","red","orange","purple"))
