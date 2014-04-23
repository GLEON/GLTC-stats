
getCRU	<-	function(lat,long, period='JAS',use.years = seq(1985,2009)){
	require(ncdf4)
  if (period=="JAS"){
    mm.idx  <-	c(7,8,9)
  } else if (period=='JFM'){
    mm.idx <- c(1,2,3)
  }	else if (period=='annual'){
	mm.idx <- seq(1,12)
  }
	
  
  
  vals = get.vals(lat,long,years='1981.1990')

  CA = vals
  
	vals = get.vals(lat,long,years='1991.2000')
	CA	<-	rbind(CA,vals)
  
	vals = get.vals(lat,long,years='2001.2010')
	CA	<-	rbind(CA,vals)
  
  data.out <- data.frame("years"=use.years,"tMean"=vector(length=length(use.years)))
  for (j in 1:length(use.years)){
    use.i = as.numeric(format(CA$DateTime, "%Y"))==use.years[j] &
      as.numeric(format(CA$DateTime, "%m"))==mm.idx
    data.out$tMean[j] = mean(CA$tmp[use.i])
  }
  
	return(data.out)
}

get.vals <- function(lat,long,years){
  
  start.time = 1
  
  data.dir  <-	"/Users/jread/Documents/R/GLTC-R/data/CRU_ts3.21/"
  nc	<-	nc_open(filename=paste(data.dir,'cru_ts3.21.',years,'.tmp.dat.nc',sep=''))
  lat.vals	<-	ncvar_get(nc,varid="lat")
  lon.vals	<-	ncvar_get(nc,varid="lon")
  days.since <- ncvar_get(nc,varid="time")
  
  lat.i	<-	which.min(abs(lat.vals-lat))[1]
  lon.i	<-	which.min(abs(lon.vals-long))[1]
  vals = ncvar_get(nc=nc, varid="tmp",start=c(lon.i,lat.i,start.time),count=c(1,1,length(days.since)))
  nc_close(nc)
  
  days.since = as.Date('1900-01-01')+days.since
  df <- data.frame("DateTime"=days.since,"tmp"=vals)
  return(df)
}

require(ncdf4)
period = 'JFM'

master	<-	read.table("/Users/jread/Documents/R/GLTC-R/data/Master_names_lat_lon.txt",header=TRUE,sep='\t')
lake.names	<-	names(master)
lake.lat	<-	as.numeric(master[1,])
lake.lon	<-	as.numeric(master[2,])

years = seq(1985,2009)
num.years = length(years)
num.lakes = length(lake.names)

lake.CRU <- matrix(nrow=num.years,ncol=num.lakes)
for (i in 1:num.lakes){
  lake.CRU[, i] = getCRU(lat=lake.lat[i],long=lake.lon[i],period, use.years = years)$tMean
  cat('done with ');cat(lake.names[i]);cat('\n')
}

lake.df = data.frame(lake.CRU)
names(lake.df) = lake.names
lake.df <- cbind(data.frame("years"=use.years),lake.df)

write.table(x=lake.df,file=paste("/Users/jread/Documents/R/GLTC-R/data/CRUts3.21_",period,".tsv",sep=''),quote=FALSE,sep='\t',row.names=FALSE)