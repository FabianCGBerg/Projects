library(tidyverse)
library(osmdata)
library(ggplot2)

# in order to plot a map we need a bounding box that contains whatever city we want to display

# getbb gets the bounding box based on the city and country, but might not be perfect
BoundBox <- getbb("Maastricht Netherlands")


#or you can speify one yourself using the four direction point below
#use https://boundingbox.klokantech.com/ and set the copy/paste to dublin core for the exact same format

westlimit=-5.64; southlimit=-50.80; eastlimit=5.76; northlimit=-50.91

BoundBox <- array(c(westlimit, southlimit, eastlimit,northlimit), dim = c(2, 2)) 



# Now to select features!

# you can check out what sort of information OSM can load by looking at the various features
# Each feature also has tags associated with them that you can inspect

# OSM has a lot of features, so the wiki might be a good place to look too
# https://wiki.openstreetmap.org/wiki/Main_Page has a full list of features to use

available_features()
tags <- available_tags("waterway")


# Now to select the features I used for my maps!
# retrieving the features might take a while (especially with larger cities), so give it some time
# Ut might also fail, just try it again if it times out

# I selected Main streets, these are motorways, primary, secondary, and tertiary roads
# I want these to look different than the small streets, so they go into a different list
streets <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) %>%
  osmdata_sf()

# small streets are up next
small_streets <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified", "path", "pedestrian", "road", "cycleway",
                            "service", "footway")) %>%
  osmdata_sf()


# I also want to include the river that runs through the city, 
# but I don't want the smaller streams to be the same width as the main river
river <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

smallriver <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "waterway", value = c("stream")) %>%
  osmdata_sf()

# Then there are the lakes and other bodies of water that are not rivers
Lakes <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "natural", value = c("water")) %>%
  osmdata_sf()

# If you live in a wooded or green area, you might want to display those too
grasses <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "natural", value = c("woods", "grassland", "tree_row", "tree", "scrub")) %>%
  osmdata_sf()

grasses <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "landuse", value = c("forest", "meadow", "orchard")) %>%
  osmdata_sf()

# Some places also have rail systems, which you can get using the railway key
rails <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "railway", value = c("rail", "light_rail", "disused", "narrow_gauge",
                                             "user defined")) %>%
  osmdata_sf()


# If you are creating a map of a small town, it might look empty and the inclusion of houses isn't a bad idea
# Here are two ways to go about this:

# You can check the tags in the feature "building" and select the type you want
# I'd advice including the values "yes" and "user defined" since many buildings haven't been categorized in small towns
Houses <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "building", value = c("yes","user defined",  "apartments","bungalow","church","house","residential","semidetached_house"),
                  value_exact = FALSE) %>%
  osmdata_sf()

# You can also select everything that is not a certain value, like pavilion below
Houses <- BoundBox%>%
  opq()%>%
  add_osm_feature(key = "building", value = c("!pavilion"),
                  value_exact = FALSE) %>%
  osmdata_sf()


# Once you have your features selected, it's time to plot the map





# I use this to save a high res image, but preferable you save it as a pdf and edit it in Illustrator
# tiff("Map", units="cm", width=10, height=15, res=300)



# Below is my set-up for a Light themed plot
# Features such as rivers and roads can be plotted as lines
# Features such as lakes, grasses, and houses are plotted as polygons that can be colored in

# In this example I will plot most of these features for Maastricht, but in my opinion the city
# is too large for the details such as buildings, and the railway is too messy (see the examples for a better map)

# You'll also notice some tricks I used to get the maps to look nice.
# 1) the features are plotted in order, so if you plot the roads before the rivers, 
#    the river lines will go over the roads, which might look weird with bridges
# 2) you can plot the same features multiple times with different settings
#    I did this with the railways to get a line with dots on top

# The parameters can be tweaked to make your map look the way you want
#  - Color and Fill determines the color of the line and polygon. I can recommend coolors.co to experiment with colors
#  - Size determines the thickness of a line, what looks good depends on the size of your map
#  - Alpha is the transparancy, which I used to differentiate the bodies of water around the river from the river
#  - Linetype determines the type of line, such as dotted for the rails

# In the last section of GG-plot I remove the axes, the legends, the grid, and set the background color

ggplot() +
  geom_sf(data = river$osm_lines,
          inherit.aes = FALSE,
          color = "#88a5a8",
          size = 5,
          alpha = 1) +
  geom_sf(data = Lakes$osm_polygons,
          inherit.aes = FALSE,
          fill = "#88a5a8",
          color = "#88a5a8",
          size = .1,
          alpha = .3) +
  geom_sf(data = Houses$osm_polygons,
          inherit.aes = FALSE,
          fill = "#909090",
          color = "#909090",
          size = .2,
          alpha = .3) +
  geom_sf(data = rails$osm_lines,
          inherit.aes = FALSE,
          color = "#5c5c5c",
          size = .4,
          alpha = 1) +
  geom_sf(data = rails$osm_lines,
          inherit.aes = FALSE,
          color = "#5c5c5c",
          linetype = "dotted",
          size = .8,
          alpha = 1) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "#909090",
          size = .3,
          alpha = 1) +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "#282828",
          size = .4,
          alpha = 1) +
  coord_sf(xlim = c(BoundBox[1], BoundBox[3]), 
           ylim = c(BoundBox[2], BoundBox[4]),
           expand = FALSE) +
  theme(
    axis.line=element_blank(),axis.text.x=element_blank(),
    axis.text.y=element_blank(),axis.ticks=element_blank(),
    axis.title.x=element_blank(),
    axis.title.y=element_blank(),legend.position="none",
    panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    plot.background = element_rect(fill = "#ffffff")
  )

# That should be it. I prefer to export my graphs as PDFs and open them in Illustrator for that finishing touch (see the examples)

# This is the end part for saving as an image
#dev.off()

