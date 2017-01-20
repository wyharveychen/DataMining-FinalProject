##################
# Library
####################

# Library used in kaggle preprocessing
library(data.table)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(corrplot)
source("VisAttrDistributionFuncs.R")
###############################
# Load file and preprocessing
###############################

# load kaggle parsed data (df)
setwd('/home/chuna/DataMining/FinalProject')
load('parsed_input.RData')
feature_table = read.csv("feature_table.csv",header = FALSE,as.is = TRUE)
names(feature_table) = c("attr","mean")

sub_df = subset(df, select = c('ncodpers','sexo','age','renta','antiguedad','total.services'))
sub_df = df
sub_df$feature = factor(df$feature, levels = feature_table$attr )
levels(sub_df$feature) = feature_table$mean

sub_df$status = factor(df$status,levels = c('Dropped','Added'))

###############################
# Composition of data
###############################

# 1. Attributed
    #a. User only
    #b. User x bank

# 2. Fearuee
###############################
# Show basic data distribution
###############################

#1. Income distribution

  #Remark: Income is 4 times than average => adjusted

#2. Age distribution
 
  #Two peaks: Similar to human population

#3. Map

#############################################
# Show relation between user and bought item
############################################

user_item = sub_df %>% 
  subset(select = c('ncodpers','sexo','age','renta','antiguedad','feature'))%>%
  group_by(ncodpers,feature) %>%
  filter(row_number()==n())%>%
  ungroup() 

user_attr = sub_df %>% 
  subset(select = c('ncodpers','sexo','age','antiguedad','renta'))%>%
  group_by(ncodpers) %>%
  filter(row_number()==n())%>%
  ungroup() 

onehot_user_item = user_item %>% 
  subset(select = c('ncodpers','feature'))
one_hot_item = as.data.frame(with(onehot_user_item, model.matrix(~feature+0)))
onehot_user_item = cbind(subset(onehot_user_item, select = 'ncodpers'),one_hot_item )
onehot_user_item = aggregate(. ~ ncodpers, onehot_user_item, sum )
onehot_user_attr_item= user_attr  %>% 
                      inner_join(onehot_user_item, by = "ncodpers") %>%
                      mutate(sexo = (sexo == 'H'))

#1. Correlation between them
corrplot(cor(onehot_user_attr_item %>% subset(select = -ncodpers)) , method = "circle",tl.cex = 0.4)

#2. Income x item
ExistedIncomeFeatureRatioPlot(user_attr,user_item);
ggsave('visualization/item_ratio_income.png', width = 16, height = 9, units = "in")                      

#3. Age x item
ExistedAgeFeatureRatioPlot(user_attr,user_item);
ggsave('visualization/item_ratio_age.png', width = 16, height = 9, units = "in")   

#4. Holding time x item
ExistedHoldFeatureRatioPlot(user_attr,user_item);
ggsave('visualization/item_ratio_holding_time.png', width = 16, height = 9, units = "in")   

###############################
# Show relation between user and item change
###############################
#Use code in script.Rmd 

#AgeFeatureRatioPlot(sub_df)
#ggsave('visualization/age_feature_ratio.png', width = 12, height = 6, units = "in")

#AgeFeatureCountPlot(sub_df)
#ggsave('visualization/age_feature_count.png', width = 12, height = 6, units = "in")


