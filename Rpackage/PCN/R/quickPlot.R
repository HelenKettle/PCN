quickPlot=function(out,parms){


    time=out[,1]

    Eggs=rowSums(out[,parms$Evec])
    Juveniles=rowSums(out[,parms$Jvec])
    Adults=rowSums(out[,c(parms$Afvec,parms$Amvec)])
    Cysts=rowSums(out[,c('C.pre','C','C.d')]) #check!!!

    finalmat=cbind(Eggs,Juveniles,Adults,Cysts)

    
    matplot(time,finalmat,type='l',lwd=2,
            xlab='Time (d)',ylab='Abundance',
            cex.axis=1.5,cex.lab=1.5)

    legend('topright',col=1:4,lty=1:4,lwd=2,
           legend=c('Eggs','Juveniles','Adults','Cysts'),
           bty='n',cex=1.4)

    
}
