########################################################################################################################################################
############################# NDVI Change Detection #########################################################################################################
########################################################################################################################################################


# The other approach is to use the Change in the NDVI values to detect the mudflows

#generate the NDVI Change maps:

Change_NDVI_2015 <- (NDVI_20151011-NDVI_20151112)
Change_NDVI_2019 <- (NDVI_20190114-NDVI_20190130)
Change_NDVI_2019

################### Calculate Mudflow extent ################### 

#at the end, we want to have shapefiles of the mudflow of 2015 and 2019
#to calculate the extent of the mudflow we need to define thresholds: 
#which values are representing the mudflow? --> >=0.35 

#therefore we let all other values be NAs (so they will not be recognised when we transfer the raster into a shapefile):
Change_NDVI_2015[Change_NDVI_2015 < 0.35] <- NA
Change_NDVI_2019[Change_NDVI_2019 < 0.35] <- NA

#all other values need to be the same, otherwise every different value will be transferred into a single polygon:
Change_NDVI_2019[Change_NDVI_2019 >= 0.35] <- 1
Change_NDVI_2015[Change_NDVI_2015 >= 0.35] <- 1

plot(Change_NDVI_2019)
plot(Change_NDVI_2015)

#make the mudflow extent a polygon for further analysis:
Mudflow_2019_NDVI <- rasterToPolygons(Change_NDVI_2019, fun=function(Change_NDVI_2019){Change_NDVI_2019>0}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
Mudflow_2015_NDVI <- rasterToPolygons(Change_NDVI_2015, fun=function(Change_NDVI_2015){Change_NDVI_2015>0}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)

plot(Mudflow_2019_NDVI, col="red", border=FALSE)
plot(Mudflow_2015_NDVI, col="red", border=FALSE)


################### Calculate mudflow area ################### 

#calculate the area covered with water:

area(Mudflow_2015_NDVI) #in m2
area(Mudflow_2015_NDVI)/1000000 #in km2

area(Mudflow_2019_NDVI)
area(Mudflow_2019_NDVI)/1000000

#add the area information as a column to the shapefile attribute table:
Mudflow_2015_NDVI$area_sqm <- area(Mudflow_2015_NDVI)
Mudflow_2015_NDVI$area_sqkm <- area(Mudflow_2015_NDVI)/1000000

Mudflow_2019_NDVI$area_sqm <- area(Mudflow_2019_NDVI)
Mudflow_2019_NDVI$area_sqkm <- area(Mudflow_2019_NDVI)/1000000


################### Export the shapefiles to disk ###################

#add coordinate system
Mudflow_2019_NDVI <- spTransform(Mudflow_2019_NDVI, CRS("+proj=longlat +datum=WGS84"))
Mudflow_2015_NDVI <- spTransform(Mudflow_2015_NDVI, CRS("+proj=longlat +datum=WGS84"))

#export the shapefiles to disk (to view in QGIS and further analysis):
writeOGR(Mudflow_2019_NDVI, ".", "Mudflow_2019_NDVI", driver="ESRI Shapefile", overwrite_layer=TRUE) #as shapefile 
writeOGR(Mudflow_2015_NDVI, ".", "Mudflow_2015_NDVI", driver="ESRI Shapefile", overwrite_layer=TRUE) #as shapefile 

#export the kml-files to disk (to view in Google Earth)
writeOGR(Mudflow_2015_NDVI[1], "Mudflow_2015_NDVI.kml", layer="layer", driver="KML", overwrite_layer=TRUE) #as kml (for Google Earth)
writeOGR(Mudflow_2019_NDVI[1], "Mudflow_2019_NDVI.kml", layer="layer", driver="KML", overwrite_layer=TRUE) #as kml (for Google Earth)


