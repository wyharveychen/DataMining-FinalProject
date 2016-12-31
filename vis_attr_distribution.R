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


#sub_df = subset(df, select = c('ncodpers','sexo','age','renta','antiguedad','total.services'))
sub_df = df
sub_df$feature = factor(df$feature, levels = feature_table$attr )
levels(sub_df$feature) = feature_table$mean
#c('saving account','guarantees','current account','deriviada account','payroll account','junior account',
#  'mas particular acccount','particular account','particular plus account','short-term deposits','long-term deposits','medium-term deposits',
#  'e-account','funds','mortage', 'payroll','pensions','pensions','loans','taxes','direct debit',
#  'credit card','securities','home account')
sub_df$status = factor(df$status,levels = c('Dropped','Added'))

user_item = sub_df %>% 
  subset(select = c('ncodpers','sexo','age','renta','feature'))%>%
  group_by(ncodpers,feature) %>%
  filter(row_number()==n())%>%
  ungroup() 

user_attr = sub_df %>% 
  subset(select = c('ncodpers','sexo','age','renta'))%>%
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
                      
  
###############################
# Plot images
###############################
png('visualization/attr_feature_corr.png', width = 600, height = 600)
corrplot(cor(onehot_user_attr_item %>% subset(select = -ncodpers)) , method = "circle",tl.cex = 0.4)
dev.off()


AgeFeatureRatioPlot(sub_df)
ggsave('visualization/age_feature_ratio.png', width = 12, height = 6, units = "in")

AgeFeatureCountPlot(sub_df)
ggsave('visualization/age_feature_count.png', width = 12, height = 6, units = "in")

ExistedIncomeFeatureRatioPlot(user_attr,user_item);
ggsave('visualization/income_feature_ratio.png', width = 12, height = 6, units = "in")
