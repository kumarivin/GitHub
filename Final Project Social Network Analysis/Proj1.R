# Import our libraries
#install.packages("sand")
library(sand)
library(corrplot)

# Loading the data
# Set the path correctly
setwd("C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject")

# Load the edges
project.citiesToCities <- read.csv("C2C-E1.csv", head=TRUE, sep=",")
project.citiesToCitiesPass <- read.csv("C2CP-E1.csv", head=TRUE, sep=",")

# Load the attributes
project.citiesToCitiesVertex <- read.csv("C2C-V1.csv", head=TRUE, sep=",")
project.citiesToCitiesPassVertex <- read.csv("C2CP-V1.csv", head=TRUE, sep=",")

#Cities to cities network(Routes and distance)
citiesToCities.edge <- data.frame(project.citiesToCities$departure.city, 
                                  project.citiesToCities$arrival.city, 
                                  project.citiesToCities$number.of.routes,
                                  project.citiesToCities$distance)

citiesToCities.net <- graph.data.frame(citiesToCities.edge, directed=TRUE, vertices=project.citiesToCitiesVertex)

#Calculate centrality measures
#average.shortest.path
average.path.length(citiesToCities.net, directed=TRUE, unconnected=TRUE)

#degree centrality
DC <- degree(citiesToCities.net, normalized=TRUE)

#weighted degree centrality
SC <- graph.strength(citiesToCities.net)
SC1 <- SC/max(SC)

#closeness centrality
CC <- closeness(citiesToCities.net, normalized=TRUE, weights=NULL)

#betweenness centrality
BC <- betweenness(citiesToCities.net, normalized=TRUE, weights=NULL)

#eigenvector centrality
EC <- evcent(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector

#PageRank
PR <- page.rank(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector

project.citiesToCitiesVertex1 <- data.frame(project.citiesToCitiesVertex, 
                                            DC, 
                                            SC1, 
                                            CC, 
                                            BC, 
                                            EC, 
                                            PR)


citiesToCities.net1 <- graph.data.frame(citiesToCities.edge, directed=TRUE, vertices=project.citiesToCitiesVertex1)


#Filter top 30 degree centrality cities
#sort data frame and find the top 30 degree-cities
sort.project.citiesToCitiesVertexDC <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$DC)), ]
sort.project.citiesToCitiesVertexDC1<-sort.project.citiesToCitiesVertexDC[30,]
sort.project.citiesToCitiesVertexBC <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$BC)), ]
sort.project.citiesToCitiesVertexBC1<-sort.project.citiesToCitiesVertexBC[31,]
sort.project.citiesToCitiesVertexSC <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$SC1)), ]
sort.project.citiesToCitiesVertexSC1<-sort.project.citiesToCitiesVertexSC[30,]
sort.project.citiesToCitiesVertexCC <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$CC)), ]
sort.project.citiesToCitiesVertexCC1<-sort.project.citiesToCitiesVertexCC[30,]
sort.project.citiesToCitiesVertexEC <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$EC)), ]
sort.project.citiesToCitiesVertexEC1<-sort.project.citiesToCitiesVertexEC[30,]
sort.project.citiesToCitiesVertexPR <- project.citiesToCitiesVertex1[with(project.citiesToCitiesVertex1, order(-project.citiesToCitiesVertex1$PR)), ]
sort.project.citiesToCitiesVertexPR1<-sort.project.citiesToCitiesVertexPR[30,]


#delete vertices
citiesToCities.net1.filterDC <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$DC<=0.1543438))
citiesToCities.net1.filterBC <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$BC<=0.01402945))
citiesToCities.net1.filterSC <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$SC1<0.2754591))
citiesToCities.net1.filterCC <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$CC<=0.03965694))
citiesToCities.net1.filterEC <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$EC<=0.4355476))
citiesToCities.net1.filterPR <- delete.vertices(citiesToCities.net1, which(V(citiesToCities.net1)$PR<=0.004685085))

write.graph(citiesToCities.net1.filterDC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30DC.gml", format="gml")
write.graph(citiesToCities.net1.filterBC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30BC.gml", format="gml")
write.graph(citiesToCities.net1.filterSC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30SC.gml", format="gml")
write.graph(citiesToCities.net1.filterCC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30CC.gml", format="gml")
write.graph(citiesToCities.net1.filterEC, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30EC.gml", format="gml")
write.graph(citiesToCities.net1.filterPR, "C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/citiesToCities_top30PR.gml", format="gml")

#####################
write.graph(citiesToCities.net, "D:/DEPAUL STUDY/DePaul Course Related/CSC 495/Project/Final/FinalProject/citiesToCities.gml", format="gml")

citiesToCities_routes <- citiesToCities.net
citiesToCities_distance <- citiesToCities.net

#citiesToCities(routes)
V(citiesToCities_routes)$id <- V(citiesToCities_routes)$name
remove.vertex.attribute(citiesToCities_routes, "name")
E(citiesToCities_routes)$weight <- E(citiesToCities_routes)$project.citiesToCities.number.of.routes
remove.edge.attribute(citiesToCities_routes, "project.citiesToCities.number.of.routes")
remove.edge.attribute(citiesToCities_routes, "project.citiesToCities.distance")
write.graph(citiesToCities_routes, "D:/DEPAUL STUDY/DePaul Course Related/CSC 495/Project/Final/FinalProject/citiesToCities(routes).net", format="pajek")

#citiesToCities(distance)
V(citiesToCities_distance)$id <- V(citiesToCities_distance)$name
remove.vertex.attribute(citiesToCities_distance, "name")
E(citiesToCities_distance)$weight <- E(citiesToCities_distance)$project.citiesToCities.distance
remove.edge.attribute(citiesToCities_distance, "project.citiesToCities.number.of.routes")
remove.edge.attribute(citiesToCities_distance, "project.citiesToCities.distance")
write.graph(citiesToCities_distance, "D:/DEPAUL STUDY/DePaul Course Related/CSC 495/Project/Final/FinalProject/citiesToCities(distance).net", format="pajek")

#Cities to cities network(number of pass)
project.citiesToCitiesPass.edge <- data.frame(project.citiesToCitiesPass$City.Departure, 
                                              project.citiesToCitiesPass$city.arrival, 
                                              project.citiesToCitiesPass$number.passengers.1990, 
                                              project.citiesToCitiesPass$number.passengers.1995, 
                                              project.citiesToCitiesPass$number.passengers.2000, 
                                              project.citiesToCitiesPass$number.passengers.2005, 
                                              project.citiesToCitiesPass$number.passengers.2010)
project.citiesToCitiesPass.net <- graph.data.frame(project.citiesToCitiesPass.edge, directed=TRUE, vertices=NULL)

citiesToCitiesPass.net.pajek <- write.graph(project.citiesToCitiesPass.net, "D:/DEPAUL STUDY/DePaul Course Related/CSC 495/Project/Final/FinalProject/citiesToCitiesPass.gml", format="gml")

#Correlation
#degree centrality
DC <- degree(citiesToCities.net, normalized=TRUE)

sort(DC, decreasing = TRUE)[1:10]

#weighted degree centrality
SC <- graph.strength(citiesToCities.net)
SC1 <- SC/max(SC)

sort(SC1, decreasing = TRUE)[1:10]

#closeness centrality
CC <- closeness(citiesToCities.net, normalized=TRUE, weights=NULL)

sort(CC, decreasing = TRUE)[1:10]

#betweenness centrality
BC <- betweenness(citiesToCities.net, normalized=TRUE, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)

sort(BC, decreasing = TRUE)[1:10]

#eigenvector centrality
EC <- evcent(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector

sort(EC, decreasing = TRUE)[1:10]

#PageRank
PR <- page.rank(citiesToCities.net, weights=V(citiesToCities.net)$project.citiesToCities.number.of.routes)$vector

sort(PR, decreasing = TRUE)[1:10]

#DC is degree centrality, CC is closeness centrality, BC is betweenness centrality
#EC is eigenvector centrality
centrality1 <- cbind(DC, SC1, CC, BC, EC, PR)
correlation <- cor(centrality1)

#if correlation coefficent is too small, then it will be more transparent
corrplot.mixed(correlation, title="Correlation")

hist(DC)
hist(SC1)
hist(CC)
hist(BC)
hist(EC)
hist(PR)