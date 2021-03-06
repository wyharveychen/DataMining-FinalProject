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

# load spain population
setwd('/home/chuna/DataMining/FinalProject')
population_map = read.csv('Province map population.csv')

# process spain map
english_pr_list = sort(unique(df$nomprov))
spain_to_eng_map = c(2,3,4,5,7,8,9,11,14,15,12,13,16,17,19,18,20,22,23,24,21,25,26,27,1,28:31,33,32,34:48,50,51,6,10,52,53,49)
levels(provinces$NOMBRE99) = english_pr_list[spain_to_eng_map]  #processed map

# map
block_to_province_map = as.numeric(provinces$NOMBRE99)
block_to_province_map[is.na(block_to_province_map)] = 53 #unknown,NA

#income_table = df %>%
#  filter(!is.na(renta)) %>%
#  group_by(nomprov) %>%
#  summarise(med.income = median(renta)) %>%
#  arrange(med.income)
 
#####Dirty... Use population instead of income######

usernum_table = df %>%
  group_by(nomprov) %>%
  summarise(usernum = n()) #%>%
  #arrange(med.income)

SpainSortAttr = function(attr_table){
  sorted_attr_table = attr_table[order(attr_table$nomprov),]
  spain_sort_attr_table = sorted_attr_table[spain_to_eng_map,]
}

mapped_usernum = SpainSortAttr(usernum_table)$usernum[block_to_province_map]
mapped_population = population_map$population[block_to_province_map]
mapped_userrate = mapped_usernum/mapped_population 
mapped_userrate[is.infinite(mapped_userrate)] = 0
#mapped_income = spain_sort_income_table$med.income[block_to_province_map]

############################
# draw income
#############################
setwd('/home/chuna/DataMining/FinalProject')
#brks<-c(70000,90000,110000,130000)
brks<-c(10,6250,12500,25000,50000,100000)
#brks<-classIntervals(mapped_income, n=5, style="quantile")
#brks<- brks$brks

Draw_map = function(attr,brks,title){
  colours <- brewer.pal(5,"Blues")
  #jpeg('visualization/income_map.jpg')
  jpeg(sprintf("visualization/%s.jpg",title) )
  
  plot(provinces, col=colours[ findInterval(attr, brks,  all.inside=TRUE)], axes=T)
  ##a border
  box()
  ## a title:
  title(paste (title))
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
  text(8e5,4e6, "Partition", cex= 1)
  text(556500, 166000, "% Participation", cex= 1)
  dev.off()
}

#Draw_map(mapped_usernum, c(10,6250,12500,25000,50000,100000), "Spain City Bank User");
Draw_map(mapped_usernum, classIntervals(mapped_usernum, n=5, style="quantile")$brks, "Spain City Bank User");
Draw_map(mapped_population , classIntervals(mapped_population, n=5, style="quantile")$brks, "Spain City Population");
Draw_map(mapped_userrate , classIntervals(mapped_userrate, n=5, style="quantile")$brks, "Spain City User Ratio");
