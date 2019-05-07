########################################################################################################################################################
############################### Get OSM Data ###########################################################################################################
########################################################################################################################################################


################### For municipality Mariana ###################

#All osmdata queries begin with a bounding box/in this case bounding polygon defining the area of the query
#The getbb() function can be used to extract bounding boxes for specified place names

Mariana <- getbb ("Mariana", format_out = "polygon")
class (Mariana); head (Mariana [[1]])

#Overpass API queries can be built from a base query constructed with opq() followed by add_osm_feature
#The corresponding OSM objects are then downloaded and converted to R Simple Features (sf)

Mariana_Buildings <- opq ("Mariana") %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()
Mariana_Highways <- opq("Mariana") %>%
  add_osm_feature(key="highway") %>%
  osmdata_sf()

Mariana_Buildings
Mariana_Highways

Mariana_Buidings_Highways <- c(Mariana_Buildings, Mariana_Highways)
Mariana_Buidings_Highways
summary(Mariana_Buidings_Highways)

plot(Mariana_Buidings_Highways$osm_polygons)


################### For municipality Barra Longa ###################

BarraLonga <- getbb ("Barra Longa", format_out = "polygon")
class (BarraLonga); head (BarraLonga [[1]])

BarraLonga_Buildings <- opq ("Barra Longa") %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()
BarraLonga_Highways <- opq("Barra Longa") %>%
  add_osm_feature(key="highway") %>%
  osmdata_sf()

BarraLonga_Buildings
BarraLonga_Highways

BarraLonga_Buildings_Highways <- c(BarraLonga_Buildings, BarraLonga_Highways)
BarraLonga_Buildings_Highways
summary(BarraLonga_Buildings_Highways)


################### For municipality Brumadinho ###################

Brumadinho <- getbb ("Brumadinho", format_out = "polygon")
class (Brumadinho); head (Brumadinho [[1]])

Brumadinho_Buildings <- opq ("Brumadinho") %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()
Brumadinho_Highways <- opq("Brumadinho") %>%
  add_osm_feature(key="highway") %>%
  osmdata_sf()

Brumadinho_Buildings
Brumadinho_Highways

Brumadinho_Buildings_Highways <- c(Brumadinho_Buildings, Brumadinho_Highways)
Brumadinho_Buildings_Highways
summary(Brumadinho_Buildings_Highways)

