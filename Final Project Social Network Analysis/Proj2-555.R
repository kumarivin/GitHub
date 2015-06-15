# Import our libraries
#install.packages("sand")
library(sand)
library(corrplot)
library(ngram)

# Loading the data
# Set the path correctly
setwd("C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject")

# Load the edges
DomainEdges <- read.csv("Edges-555.csv", head=TRUE, sep=",")


# Load the attributes
DomainNodes <- read.csv("Vertices-555.csv", head=TRUE, sep=",")


#Cities to cities network(Routes and distance)
DomainEdges.Frame <- data.frame(DomainEdges$Source, 
                                DomainEdges$Dest, 
                                DomainEdges$Count)

Domain.net <- graph.data.frame(DomainEdges.Frame, directed=TRUE, vertices=DomainNodes)
assortativity.nominal (Domain.net, types=DomainNodes$Domain, directed = TRUE)


average.path.length(Domain.net, directed=TRUE, unconnected=TRUE)

#degree centrality
DC <- degree(Domain.net, normalized=TRUE)

#weighted degree centrality
SC <- graph.strength(Domain.net)


#closeness centrality
CC <- closeness(Domain.net, normalized=TRUE, weights=NULL)

#betweenness centrality
BC <- betweenness(Domain.net, normalized=TRUE, weights=NULL)


CentralityFrame<-data.frame(DomainNodes,DC,SC,CC,BC)

Domain.net1 <- graph.data.frame(DomainEdges.Frame, directed=TRUE, vertices=CentralityFrame)

SortByDC <- CentralityFrame[with(CentralityFrame, order(-CentralityFrame$DC)),]
Top10ByDC<-SortByDC[30,]


Domain.net1.filterDC <- delete.vertices(Domain.net1, which(V(Domain.net1)$DC<=1.790262))
Domain.net1.filterSC <- delete.vertices(Domain.net1, which(V(Domain.net1)$SC<=478))
Domain.net1.filterCC <- delete.vertices(Domain.net1, which(V(Domain.net1)$CC<=0.9270833))
Domain.net1.filterBC <- delete.vertices(Domain.net1, which(V(Domain.net1)$BC<=0.00436183))

write.graph(Domain.net1.filterDC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/Top30DomainsByDC.gml", format="gml")
write.graph(Domain.net1.filterSC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/Top30DomainsBySC.gml", format="gml")
write.graph(Domain.net1.filterCC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/Top30DomainsByCC.gml", format="gml")
write.graph(Domain.net1.filterBC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/Top30DomainsByBC.gml", format="gml")
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

