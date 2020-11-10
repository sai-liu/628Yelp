library(ggplot2)

setwd("C:/Users/liuyi/OneDrive/xuexi2/628/yelp/data/")
bussiness=read.csv("pizza_business.csv")
Alcohol=bussiness[which(bussiness$Alcohol!=""),c(8,11)]
boxp=ggplot(data=Alcohol,mapping = aes(x=Alcohol,y=stars))
boxp+geom_boxplot()

wifi=bussiness[which(bussiness$WiFi!=""),c(8,which(colnames(bussiness)=="WiFi"))]
boxp_wifi=ggplot(data=wifi,mapping = aes(x=WiFi,y=stars))
boxp_wifi+geom_boxplot()
