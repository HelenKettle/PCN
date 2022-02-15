speciesVec=c('rosto','pallida')[1]#[1:2]#[1] etc
tempChangeVec=c(0,1)[1]#[1:2]#[2] etc

#Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For automatic plotting, only run for one PCN species at a time (make sure length(speciesVec)=1). For continuous planting use c(start=0,fin=0).
noPotatoYearsList=list(c(start=0,fin=0),c(start=2,fin=6))#,c(start=2,fin=15))

numYears=10 #number of years to simulate
simStartDay=100 #day of the year the simulation starts (Dave 182.5) (note time in equations always runs from 0 but simulation can start on any day)

#Choose what to plot
plotAbundance=0
plotStages=0
comparePotatoPresence=0
compareSpeciesAndTemp=0
runQuickPlot=0

runModel=1

plantingDOY=110
harvestingDOY=plantingDOY+7*10 #eg 10 weeks to grow

initialNumCysts=20000 #this is related to time of year simulation starts!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

saveFig=TRUE
figType='png'
