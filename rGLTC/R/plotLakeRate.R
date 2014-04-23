years <- seq(1981, 2011, 1)
JAS   <- c(20.73997826,20.49088629,22.44897212,20.11883581,19.60421843,20.03156355,20.84880435,20.9536859,
	20.72137482,20.22217391,21.07083333,18.7446558,19.16350932,20.10784161,21.70702899,20.50652174,20.65117057,
	21.86543478,20.67756211,20.19476708,22.14347826,22.64094203,21.43737458,19.78728261,22.37119352,21.9936853,
	21.61718965,20.94931677,20.23333333,21.87336957,22.02336957)
	
	
	
	figW  <- 8
	figH  <- 3.5
	lM    <-.95
	bM    <-.5
	rM    <-.25
	tM    <-.25
	fRes  <- 200
	fontN <- 11
	xL    <- c(1980,2012)
	yL1    <- c(18.5,23)
	output <- "Crystal_Lake.png"
	png(output, width=figW, height=figH, units="in",res=fRes)
	par(mai=c(bM,lM,rM,tM))

	ylabel <- expression(paste('Surface temperature ','(', degree,'C)'))
	plot(xL,yL1,type="n",xlab="",ylab=ylabel,
	     font=fontN,font.lab=fontN,tcl=-.2,xaxs="i",cex.lab=1.2,cex=1.3)

# fit 

stPt <- 11
LM 	<- lm(JAS[stPt:length(years)]~years[stPt:length(years)])

LM$coef[[1]]
LM$coef[[2]]

x1 <- years[stPt]
x2 <- years[length(years)]
y1 <- LM$coef[[1]]+x1*LM$coef[[2]]
y2 <- LM$coef[[1]]+x2*LM$coef[[2]]
y1
y2
x1 
x2
points(years,JAS,col=rgb(0,100,0,150,maxColorValue=255), pch=16, cex=1)
points(years,JAS,col=rgb(0,100,0,255,maxColorValue=255), pch=1, cex=1.1)

lines(c(x1,x2),c(y1,y2),lwd=2)

