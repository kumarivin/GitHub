# R setup
library("sand")
library("corrplot")
#library("network")
#library("sna")


# 2 Data file location
setwd("C:/Users/TG/OneDrive/Documents/CSC 495/hwk3/hwk3")
dine<-read.graph('dining.net',format='pajek')
dine
dine.size<-degree(dine)* 2 + 5
dine.edwt<-E(dine)$weight
dine.wt <- 4 / (E(dine)$weight*E(dine)$weight)
xc <- V(dine)$"x"*2.0
yc <- V(dine)$"y"*2.0
# Put X and y coordinates together into a coordinate matrix.
mcoord <- cbind(xc, yc)
dine.un <- as.undirected(dine, mode="collapse",edge.attr.comb="ignore")
dine.com <- walktrap.community(dine.un)
dine.com
# Get the membership vector
dine.vec <- dine.com$membership
# Use it to color the vertices
plot(dine, vertex.label=V(dine)$id, edge.arrow.size=0.6, 
     layout=mcoord, vertex.size=dine.size,vertex.color=dine.vec+1,
     edge.width=dine.wt)
dine.central <- degree(dine,normalized=TRUE)
dine.central
dine.eigen<-evcent(dine)$vector
dine.eigens<-dine.eigen$values
dine.eigens
dine.adj <- get.adjacency(dine, sparse=FALSE)
dine.closeness<-closeness(dine.adj)
dine.closeness
dine.bwn<-betweenness(dine.adj)
dine.bwn
dine.prank<-page.rank(dine)
dine.pagerank<-dine.prank$vector
dine.bonpow1<- bonpow(dine.adj,exponent=0.75) 
dine.bonpow1
dine.bonpow2<- bonpow(dine.adj,exponent=-1) 
dine.bonpow2

dine.centraldf<-cbind(dine.central,dine.eigens,dine.closeness,dine.bwn,dine.pagerank,dine.bonpow1,dine.bonpow2)
dine.centraldf
dine.cor<-cor(dine.centraldf)
corrplot.mixed(dine.cor)

par(mfrow=c(2,2))
plot(dine, vertex.label=V(dine)$id, edge.arrow.size=0.6, 
     layout=mcoord, vertex.size=dine.central*2+5)
plot(dine, vertex.label=V(dine)$id, edge.arrow.size=0.6, 
     layout=mcoord, vertex.size=dine.bonpow2*2+5)
par(mfrow=c(1,1))

