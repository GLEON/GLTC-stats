
getJAS_CC	<-	function(lat,long,year, period='JAS'){
	require(ncdf4)
  if (period=="JAS"){
    mm.idx  <-	c(7,8,9)
  } else if (period=='JFM'){
    mm.idx <- c(1,2,3)
  }	else if (period=='annual'){
	mm.idx <- seq(1,12)
  }

	data.dir	<-	"/Users/jread/Documents/R/GLTC-R/data/Cloud_cover_PATMOSX/"
	nc	<-	nc_open(filename=paste(data.dir,'CA_PATMOSX_NOAA_0130PM_',as.character(year),'.nc',sep=''))
	lat.vals	<-	ncvar_get(nc,varid="latitude")
	lon.vals	<-	ncvar_get(nc,varid="longitude")
	
	lat.i	<-	which.min(abs(lat.vals-lat))[1]
	lon.i	<-	which.min(abs(lon.vals-long))[1]
	CA	<-	ncvar_get(nc=nc, varid="a_CA",start=c(lon.i,lat.i,mm.idx[1]),count=c(1,1,length(mm.idx)))
  nc_close(nc)
	return(mean(CA))
}

period = 'annual'

master	<-	read.table("/Users/jread/Documents/R/GLTC-R/data/Master_names_lat_lon.txt",header=TRUE,sep='\t')
lake.names	<-	names(master)
lake.lat	<-	as.numeric(master[1,])
lake.lon	<-	as.numeric(master[2,])

years = seq(1985,2009)
num.lakes <- length(lake.names)
num.years <- length(years)
lake.CC <- matrix(nrow=num.years,ncol=num.lakes)
for (j in 1:num.years){
  for (i in 1:num.lakes){
    lake.CC[j,i] = getJAS_CC(lake.lat[i],lake.lon[i],years[j],period)
  }
}

lake.df = data.frame(lake.CC)
names(lake.df) = lake.names
lake.df <- cbind(data.frame("years"=years),lake.df)

write.table(x=lake.df,file=paste("/Users/jread/Documents/R/GLTC-R/data/PATMOS-x_Clouds_",period,".tsv",sep=''),quote=FALSE,sep='\t',row.names=FALSE)