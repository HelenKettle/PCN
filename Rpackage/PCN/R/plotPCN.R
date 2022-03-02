#' plotPCN
#'
#' @param out matrix called 'solution' in output list from PCNmodel()
#' @param parms parms list from output of PCNmodel()
#'
#' @import graphics 
#' 
#' @export
plotPCN=function(out,parms,ylim=NULL,mainTxt=NULL){

    time=out[,1]+parms$simStartDay

    Eggs=rowSums(out[,parms$Evec])
    Juveniles=rowSums(out[,parms$Jvec])
    Adults=rowSums(out[,c(parms$Afvec,parms$Amvec)])
    Cysts=rowSums(out[,c('C.pre','C','C.d')]) #check!!!

    finalmat=cbind(Eggs,Juveniles,Adults,Cysts)

    
    graphics::matplot(time,finalmat,type='l',lwd=2,
            xlab='Julian day',ylab='Abundance',
            cex.axis=1.5,cex.lab=1.5,ylim=ylim,main=mainTxt)

    graphics::legend('topright',col=1:4,lty=1:4,lwd=2,
           legend=c('Eggs','Juveniles','Adults','Cysts'),
           bty='n',cex=1.4)

}
