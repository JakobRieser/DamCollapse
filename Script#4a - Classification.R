########################################################################################################################################################
############################## Classification ##########################################################################################################
########################################################################################################################################################


####################### 2015 ####################### 

Training_20151011 <- readOGR("Training/Training_20151011.shp")
Training_20151112 <- readOGR("Training/Training_20151112.shp")

Training_20151011 <- spTransform(Training_20151011, CRS(proj4string(SA_20151011_Indices)))
Training_20151112 <- spTransform(Training_20151112, CRS(proj4string(SA_20151112_Indices)))

ggRGB(SA_20151011_Indices, r="Red", g="Green", b="Blue", stretch = "lin")+
  geom_polygon(data=Training_20151011, aes(x = long, y = lat, group=group), col="red", fill=NA)

SC_20151011 <- superClass(SA_20151011_Indices, trainData = Training_20151011, responseCol = "CLASS_NAME", filename = "SC_20151011.tif")
SC_20151112 <- superClass(SA_20151112_Indices, trainData = Training_20151112, responseCol = "CLASS_NAME", filename = "SC_20151112.tif")

par(mfrow=c(1,2))
plot(SC_20151011$map, col=c("grey", "darkgreen", "chartreuse", "coral1", "blue"))
plot(SC_20151112$map, col=c("grey", "darkgreen", "chartreuse", "blue", "coral1"))

Classification_20151011 <- raster("SC_20151011.tif")
Classification_20151112 <- raster("SC_20151112.tif")



####################### 2019 ####################### 

#load the training datasets for 2019:
Training_20190114 <- readOGR("Training/Training_20190114.shp")
Training_20190130 <- readOGR("Training/Training_20190130.shp")

Training_20190114 <- spTransform(Training_20190114, CRS(proj4string(SA_20190114_Indices)))
Training_20190130 <- spTransform(Training_20190130, CRS(proj4string(SA_20190130_Indices)))

summary(Training_20190130)

#plot on top of imagery to see if it worked:
ggRGB(SA_20190114_Indices, r="Red", g="Green", b="Blue", stretch = "lin")+
  geom_polygon(data=Training_20190114, aes(x = long, y = lat, group=group), col="red", fill=NA)

#The actual Classification, random forest algorithm:
SC_20190114 <- superClass(SA_20190114_Indices, trainData = Training_20190114, responseCol = "CLASS_NAME", filename = "SC_20190114.tif")
SC_20190130 <- superClass(SA_20190130_Indices, trainData = Training_20190130, responseCol = "CLASS_NAME", filename = "SC_20190130.tif")

#look at the classifications:
par(mfrow=c(1,2))
plot(SC_20190114$map, col=c("grey", "darkgreen", "chartreuse", "coral1"))
plot(SC_20190130$map, col=c("grey", "darkgreen", "chartreuse", "blue", "coral1"))

#convert them to a raster file:
Classification_20190114 <- raster("SC_20190114.tif")
Classification_20190130 <- raster("SC_20190130.tif")
