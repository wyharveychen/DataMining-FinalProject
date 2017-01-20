##################
# Library
####################

# Library used in kaggle preprocessing
library(data.table)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

###############################https://docs.google.com/spreadsheets/d/1CFD6HrOl-aY5mxljO7ExNxpRgqrwaXF1D2mxOfy3GrY/edit?usp=sharing
# Load file and preprocessing
###############################

# load kaggle parsed data (df)
setwd('/home/chuna/DataMining/FinalProject')
load('parsed_input.RData')

sub_df = subset(df, select = c('fecha_dato','ncodpers','month.id','sexo','age','renta','antiguedad' ,'feature','status'))
sub_df = sub_df[order(sub_df$month.id),]
sub_df = sub_df[order(sub_df$ncodpers),]
sub_df = sub_df %>% 
         mutate(age = floor(age/10)*10) %>%
         mutate(renta = pmin(floor(renta/5e4),10)) %>%
        mutate(antiguedad = floor(antiguedad/24)*2)
write.csv(sub_df, file = 'cleared_data.csv');
