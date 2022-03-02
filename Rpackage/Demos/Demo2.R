#simple model run with constant then sinusoidal temperature

rm(list=ls())
graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Demos/'))

load_all(package_f)


deltaT=0

### Model settings
numYears=1 #number of years to simulate
simStartDay=90 #day of the year the simulation starts e.g. 1st April

initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)
plantingDOY=90 # potatoes planted on this day of the year
harvestingDOY=216 # potatoes harvested on this day of the year
noPotatoYearsList=list(c(start=2,fin=3)) # Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For continuous planting use c(start=0,fin=0).


dev.new(height=7,width=10)
par(mfrow=c(1,2))

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    temperature.pars=list(
        temperatureSpline=NULL,
        fixTemp = 13,
        deltaT = deltaT
    )
             )


out1=out

plotPCN(out$solution,out$parms,ylim=c(0,350),main=paste('fixed temp'))

print(paste('final number of cysts is',round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]),1)))

#increase deltaT
out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    temperature.pars=list(
        temperatureSpline=NULL,
        fixTemp = NA,
        deltaT = deltaT
    )
             )


out2=out
plotPCN(out2$solution,out2$parms,ylim=c(0,350),main=paste('sinusoidal temp'))

print(paste('final number of cysts is',round(sum(out2$solution[nrow(out2$solution),c('C.pre','C','C.d')]),1)))

