
####################### Calibration ####################### 

#The raster values are stored in digital numbers (DNs) to reduce the file size. 
#To recalculate the actual radiation measured at the sensor, we need to apply sensor- and band-specific parameters
#Sensor Calibration is used for converting the digital numbers to meaningful units (reflectance, radiation, temperature)
#In this case, we are converting the DNs of the multispectral bands to apparent reflectance ("apref") and the thermal bands to surface temperature

#calibration:
stack_20151011_cal <- radCor(stack_20151011, metaData=meta_20151011, method = "apref") 
stack_20151112_cal <- radCor(stack_20151112, metaData=meta_20151112, method = "apref") 
stack_20190114_cal <- radCor(stack_20190114, metaData=meta_20190114, method = "apref") 
stack_20190130_cal <- radCor(stack_20190130, metaData=meta_20190130, method = "apref") 

#check that the data type of the bands has changed from integer to float:
dataType(stack_20151011)
dataType(stack_20151011_cal)

#new range of values also can be seen when comparing:
stack_20151011
stack_20151011_cal

#export the calibrated layerstack to the disk as a *.tif file:
writeRaster(stack_20151011_cal, filename="stack_20151011_cal", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(stack_20151112_cal, filename="stack_20151112_cal", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(stack_20190114_cal, filename="stack_20190114_cal", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(stack_20190130_cal, filename="stack_20190130_cal", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))


#plot the study area on top of the Landsat image
plotRGB(stack_20190114_cal, r="B4_tre", g="B3_tre", b="B2_tre", stretch="lin")
plot(SA_2019, col="Blue", border=FALSE, add=TRUE)


####################### Resize Data to study areas ####################### 

#resize the data using the crop function:
SA_20151011 <- crop(stack_20151011_cal, SA_2015)
SA_20151112 <- crop(stack_20151112_cal, SA_2015)
SA_20190114 <- crop(stack_20190114_cal, SA_2019)
SA_20190130 <- crop(stack_20190130_cal, SA_2019)

viewRGB(SA_20151011)

SA_20151011 <- mask(SA_20151011, SA_2015)
SA_20151112 <- mask(SA_20151112, SA_2015)

viewRGB(SA_20151011)

####################### Renaming bands ####################### 

#as you can see, the bands are named not very suitably for further analysis:
names(SA_20151011)

#That's why we rename them to their real names using a list with the names (band names can be easily found out using Google):
Landsat8_band_names <- c("Coastal.Aerosol", "Blue", "Green", "Red", "NIR", "SWIR.1", "SWIR.2", "Cirrus", "TIR.1", "TIR.2")

names(SA_20151011) <- Landsat8_band_names
names(SA_20151112) <- Landsat8_band_names
names(SA_20190114) <- Landsat8_band_names
names(SA_20190130) <- Landsat8_band_names

#let's have a look at the data again to see the changes:
names(SA_20190130)


####################### Cloud Masking ####################### 

#generate the cloud masks for all scenes:
cmask_20151011 <- cloudMask(SA_20151011, threshold = .2, blue = "Blue", tir = "TIR.1")
cmask_20151112 <- cloudMask(SA_20151112, threshold = .1, blue = "Blue", tir = "TIR.1")
cmask_20190114 <- cloudMask(SA_20190114, threshold = .4, blue = "Blue", tir = "TIR.1")
cmask_20190130 <- cloudMask(SA_20190130, threshold = .4, blue = "Blue", tir = "TIR.1")

#example cloud mask:
plot(cmask_20151011)

#generate the shadows for the clouds interactively:
smask_20151011 <- cloudShadowMask(SA_20151011, cmask_20151011, nc = 5) 
smask_20151112 <- cloudShadowMask(SA_20151112, cmask_20151112, nc = 5) 
smask_20190114 <- cloudShadowMask(SA_20190114, cmask_20190114, nc = 5) 
smask_20190130 <- cloudShadowMask(SA_20190130, cmask_20190130, nc = 5) 

#example shadow mask:
mapview(smask_20151011)

#merge the cloud masks and their shadows:
csmask_20151011 <- raster::merge(cmask_20151011[[1]], smask_20151011)
csmask_20151112 <- raster::merge(cmask_20151112[[1]], smask_20151112)
csmask_20190114 <- raster::merge(cmask_20190114[[1]], smask_20190114)
csmask_20190130 <- raster::merge(cmask_20190130[[1]], smask_20190130)

#example combined cloud and shadow mask:
ggRGB(SA_20190114, r="Red", g="Green", b="Blue", stretch = "lin") +
  ggR(csmask_20190114, ggLayer = TRUE, forceCat = TRUE, geom_raster = TRUE) +
  scale_fill_manual(values = c("blue", "yellow"), 
                    labels = c("Shadows", "Clouds"), na.value = NA)

#apply the masks to their scenes and save them on the disk:
SA_20151011_masked <- mask(SA_20151011, csmask_20151011, filename="SA_20151011_masked", format="GTiff", overwrite=TRUE, inverse=TRUE, maskvalue = NA)
SA_20151112_masked <- mask(SA_20151112, csmask_20151112, filename="SA_20151112_masked", format="GTiff", overwrite=TRUE, inverse=TRUE, maskvalue = NA)
SA_20190114_masked <- mask(SA_20190114, csmask_20190114, filename="SA_20190114_masked", format="GTiff", overwrite=TRUE, inverse=TRUE, maskvalue = NA)
SA_20190130_masked <- mask(SA_20190130, csmask_20190130, filename="SA_20190130_masked", format="GTiff", overwrite=TRUE, inverse=TRUE, maskvalue = NA)

#rename the bands:
names(SA_20151011_masked) <- Landsat8_band_names
names(SA_20151112_masked) <- Landsat8_band_names
names(SA_20190114_masked) <- Landsat8_band_names
names(SA_20190130_masked) <- Landsat8_band_names

#plot an example to see if the mask was applied successfully:

viewRGB(SA_20190130_masked, r="Red", g="Green", b="Blue", stretch="lin")


