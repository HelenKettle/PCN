#Using constant temperature, change number of resistance

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
simStartDay=50 #day of the year the simulation starts e.g. 1st April
initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density - used to calculate initial cysts (derivs, initialCinditions.R)


dev.new(width=13,height=6)
par(mfrow=c(1,3))

for (n in c(0,0.5,1)){

    out=PCNmodel(numYears=numYears,
        simStartDay=simStartDay,
        initialEggsPerGram=initialEggsPerGram,
        soil.density = soil.density,
        temperature.pars=list(
            temperatureSpline=NULL, 
            fixTemp = NA,
            deltaT = 0 
        ),
    plant.pars=list(
        resistanceFactor = n, # resistance factor of potatoes
        N.plants = 1, # Number of potato plants
        root.length = 500, # maximum length of plant roots (cm) in healthy plant
        roots.per.cm = 0.5 # root length density of potato plants
    )
                 )
    
    
    plotPCN(out$solution,out$parms,ylim=c(0,250),main=paste('Resistance factor:',n))
    
    cysts.final=round(sum(out$solution[nrow(out$solution),c('C.pre','C','C.d')]))
    
    text(250,150,paste('Final number of cysts is',cysts.final),cex=1.5)

    print(paste('final number of cysts is',cysts.final))

}

dev.copy2eps(file='~/PCN2022/Rpackage/Demos/Demo6.eps')
