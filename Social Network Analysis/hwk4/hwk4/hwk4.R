
# 1 File locations
setwd("C:/Users/TG/Documents/495/hwk4/hwk4")

# 2 Load utilities
source("mycugtest.R")
source("myqaptest.R")

# 3 Load sand library
library(sand)

# Part I: Dolphin Network
DolphinGraph<-read.graph("dolphin.graphml",format="graphml")
transitivity(DolphinGraph,type="global")
cugtest1 <- mycugtest(DolphinGraph,transitivity,cmode="edges", directed=TRUE, type="global")
print.cug.test(cugtest1)
plot.cug.test(cugtest1)
#Q5 At P=0.05, we reject null hypothesis for observed value. It is a known fact that the 
#randomly generated graphs always tend to have uniform degree distribution, which results 
#in a transitivity that usually cant coincide with Dolphin network.
DegreeCent<-function(grph){ 
  rx <- centralization.degree(grph)$centralization;
  return (rx)
}
dolphincentralization <- DegreeCent(DolphinGraph)
cugcenttest1 <- mycugtest(DolphinGraph,DegreeCent,cmode="edges", directed=FALSE)
print.cug.test(cugcenttest1)
plot.cug.test(cugcenttest1)
#Q6 At P=0.05, we reject null hypothesis for observed value. It is a known fact that the 
#randomly generated graphs always tend to have uniform degree distribution, which results 
#in a Degree centralization that usually cant coincide with Dolphin network.

vect<-V(DolphinGraph)$Sex+1
cugassorttest1 <- mycugtest(DolphinGraph,assortativity.nominal,types=vect,cmode="edges",directed=FALSE)
print.cug.test(cugassorttest1)
plot.cug.test(cugassorttest1)

#Q7 At P=0.05, we reject null hypothesis for observed value. It is a known fact that the 
#randomly generated graphs always tend to have uniform connectivity, which results 
#in a Degree centralization that usually cant coincide with Dolphin$Sex network.


#QAP test

qapdegcenttest1 <- myqaptest(DolphinGraph,DegreeCent,reps=1000)
summary.qaptest(qapdegcenttest1)
plot.qaptest(qapdegcenttest1)

#Q8 QAP is not effective for degree centralization is a structural property 


qapassorttest1 <- myqaptest(DolphinGraph,assortativity.nominal,types=vect,reps=1000,directed=FALSE)
summary.qaptest(qapassorttest1)
plot.qaptest(qapassorttest1)

#Q9 At P=0.05, we fail to reject null hypothesis for observed value. It is a known fact that the 
#randomly vertices rearranged in a network always tends to improve assortativity after sevaral repetitions.

# Part II: Krackhardt Networks

kadvice <- read.graph("krack-advice.graphml", format="graphml")
kfriend <- read.graph("krack-friend.graphml", format="graphml")
kfriend.weak<-as.undirected(kfriend,mode='collapse')

kfriend.weak.eigen<-leading.eigenvector.community(kfriend.weak)

plot(kfriend.weak,vertex.color=kfriend.weak.eigen$membership)
#CUG Test
assortadvcwthfrnd<-mycugtest(kadvice,assortativity.nominal,types=kfriend.weak.eigen$membership,cmode="edges",directed=FALSE)
print.cug.test(assortadvcwthfrnd)
plot.cug.test(assortadvcwthfrnd)

#Q15 At P=0.05, we reject null hypothesis for observed value. The reason could be the normal distirbution of randomly generated
# friends network.


advicetenure<-V(kadvice)$tenure
assortadvc<-mycugtest(kadvice,assortativity,types1=advicetenure,cmode="edges",directed=FALSE)
print.cug.test(assortadvc)
plot.cug.test(assortadvc)
#Q16 At P=0.05, we reject null hypothesis for observed value. It seems the the advice network
# behaves differently to the randomly generated advice network , irrespective of tenure.

#QAP Test

qapassortadvcwthfrnd <- myqaptest(kadvice,assortativity.nominal,types=kfriend.weak.eigen$membership,reps=1000,directed=FALSE)
summary.qaptest(qapassortadvcwthfrnd)
plot.qaptest(qapassortadvcwthfrnd)
qapassortadvc<-myqaptest(kadvice,assortativity,types1=advicetenure,reps=1000,directed=FALSE)
summary.qaptest(qapassortadvc)
plot.qaptest(qapassortadvc)
