# R setup
library("sand")
library("corrplot")

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
     layout=layout.kamada.kawai, vertex.size=dine.size,vertex.color="blue",
     edge.width=dine.wt)
dine.central <- degree(dine,normalized=TRUE)
dine.central
dine.eigen<-evcent(dine)$vector
dine.eigen
dine.adj <- get.adjacency(dine, sparse=FALSE)
dine.closeness<-closeness(dine)
dine.closeness
dine.bwn<-betweenness(dine)
dine.bwn
dine.prank<-page.rank(dine)
dine.pagerank<-dine.prank$vector
dine.bonpow1<- bonpow(dine,exponent=0.75) 
dine.bonpow1
dine.bonpow2<- bonpow(dine,exponent=-1) 
dine.bonpow2

dine.centraldf<-cbind(dine.central,dine.eigen,dine.closeness,dine.bwn,dine.pagerank,dine.bonpow1,dine.bonpow2)
dine.centraldf
dine.cor<-cor(dine.centraldf)
corrplot.mixed(dine.cor)

par(mfrow=c(2,2))
plot(dine, vertex.label=V(dine)$id, edge.arrow.size=0.6, 
     layout=layout.kamada.kawai, vertex.size=dine.central,main="Degree Centrality")
plot(dine, vertex.label=V(dine)$id, edge.arrow.size=0.6, 
     layout=layout.kamada.kawai, vertex.size=dine.bonpow2,main="Bonacich Centrality")
par(mfrow=c(1,1))

#Pt 10 - Bonacich's centrality idea fundamentally conflicts with all other centrality measures.
# As per definitiion the more vertices a vertex is connected to, the more influential a vertex can be.
#In worst case scenario, there can be many vertices which are isolated but are connected to only this vertex.


#Part2
cities <- read.graph("cities.net", format="pajek")
V(cities)$id
is.bipartite(cities)

cities.city <- bipartite.projection(cities, which="false")
cities.Other <- bipartite.projection(cities, which="true")
cities.city
V(cities.Other)$id

plot(cities.city, vertex.label=V(cities.city)$id,
     layout=layout.kamada.kawai)
hist(E(cities.city)$weight)
E(cities.city)$weight

remove.edges <- function (g, val) {
  toremove <-delete.edges(g, which(E(cities.city)$weight<val));
  toremove
}

cities.city1<-remove.edges(cities.city,28)
plot(cities.city1)

city.strng <- degree(cities.city1)
city.strng
remove.singletons <- function (g, val) {
  toremove <-delete.vertices(g, which(city.strng<val));
  toremove
}
cities.city1<-remove.singletons(cities.city1,1)
plot(cities.city1)
E(cities.city1)$weight
cities.city1<-set.edge.attribute(cities.city1,"weight",value=1.0)
E(cities.city1)$weight
cities.city1.closeness<-closeness(cities.city1,normalized=TRUE)

V(cities.city1)$id
cities.city1<-delete.vertices(cities.city1, which(cities.city1.closeness>=1.0000000))
V(cities.city1)$id
plot(cities.city1)
cities.city1.strng<-graph.strength(cities.city1)
cities.city1<-delete.vertices(cities.city1, which(cities.city1.strng<1))
plot(cities.city1)

cities.city1.strng<-graph.strength(cities.city1)
cities.city1.strng
plot(cities.city1, vertex.size=degree(cities.city1),vertex.label=V(cities.city1)$id, edge.arrow.size=0.2,layout=layout.kamada.kawai)

cities.city1.central <- degree(cities.city1,normalized=TRUE)
cities.city1.central
cities.city1.closeness<-closeness(cities.city1,normalized=TRUE)
cities.city1.closeness
cities.city1.bwn<-betweenness(cities.city1,normalized=TRUE)
cities.city1.bwn

cities.city1.central[order(-cities.city1.central)]
cities.city1.closeness[order(-cities.city1.closeness)]
cities.city1.bwn[order(-cities.city1.bwn)]

sortcentre<-sort.list(cities.city1.central,decreasing=TRUE)[1:8]
sortclose<-sort.list(cities.city1.closeness,decreasing=TRUE)[1:8]
sortbwn<-sort.list(cities.city1.bwn,decreasing=TRUE)[1:8]


cities.list<-V(cities.city1)$id

cities.centrallist<-cities.list[sortcentre]
cities.centralvalue<- cities.city1.central[sortcentre]
sortcentredf<-cbind(cities.centrallist,cities.centralvalue)
sortcentredf

cities.bwnlist<-cities.list[sortbwn]
cities.bwnvalue<- cities.city1.bwn[sortbwn]
sortbwndf<-cbind(cities.bwnlist,cities.bwnvalue)
sortbwndf

cities.clslist<-cities.list[sortclose]
cities.clsvalue<- cities.city1.bwn[sortclose]
sortclosedf<-cbind(cities.clslist,cities.clsvalue)
sortclosedf

par(mfrow=c(2,2))

frankfurt.neighbors<-graph.neighborhood(cities.city1,1, 3)[[1]]
plot(frankfurt.neighbors,vertex.label=V(frankfurt.neighbors)$id,main="Frankfurt")

milan.neighbors<-graph.neighborhood(cities.city1,1, 7)[[1]]
plot(milan.neighbors,vertex.label=V(milan.neighbors)$id,main="Milan")

singapore.neighbors<-graph.neighborhood(cities.city1,1, 10)[[1]]
plot(singapore.neighbors,vertex.label=V(singapore.neighbors)$id,main="Singapore")

tokyo.neighbors<-graph.neighborhood(cities.city1,1, 12)[[1]]
plot(tokyo.neighbors,vertex.label=V(tokyo.neighbors)$id,main="Tokyo")

par(mfrow=c(1,1))

#Pt 30 - The possible reason could be the geographic placement of 
#singapore and tokyo in the netowrk and by definition of betweenness
# where the calculation involves the ration of total number of permutations of 
# the paths between any two vertices through a specific vertex to the 
#total number of permutations of the paths between those two vertices.
# Though this applies to all the afore mentioned cities, the mathematical 
#impact is felt on the singapore and tokyo.