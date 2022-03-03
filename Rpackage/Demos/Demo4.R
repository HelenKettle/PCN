#Using sinusoidal temperature curve, plant a month earlier

rm(list=ls())
#graphics.off()

library(devtools)
library(roxygen2)

parent_f='~/PCN2022/Rpackage/'
package_f='~/PCN2022/Rpackage/PCN/'

setwd(paste0(parent_f,'Demos/'))

load_all(package_f)


### Model settings
numYears=1 #number of years to simulate
simStartDay=90 #day of the year the simulation starts e.g. 1st April

initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)


dev.new(width=13,height=6)
par(mfrow=c(1,3))

for (plantingDOY in c(60,90,120)){

    out=PCNmodel(numYears=numYears,
        simStartDay=simStartDay,
        initialEggsPerGram=initialEggsPerGram,
        soil.density = soil.density,
        plantingDOY=plantingDOY, # potatoes planted on this day of the year
        harvestingDOY=plantingDOY+216, # potatoes harvested on this day of the year
        temperature.pars=list(
            temperatureSpline=NULL, 
            fixTemp = NA,
            deltaT = 0 
        )
                 )
    
    
    plotPCN(out$solution,out$parms,ylim=c(0,250),main=paste('Planting day of year is',plantingDOY))
    
    cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))
    
    text(250,150,paste('Final number of cysts is',cysts.final),cex=1.5)

    print(paste('final number of cysts is',cysts.final))

}

dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo4.eps')
