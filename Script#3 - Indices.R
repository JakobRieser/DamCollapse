########################################################################################################################################################
############################# Computing Indices ########################################################################################################
########################################################################################################################################################


#A total of five indices are computed to support the classification algorithm. 
#NDWI is the Normalized Difference Water Index
#NDVI is the Normalized Difference Vegetation Index
#NDBI is the Normalized Difference Biult-up Index
#BU is the Build-up Index  (NDBI - NDVI)
#NDBaI is the Normalized Difference Bare Soil Index

####################### NDWI ####################### 

NDWI_20151011 <- (SA_20151011_masked[["Green"]]-SA_20151011_masked[["NIR"]])/(SA_20151011_masked[["Green"]]+SA_20151011_masked[["NIR"]])
NDWI_20151112 <- (SA_20151112_masked[["Green"]]-SA_20151112_masked[["NIR"]])/(SA_20151112_masked[["Green"]]+SA_20151112_masked[["NIR"]])
NDWI_20190114 <- (SA_20190114_masked[["Green"]]-SA_20190114_masked[["NIR"]])/(SA_20190114_masked[["Green"]]+SA_20190114_masked[["NIR"]])
NDWI_20190130 <- (SA_20190130_masked[["Green"]]-SA_20190130_masked[["NIR"]])/(SA_20190130_masked[["Green"]]+SA_20190130_masked[["NIR"]])

mapview(NDWI_20190114)


####################### NDVI ####################### 

NDVI_20151011 <- (SA_20151011_masked[["NIR"]]-SA_20151011_masked[["Red"]])/(SA_20151011_masked[["NIR"]]+SA_20151011_masked[["Red"]])
NDVI_20151112 <- (SA_20151112_masked[["NIR"]]-SA_20151112_masked[["Red"]])/(SA_20151112_masked[["NIR"]]+SA_20151112_masked[["Red"]])
NDVI_20190114 <- (SA_20190114_masked[["NIR"]]-SA_20190114_masked[["Red"]])/(SA_20190114_masked[["NIR"]]+SA_20190114_masked[["Red"]])
NDVI_20190130 <- (SA_20190130_masked[["NIR"]]-SA_20190130_masked[["Red"]])/(SA_20190130_masked[["NIR"]]+SA_20190130_masked[["Red"]])

mapview(NDVI_20190130)

####################### NDBI ####################### 

NDBI_20151011 <- (SA_20151011_masked[["SWIR.1"]]-SA_20151011_masked[["NIR"]])/(SA_20151011_masked[["SWIR.1"]]+SA_20151011_masked[["NIR"]])
NDBI_20151112 <- (SA_20151112_masked[["SWIR.1"]]-SA_20151112_masked[["NIR"]])/(SA_20151112_masked[["SWIR.1"]]+SA_20151112_masked[["NIR"]])
NDBI_20190114 <- (SA_20190114_masked[["SWIR.1"]]-SA_20190114_masked[["NIR"]])/(SA_20190114_masked[["SWIR.1"]]+SA_20190114_masked[["NIR"]])
NDBI_20190130 <- (SA_20190130_masked[["SWIR.1"]]-SA_20190130_masked[["NIR"]])/(SA_20190130_masked[["SWIR.1"]]+SA_20190130_masked[["NIR"]])

mapview(NDBI_20190130)

####################### BU ####################### 

BU_20151011 <- (NDBI_20151011-NDVI_20151011)
BU_20151112 <- (NDBI_20151112-NDVI_20151112)
BU_20190114 <- (NDBI_20190114-NDVI_20190114)
BU_20190130 <- (NDBI_20190130-NDVI_20190130)

mapview(BU_20190130)

####################### NDBI ####################### 

NDBaI_20151011 <- (SA_20151011_masked[["SWIR.1"]]-SA_20151011_masked[["TIR.1"]])/(SA_20151011_masked[["SWIR.1"]]+SA_20151011_masked[["TIR.1"]])
NDBaI_20151112 <- (SA_20151112_masked[["SWIR.1"]]-SA_20151112_masked[["TIR.1"]])/(SA_20151112_masked[["SWIR.1"]]+SA_20151112_masked[["TIR.1"]])
NDBaI_20190114 <- (SA_20190114_masked[["SWIR.1"]]-SA_20190114_masked[["TIR.1"]])/(SA_20190114_masked[["SWIR.1"]]+SA_20190114_masked[["TIR.1"]])
NDBaI_20190130 <- (SA_20190130_masked[["SWIR.1"]]-SA_20190130_masked[["TIR.1"]])/(SA_20190130_masked[["SWIR.1"]]+SA_20190130_masked[["TIR.1"]])

mapview(NDBaI_20190130)


####################### Stacking ####################### 

#stacking the Indices to the Brick as additional layers:
SA_20151011_Indices <- stack(SA_20151011_masked, NDWI_20151011, NDVI_20151011, NDBI_20151011, BU_20151011, NDBaI_20151011)
SA_20151112_Indices <- stack(SA_20151112_masked, NDWI_20151112, NDVI_20151112, NDBI_20151112, BU_20151112, NDBaI_20151112)
SA_20190114_Indices <- stack(SA_20190114_masked, NDWI_20190114, NDVI_20190114, NDBI_20190114, BU_20190114, NDBaI_20190114)
SA_20190130_Indices <- stack(SA_20190130_masked, NDWI_20190130, NDVI_20190130, NDBI_20190130, BU_20190130, NDBaI_20190130)

#export them to disk:
writeRaster(SA_20151011_Indices, filename="SA_20151011_Indices", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(SA_20151112_Indices, filename="SA_20151112_Indices", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(SA_20190114_Indices, filename="SA_20190114_Indices", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))
writeRaster(SA_20190130_Indices, filename="SA_20190130_Indices", format="GTiff", overwrite=TRUE,options=c("INTERLEAVE=BAND","COMPRESS=LZW"))

#rename the bands:
names(SA_20151011_Indices) <- c(Landsat8_band_names, "NDWI", "NDVI", "NDBI", "BU", "NDBaI")
names(SA_20151112_Indices) <- c(Landsat8_band_names, "NDWI", "NDVI", "NDBI", "BU", "NDBaI")
names(SA_20190114_Indices) <- c(Landsat8_band_names, "NDWI", "NDVI", "NDBI", "BU", "NDBaI")
names(SA_20190130_Indices) <- c(Landsat8_band_names, "NDWI", "NDVI", "NDBI", "BU", "NDBaI")