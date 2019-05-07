################### Calculate Mudflow extent ################### 

#at the end, we want to have shapefiles of the mudflow of 2015 and 2019

#create the polygon that shows the extent of the mudflow
Mudflow_2015 <- rasterToPolygons(Classification_20151112, fun=function(Classification_20151112){Classification_20151112==4}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)
Mudflow_2019 <- rasterToPolygons(Classification_20190130, fun=function(Classification_20190130){Classification_20190130==4}, n=4, na.rm=TRUE, digits=12, dissolve=TRUE)

dev.off()
plotRGB(SA_20190130_Indices, r="Red", g="Green", b="Blue", stretch="lin")
plot(Mudflow_2019, col="red", border=FALSE, add=TRUE)

plotRGB(SA_20151112_Indices, r="Red", g="Green", b="Blue", stretch="lin")
plot(Mudflow_2015, col="red", border=FALSE, add=TRUE)

#calculate the dried up area:
area(Mudflow_2019) #in m2
area(Mudflow_2019)/1000000 #in km2

area(Mudflow_2015)
area(Mudflow_2015)/1000000

#add it to the shapefile:
Mudflow_2019$area_sqm <- area(Mudflow_2019)
Mudflow_2019$area_sqkm <- area(Mudflow_2019)/1000000

Mudflow_2015$area_sqm <- area(Mudflow_2015)
Mudflow_2015$area_sqkm <- area(Mudflow_2015)/1000000

#add coordinate system
Mudflow_2019 <- spTransform(Mudflow_2019, CRS("+proj=longlat +datum=WGS84"))
Mudflow_2015 <- spTransform(Mudflow_2015, CRS("+proj=longlat +datum=WGS84"))

#export the shapefiles to disk (to view in QGIS and further analysis):
writeOGR(Mudflow_2019, ".", "Mudflow_2019", driver="ESRI Shapefile", overwrite_layer=TRUE) #as shapefile 
writeOGR(Mudflow_2015, ".", "Mudflow_2015", driver="ESRI Shapefile", overwrite_layer=TRUE) #as shapefile 

#export the kml-files to disk (to view in Google Earth)
writeOGR(Mudflow_2019[1], "Mudflow_2019.kml", layer="layer", driver="KML", overwrite_layer=TRUE) #as kml (for Google Earth)
writeOGR(Mudflow_2015[1], "Mudflow_2015.kml", layer="layer", driver="KML", overwrite_layer=TRUE) #as kml (for Google Earth)
