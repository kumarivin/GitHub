# Import our libraries
#install.packages("sand")
library(sand)
library(corrplot)
library(ngram)
library(network)
library(lattice)
library(latticeExtra)
library(ergm)
library(intergraph)

# Loading the data
# Set the path correctly
setwd("C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject")

# Load the edges
project.citiesToCities <- read.csv("C2C-E1.csv", head=TRUE, sep=",")
project.citiesToCitiesPass <- read.csv("C2CP-E1.csv", head=TRUE, sep=",")

# Load the attributes
project.citiesToCitiesVertex <- read.csv("C2C-V2.csv", head=TRUE, sep=",")
project.citiesToCitiesPassVertex <- read.csv("C2CP-V1.csv", head=TRUE, sep=",")

#Cities to cities network(Routes and distance)
citiesToCities.edge <- data.frame(project.citiesToCities$departure.city, 
                                  project.citiesToCities$arrival.city, 
                                  project.citiesToCities$number.of.routes,
                                  project.citiesToCities$distance)

citiesToCities.net <- graph.data.frame(citiesToCities.edge, directed=TRUE, vertices=project.citiesToCitiesVertex)
assortativity.nominal (citiesToCities.net, types=project.citiesToCitiesVertex$Continent, directed = TRUE)


citiesToCities.net <- graph.data.frame(citiesToCities.edge, directed=TRUE, vertices=project.citiesToCitiesVertex)

#Calculate centrality measures
#average.shortest.path
average.path.length(citiesToCities.net, directed=TRUE, unconnected=TRUE)

#degree centrality
DC <- degree(citiesToCities.net, normalized=TRUE)
DC1<-data.frame(DC[1:1083])
DC2<-DC1[1:1083,1]
#weighted degree centrality
SC <- graph.strength(citiesToCities.net)
SC1 <- SC/max(SC)
SC1<-data.frame(SC[1:1083])
SC2<-SC1[1:1083,1]
SC2<-as.integer(SC2)
#closeness centrality
CC <- closeness(citiesToCities.net, normalized=TRUE, weights=NULL)
CC1<-data.frame(CC[1:1083])
CC2<-CC1[1:1083,1]
#betweenness centrality
BC <- betweenness(citiesToCities.net, normalized=TRUE, weights=NULL)
BC1<-data.frame(BC[1:1083])
BC2<-BC1[1:1083,1]
#eigenvector centrality
EC <- evcent(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector
EC1<-data.frame(EC[1:1083])
EC2<-EC1[1:1083,1]
#PageRank
PR <- page.rank(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector
PR1<-data.frame(PR[1:1083])
PR2<-PR1[1:1083,1]
project.citiesToCitiesVertex1 <- data.frame(project.citiesToCitiesVertex, 
                                            DC2, 
                                            SC2, 
                                            CC2, 
                                            BC2, 
                                            EC2, 
                                            PR2)

citiesToCities.net1 <- graph.data.frame(citiesToCities.edge, directed=TRUE, vertices=project.citiesToCitiesVertex1)

citiesToCities.net.btw$membership<-edge.betweenness.community(citiesToCities.net)
citiesToCities.net.assort<-assortativity.nominal(citiesToCities.net,types=membership(citiesToCities.net.btw))

citiesToCities.net.wlktrp<-  walktrap.community(citiesToCities.net,steps=6, weight=E(citiesToCities.net)$project.citiesToCities.number.of.routes)
citiesToCities.net.wlkassort<-assortativity.nominal(citiesToCities.net,types=membership(citiesToCities.net.wlktrp))

# Assorativity 
x=c("NorthAmerica","Africa", "Oceania","Europe", "Asia" ,"SouthAmerica")
length(x)
gramcontinents<-""
gramcontinentsarr<-"" #paste("contcomb",1:length(x),sep="_")
for (i in 1:length(x)){
  grmsplit<-strsplit(x[i]," ")[[1]] 
  firsbool<-(project.citiesToCitiesVertex$Continent==grmsplit[1])
  #secnbool<-(project.citiesToCitiesVertex$Continent==grmsplit[2])
  #thirdbool<-(project.citiesToCitiesVertex$Continent==grmsplit[3])
  #fourthbool<-(project.citiesToCitiesVertex$Continent==grmsplit[4])
  #fifthbool<-(project.citiesToCitiesVertex$Continent==grmsplit[5])
  #finalbool
  #for (i in 1:length(firsbool)){
    #finalbool[i]<-firsbool[i]||secnbool[i]||thirdbool[i]||fourthbool[i] ||fifthbool[i]
  #}
  gramcontinents<- induced.subgraph(citiesToCities.net, which(firsbool))  
  gc<-paste(grmsplit[1],sep="_")
  name<-paste("C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/eachcontinent",gc,sep="_")
  namef<-paste(name,".gml")
  write.graph(gramcontinents, namef, format="gml")
  #plot(gramcontinents)  
}

cont3 <- read.graph("3continent_Asia_Oceania_Africa.gml",format="gml") 
average.path.length(cont3, directed=TRUE, unconnected=TRUE)
DC <- degree(cont3, normalized=TRUE)
SC <- graph.strength(cont3)
CC <- closeness(cont3, normalized=TRUE, weights=NULL)
BC <- betweenness(cont3, normalized=TRUE, weights=NULL)

#PageRank
plot(cont3)
ContinentID<- 1:length(V(cont3))
singulars<-unique(V(cont3)$Continent)
for (i in 1:length(singulars)){
  ContinentID[which(V(cont3)$Continent==singulars[i])]<-i    
}

ContinentID[which(V(cont3)$Continent=="Oceania")]<-3
assortativity.nominal(cont3,types=ContinentID)



citiesToCities.network <-asNetwork(citiesToCities.net)
citiesToCities.ergm<-ergm(citiesToCities.network ~ edges)
summary(citiesToCities.ergm)

V(citiesToCities.net1)$SC2

citiesToCities.network1 <-asNetwork(citiesToCities.net1)
citiesToCities.ergm1<-ergm(citiesToCities.network ~ edges + nodecov(V(citiesToCities.net1)$SC2))
summary(citiesToCities.ergm)

