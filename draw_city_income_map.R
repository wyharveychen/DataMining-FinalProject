##################
# Library
####################

# Library used in kaggle preprocessing
library(data.table)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
# Library used in Spain map practicing
library(sp)
library(maptools)
library(grid)
# Library used in London map drawing
library(maptools)
library(RColorBrewer)
library(classInt)

###############################
# Load file and preprocessing
###############################

# load kaggle parsed data (df)
setwd('/home/chuna/DataMining/FinalProject')
load('parsed_input.RData')

# load spain province map
setwd('/home/chuna/DataMining/FinalProject/map/Spain_example')
provinces <- readShapePoly(fn="spain_provinces_ag_2")

# process spain map
english_pr_list = sort(unique(df$nomprov))
spain_to_eng_map = c(2,3,4,5,7,8,9,11,14,15,12,13,16,17,17,18,20,22,23,24,21,25,26,27,1,28:31,33,32,34:48,50,51,6,10,52,53,49)
levels(provinces$NOMBRE99) = english_pr_list[spain_to_eng_map]  #processed map

income_table = df %>%
  filter(!is.na(renta)) %>%
  group_by(nomprov) %>%
  summarise(med.income = median(renta)) %>%
  arrange(med.income)
 
sorted_income_table = income_table[order(income_table$nomprov),]
spain_sort_income_table = sorted_income_table[spain_to_eng_map,]

block_to_province_map = as.numeric(provinces$NOMBRE99)
block_to_province_map[is.na(block_to_province_map)] = 53 #unknown,NA
spain_sort_income_table$med.income[spain_to_eng_map]
mapped_income = spain_sort_income_table$med.income[block_to_province_map]

############################
# draw income
#############################
setwd('/home/chuna/DataMining/FinalProject')
colours <- brewer.pal(5,"Blues")
brks<-c(70000,90000,110000,130000)
brks<-classIntervals(mapped_income, n=5, style="quantile")
brks<- brks$brks

jpeg('visualization/income_map.jpg')
plot(provinces, col=colours[ findInterval(mapped_income, brks,  all.inside=TRUE)], axes=T)
##a border
box()
## a title:
title(paste ("Spain City Income"))
## a north arrow:
SpatialPolygonsRescale(layout.north.arrow(1), offset= c(-3e5,4e6), scale = 300000,
                       plot.grid=F)
## a legend
legend(x=6e5, y=4e6, legend=leglabs(brks), fill=colours, bty="n")
## a scale bar:
#SpatialPolygonsRescale(layout.scale.bar(), offset= c(503800,154800), scale= 10000, fill=
#                         c("transparent", "black"), plot.grid= F)
## and some annotations:
#text(509000, 153500, "10KM", cex= 1)
text(1e6,4e6, "Income distribution", cex= 1)
text(556500, 166000, "% Participation", cex= 1)
dev.off()
