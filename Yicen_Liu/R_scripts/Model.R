setwd("C:/Users/liuyi/OneDrive/xuexi2/628/yelp/Yicen_Liu/data/")
library(dplyr)
library(tidytext)
library(tm)
library(stringr)
library(xgboost)
library(readr)
library(stringr)
library(caret)

#### Data preprocessing
reviews=read.csv("pizza_review2.csv")[,-c(1,11:14)]
reviews$text=as.character(reviews$text)
reviews=reviews[-which(reviews$text==""),]


yelp_text_tbl <- tbl_df(data.frame(uniqueID = 1:20000,reviews[1:20000,]))
yelp_text_tbl_words <- yelp_text_tbl %>% select(uniqueID,text) %>%
  unnest_tokens(word, text) %>% filter(str_detect(word,"^[a-z']+$")) %>%
  group_by(uniqueID) %>% count(word) 
ReviewWordMatrix <- yelp_text_tbl_words %>% cast_dtm(uniqueID, word, n)
R1=as.matrix(ReviewWordMatrix)
dim(R1)
ss1=apply(R1,2,sum)
R1=R1[,-which(ss1<100)]



yelp_text_tbl <- tbl_df(data.frame(uniqueID = 20001:40000,reviews[20001:40000,]))
yelp_text_tbl_words <- yelp_text_tbl %>% select(uniqueID,text) %>%
  unnest_tokens(word, text) %>% filter(str_detect(word,"^[a-z']+$")) %>%
  group_by(uniqueID) %>% count(word) 
ReviewWordMatrix <- yelp_text_tbl_words %>% cast_dtm(uniqueID, word, n)
R2=as.matrix(ReviewWordMatrix)
dim(R2)
ss2=apply(R2,2,sum)
R2=R2[,-which(ss2<100)]



yelp_text_tbl <- tbl_df(data.frame(uniqueID = 40001:67152,reviews[40001:67152,]))
yelp_text_tbl_words <- yelp_text_tbl %>% select(uniqueID,text) %>%
  unnest_tokens(word, text) %>% filter(str_detect(word,"^[a-z']+$")) %>%
  group_by(uniqueID) %>% count(word) 
ReviewWordMatrix <- yelp_text_tbl_words %>% cast_dtm(uniqueID, word, n)
R3=as.matrix(ReviewWordMatrix)
dim(R3)
ss3=apply(R3,2,sum)
R3=R3[,-which(ss3<100)]

save(R1,file="R1.Rdata")
save(R2,file="R1.Rdata")
save(R3,file="R1.Rdata")

names1=colnames(R1)
names2=colnames(R2)
names3=colnames(R3)
variables=intersect(names1,names2)%>%intersect(names3)

r1=R1[,names1%in%variables]
r2=R2[,names2%in%variables]
r3=R3[,names3%in%variables]

na1=colnames(r1)
na2=colnames(r2)
na3=colnames(r3)

co=c()
nc=ncol(r1)
for(i in 1:nc){
  co[i]=which(na1==na2[i])
}

r2.co=matrix(0,nrow = nrow(r2),ncol = ncol(r2))

for( i in 1:nc){
  r2.co[,co[i]]=r2[,i]
}

co=c()
for(i in 1:nc){
  co[i]=which(na1==na3[i])
}

r3.co=matrix(0,nrow = nrow(r3),ncol = ncol(r3))

for( i in 1:nc){
  r3.co[,co[i]]=r3[,i]
}

y=cbind(stars=reviews$stars,rbind(r1,r2.co,r3.co))
save(y,file="y.Rdata")

#### Modeling
gb <- xgboost(data = as.matrix(y[,-1]),
              label = y[,1], 
              booster="gblinear",
              nround=200,
              eval_metric = "rmse",
              
)
importance_matrix <- xgb.importance(variables, model =gb)
xgb.ggplot.importance(importance_matrix,top_n=20)

