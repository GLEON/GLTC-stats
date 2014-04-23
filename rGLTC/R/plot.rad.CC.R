# compare radiation trends with CC trends

p.cut = 1
data.dir  <-	"/Users/jread/Documents/R/GLTC-R/data/Cloud_cover_PATMOSX/"

master  <-	read.csv("/Users/jread/Documents/R/GLTC-R/data/Radiation_trends_2014-01-20.csv")

lake.names.rad <- master$Lake
rad.slope.JAS <- master$RtotSummer.Slope
rad.p.JAS <- master$RtotSummer.Slope.p


use.i <- which(rad.p.JAS<p.cut)

#plot(rad.slope.JAS[use.i])

print(lake.names.rad[use.i])
cc.slope.JAS= rad.slope.JAS[use.i]*NA

use.lakes = lake.names.rad[use.i]
clouds <- read.table("/Users/jread/Documents/R/GLTC-R/data/PATMOS-x_Clouds_JAS.tsv",header=TRUE,sep='\t')

for (i in 1:length(use.lakes)){
  lake.i = which(names(clouds)==use.lakes[i])
  res=lm(clouds[,lake.i]~clouds$years)

  cc.slope.JAS[i] <- res$coefficients[[2]]
}


fig.w = 4
fig.h = 4

png(filename = "../Trends_CC_Rtot.png",
    width = fig.w, height = fig.h, units = "in", res=300)
plot(cc.slope.JAS,rad.slope.JAS[use.i],pch=21,col='firebrick',
     ylab="Rtot slope (1985-2007)",gp=gpar(fill="grey"),
     xlab="Cloud fraction slope (1985-2009)",
     cex.lab=1.2)
par(mai=c(.25,.25, .25, .25),omi=c(0,0,0,0))
dev.off()
