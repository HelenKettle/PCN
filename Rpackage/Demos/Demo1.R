#simple model run with constant temperature, then add 4 oC

rm(list=ls())
graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Demos/'))

load_all(package_f)

fixTemp=14
deltaT=0

### Model settings
numYears=1 #number of years to simulate
simStartDay=90 #day of the year the simulation starts e.g. 1st April
initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)


dev.new(height=7,width=10)
par(mfrow=c(1,2))

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    temperature.pars=list(
        temperatureSpline=NULL,
        fixTemp = fixTemp,
        deltaT = deltaT
    )
             )


plotPCN(out$solution,out$parms,ylim=c(0,350),main=paste('fixed temp of',fixTemp,'+',deltaT))

cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))
    
text(250,150,paste('Final number of cysts is',cysts.final),cex=1.2)

print(paste('final number of cysts is',cysts.final))


#increase deltaT
deltaT=4

out=PCNmodel(numYears=numYears,
    simStartDay=simStartDay,
    initialEggsPerGram=initialEggsPerGram,
    soil.density = soil.density,
    temperature.pars=list(
        temperatureSpline=NULL,
        fixTemp = fixTemp,
        deltaT = deltaT
    )
             )


plotPCN(out$solution,out$parms,ylim=c(0,350),main=paste('fixed temp of',fixTemp,'+',deltaT))

cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))
    
text(250,150,paste('Final number of cysts is',cysts.final),cex=1.2)

print(paste('final number of cysts is',cysts.final))

dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo1.eps')
