####################### Install and load the needed packages ####################### 

#install and load the following packages:

Packages <- c("raster", "rgdal", "RStoolbox", "ggplot2", "mapview", "osmdata", "getSpatialData")

install.packages(Packages)
devtools::install_github("16EAGLE/getSpatialData")

lapply(Packages, library, character.only = TRUE)


####################### set the working directory ####################### 

#check your current working directory:
getwd()

#set the directory to the folder you want to work in and get & store your data:
setwd("D:/Programme/OneDrive/EAGLE M.Sc/Term 1 (Winter 2018 - 2019)/MB2 - Introduction to Programming and Geostatistics/Final Project/Data/") 




########################################################################################################################################################
################### Landsat Data import ##############################################################################################
########################################################################################################################################################


#load the study area (stored as a shapefile):
SA_2015 <- readOGR("Study Areas/StudyArea_2015_riverarea.shp")
SA_2019 <- readOGR("Study Areas/StudyArea_2019.shp")

#reproject the coordinate system of the shapefile
#it's required for further analysis that the shapefile has the same coordinate system as the layerstack:
SA_2015 <- spTransform(SA_2015, CRS(proj4string(stack_20151011_cal)))
SA_2019 <- spTransform(SA_2019, CRS(proj4string(stack_20190114_cal)))

#getSpatialData#


login_USGS(username = "JayDXQ")

set_archive("Landsat")


####################### Data of 2015 ####################### 

set_aoi(SA_2015)
view_aoi()

#date of dam breach was October 11, 2015, so we are searching fo one image beforehand and one afterwards:
records2015 <- getLandsat_query(time_range = c("2015-10-01", "2015-11-30"), 
                                platform = "Landsat-8")

View(records2015)

getLandsat_preview(record=records2015[10,])
getLandsat_preview(record=records2015[14,])

datasets2015 <- getLandsat_data(records = records2015[c(10,14), ], level="l1")


####################### Data of 2019 ####################### 

set_aoi(SA_2019)
view_aoi()

#date of dam breach was January 25, 2019, so we are searching fo one image beforehand and one afterwards:
records2019 <- getLandsat_query(time_range = c("2019-01-01", "2019-01-30"), 
                                platform = "Landsat-8")

View(records2019)

getLandsat_preview(record=records2019[3,])
getLandsat_preview(record=records2010[4,])

datasets2019 <- getLandsat_data(records = records2019[c(3,4), ], level="l1")


####################### preparing the landsat scenes ####################### 

#load the original downloaded landsat 8 scenes via addressing the metadatafile (*MTL.txt):
meta_20151011 <- readMeta("Landsat/get_data/LANDSAT/L1/LC08_L1TP_217074_20151011_20170403_01_T1_L1/LC08_L1TP_217074_20151011_20170403_01_T1_MTL.txt")
meta_20151112 <- readMeta("Landsat/get_data/LANDSAT/L1/LC08_L1TP_217074_20151112_20170402_01_T1_L1/LC08_L1TP_217074_20151112_20170402_01_T1_MTL.txt")
meta_20190114 <- readMeta("Landsat/get_data/LANDSAT/L1/LC08_L1TP_218074_20190114_20190131_01_T1_L1/LC08_L1TP_218074_20190114_20190131_01_T1_MTL.txt")
meta_20190130 <- readMeta("Landsat/get_data/LANDSAT/L1/LC08_L1TP_218074_20190130_20190206_01_T1_L1/LC08_L1TP_218074_20190130_20190206_01_T1_MTL.txt")

#look at the structure and content of the data:
meta_20151011

#We don't want to address every single band/file while processing for every step, so we
#create a layer stack from the bands to make processing faster:

stack_20151011 <- stackMeta(meta_20151011)
stack_20151112 <- stackMeta(meta_20151112)
stack_20190114 <- stackMeta(meta_20190114)
stack_20190130 <- stackMeta(meta_20190130)

#look at the data again, the structure has changed:
stack_20151011

