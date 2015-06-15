library("sand")

# 2 Data file location
setwd("C:/Users/TG/Documents/495/globalflightsnetwork/FinalProject/")

# 3 Read data


cities.routes <- read.graph("C2CF.net", format="pajek")
cities.dist <- read.graph("C2CD.net", format="pajek")

plot(cities.routes, vertex.label=V(cities.routes)$id, edge.arrow.size=0.2,layout=layout.kamada.kawai)
plot(cities.dist, vertex.label=V(cities.dist)$id, edge.arrow.size=0.2,layout=layout.kamada.kawai)

cities.routes.pref <- E(cities.routes)$weight
cities.dist.pref <- E(cities.dist)$weight
table(cities.routes.pref)
table(cities.dist.pref)

cities.routes.deg<-degree(cities.routes,v=V(cities.routes),mode='total')
cities.routes.degdist<-degree.distribution(cities.routes)
show(cities.routes.degdist)

cities.dist.deg<-degree(cities.dist,v=V(cities.dist),mode='total')
cities.dist.degdist<-degree.distribution(cities.dist)
show(cities.dist.degdist)

show(cities.routes.deg)
show(cities.dist.deg)

hist(cities.routes.deg)
barplot(cities.routes.degdist)

hist(cities.dist.deg)
barplot(cities.dist.degdist)













# Import our libraries
#install.packages("sand")
library("sand")
library(corrplot)

# Loading the data
# Set the path correctly
setwd("D:/DEPAUL STUDY/DePaul Course Related/CSC 495/Project/Final/FinalProject")

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

citiesToCities_routes <- citiesToCities.net
citiesToCities_distance <- citiesToCities.net

citiesToCities.net.degcent<- DegreeCent(citiesToCities.net)
cugtest1 <- mycugtest(citiesToCities.net,DegreeCent,cmode="edges", directed=TRUE)
print.cug.test(cugtest1)
plot.cug.test(cugtest1)
