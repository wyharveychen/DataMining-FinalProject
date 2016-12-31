TF = function(x, target){
  2*(x == target)-1
}

AgeDistribution = function(df){
  income_age <- sub_df %>%
    group_by(ncodpers) %>%
    summarise(mean(renta))%>%
    rename(income = `mean(renta)`)
  hist(income_age$income)
}

MyCountTheme = function(ggobj,title){
  ggobj +  facet_wrap(facets=~feature,ncol = 6) +
    coord_flip() +
    my_theme_dark + 
    ylab("Count") +
    xlab("") + 
    ggtitle(title) +
    theme(axis.text    = element_text(size=10),
          legend.text  = element_text(size=14),
          legend.title = element_blank()      ,
          strip.text   = element_text(face="bold"))
    #scale_fill_manual(values=c("cyan","magenta"))
    
  
}

########################
# Age Related
#######################
AgeFeaturePlot = function(df){
  totals.by.feature <- df %>%
    group_by(age,feature) %>%
    summarise(counts=n())  
  ggobj = df %>% 
    group_by(age,feature,status) %>%
    summarise(counts=n())%>%
    ungroup() %>%
    inner_join(totals.by.feature,by=c("age","feature")) %>%
    
    mutate(counts=counts.x/counts.y) %>%
    #mutate(counts=counts/month.count) %>%
    ggplot(aes(y=counts,x=age)) +
    geom_bar(aes(fill=status), stat="identity") 
  
  MyCountTheme(ggobj, "Service Ratio \nChanges by Age")
}

AgeFeatureCountPlot = function(df){
  all_df = df %>% 
    group_by(age,feature,status) %>%
    summarise(counts=n())%>%
    ungroup() %>%
    mutate(counts=counts* TF(status,'Added'))
  
  p_df  = all_df %>% subset(status == 'Added')
  n_df  = all_df %>% subset(status == 'Dropped')
  
  ggobj = ggplot() +
    geom_bar(data = n_df,aes(y=counts,x=age, fill=status), stat="identity") +
    geom_bar(data = p_df,aes(y=counts,x=age, fill=status), stat="identity") +
    scale_fill_manual(values = c("Added" = "magenta", "Dropped" = "cyan", "magenta"))
  #  scale_fill_manual(values = c("Added" = "pink", "Dropped" = "blue"))
  
  #    geom_bar(data = all_df,aes(y=counts,x=age, fill=status), alpha = 0.8, stat="identity", position = "identity") +
  
  MyCountTheme(ggobj, "Service count \nChanges by Age")
}
AgeFeatureRatioPlot = function(df){
  all_df = df %>% 
    group_by(age,feature,status) %>%
    summarise(counts=n())%>%
    ungroup() 

  ggobj = ggplot() +
    geom_bar(data = all_df,aes(y=counts,x=age, fill=status), stat="identity", position = "fill") +
    scale_fill_manual(values = c("Added" = "magenta", "Dropped" = "cyan", "magenta"))

  MyCountTheme(ggobj, "Service ratio \nChanges by Age")
}

ExistedAgeFeatureRatioPlot = function(user_attr,user_item){
  attr_df = user_attr  %>% 
    group_by(age) %>%
    summarise(counts=n())%>%
    ungroup()
  
  item_df = user_item  %>% 
    group_by(age,feature) %>%
    summarise(counts=n())%>%
    ungroup() %>%
    inner_join(attr_df,by=c("age")) %>%
    mutate(counts = counts.x/counts.y)
  
  ggobj = ggplot() +
    geom_bar(data = item_df,aes(y=counts,x=age, fill = "red"), stat="identity")  
  MyCountTheme(ggobj, "Item Ratio \nChanges by Ages")
}




IncomeFeatureCountPlot = function(df){
  all_df = df %>% 
  mutate(renta = pmin(floor(renta/5e4),10)) %>%
  group_by(renta,feature,status) %>%
  summarise(counts=n())%>%
  ungroup() %>%
  mutate(counts=counts* TF(status,'Added'))
  
  p_df  = all_df %>% subset(status == 'Added')
  n_df  = all_df %>% subset(status == 'Dropped')
  
  ggobj = ggplot() +
    geom_bar(data = n_df,aes(y=counts,x=renta, fill=status), stat="identity") +
    geom_bar(data = p_df,aes(y=counts,x=renta, fill=status), stat="identity") +
    scale_fill_manual(values = c("Added" = "magenta", "Dropped" = "cyan", "magenta"))
  
  MyCountTheme(ggobj, "Service count \nChanges by Income")
}
IncomeFeatureRatioPlot = function(df){
  all_df = df %>% 
    mutate(renta = pmin(floor(renta/5e4),10)) %>%
    group_by(renta,feature,status) %>%
    summarise(counts=n())%>%
    ungroup() 
  
  ggobj = ggplot() +
    geom_bar(data = all_df,aes(y=counts,x=renta, fill=status), stat="identity", position = "fill") +  
    scale_fill_manual(values = c("Added" = "magenta", "Dropped" = "cyan", "magenta"))
  
  MyCountTheme(ggobj, "Service ratio \nChanges by Income")
}

ExistedIncomeFeatureRatioPlot = function(user_attr,user_item){
  attr_df = user_attr  %>% 
    mutate(renta = pmin(floor(renta/5e4),30)) %>%
    group_by(renta) %>%
    summarise(counts=n())%>%
    ungroup()
  
  item_df = user_item  %>% 
    mutate(renta = pmin(floor(renta/5e4),30)) %>%
    group_by(renta,feature) %>%
    summarise(counts=n())%>%
    ungroup() %>%
    inner_join(attr_df,by=c("renta")) %>%
    mutate(counts = counts.x/counts.y)
  
  ggobj = ggplot() +
    geom_bar(data = item_df,aes(y=counts,x=renta), stat="identity")  
  MyCountTheme(ggobj, "Service ratio \nChanges by Income")
}

