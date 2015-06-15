# Lab 3 Solution
# Parts adapted from Dan McFarland's network analysis labs
# See http://sna.stanford.edu/rlabs.php

# Load libraries
library(sand)

# Set the working directory. Adapt this for your local situation
setwd("C:/Users/TG/Documents/495/lab3/lab3")

# Get the M182 networks
m182.friend <- read.graph("m182-friend.graphml", format="graphml")
m182.task <- read.graph("m182-task.graphml", format="graphml")
m182.social <- read.graph("m182-social.graphml", format="graphml")

# Create weak and strong undirected versions of friend
m182.sfriend<-as.undirected(m182.friend,mode='mutual')
m182.wfriend<-as.undirected(m182.friend,mode='collapse')

# Plot networks
m182.layout<-layout.kamada.kawai(m182.wfriend)
# Part I: Clustering
par(mfrow=c(2,2))
plot(m182.sfriend,layout=m182.layout,main="strong")
plot(m182.wfriend,layout=m182.layout,main="Weak")
plot(m182.social,edge.arrow.size=0.1,layout=m182.layout,main="social")
plot(m182.task,edge.arrow.size=0.1,layout=m182.layout,main="Task")
par(mfrow=c(1,1))
# Walk trap
m182.walk<-walktrap.community(m182.wfriend)
m182.walk
sizes(m182.walk)
membership(m182.walk)
m182.walk.clust<-as.hclust(m182.walk)
plot(m182.walk.clust)
plot(m182.wfriend,layout=m182.layout,vertex.color=membership(m182.walk))
# Betweenness
m182.betw<-edge.betweenness.community(m182.wfriend)
m182.betw
sizes(m182.betw)
membership(m182.betw)
m182.betw.clust<-as.hclust(m182.betw)
plot(m182.betw.clust)
plot(m182.wfriend,layout=m182.layout,vertex.color=membership(m182.betw))



# Leading eigenvector
m182.eign<-leading.eigenvector.community(m182.wfriend)
m182.eign
sizes(m182.eign)
membership(m182.eign)

plot(m182.wfriend,layout=m182.layout,vertex.color=membership(m182.eign))


# Optimal
m182.opt<-optimal.community(m182.wfriend)
m182.opt
sizes(m182.opt)
membership(m182.opt)

plot(m182.wfriend,layout=m182.layout,vertex.color=membership(m182.opt))



# Part II: Assortativity
social.opt<-assortativity.nominal(m182.social,types=membership(m182.opt))
social.btw<-assortativity.nominal(m182.social,types=membership(m182.betw))
task.opt<-assortativity.nominal(m182.task,types=membership(m182.opt))
task.btw<-assortativity.nominal(m182.task,types=membership(m182.betw))

m182.social.nodes<-length(V(m182.social))
m182.social.edges<-length(E(m182.social))
m182.social.rand<-erdos.renyi.game(m182.social.nodes,m182.social.edges,type='gnm',directed=TRUE)

plot(m182.social.rand)

socialr.opt<-assortativity.nominal(m182.social.rand,types=membership(m182.opt))
socialr.btw<-assortativity.nominal(m182.social.rand,types=membership(m182.betw))

m182.task.nodes<-length(V(m182.task))
m182.task.edges<-length(E(m182.task))
m182.task.rand<-erdos.renyi.game(m182.task.nodes,m182.task.edges,type='gnm',directed=TRUE)

taskr.opt<-assortativity.nominal(m182.task.rand,types=membership(m182.opt))
taskr.btw<-assortativity.nominal(m182.task.rand,types=membership(m182.betw))

df<-data.frame(social=c(social.opt,social.opt),socialR=c(socialr.opt,socialr.opt),task=c(task.opt,task.btw),taskr=c(taskr.opt,taskr.btw))
df


