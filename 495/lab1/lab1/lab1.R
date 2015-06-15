# Import our libraries
#install.packages("sand")
library("sand")


# Loading the data
# Set the path correctly
setwd("C:/Users/TG/OneDrive/Documents/CSC 495/lab1/lab1")

# Load the edges (use read.table)
kr.advice<-read.table("krack-advice-edges.txt")
kr.friend<-read.table("krack-friend-edges.txt")
kr.reports<-read.table("krack-reports-edges.txt")
# Load the attributes (use read.csv)

kr.attrs<-read.csv("krack-attrs.csv")

# Consolidating the data

# Create a data frame
kr.df<-data.frame(ego=kr.advice[,1],alter=kr.advice[,2],advice=kr.advice[,3],friend=kr.friend[,3],reports=kr.reports[,3])
# Get rid of the absent edges
kr.nz<-kr.df[kr.df$advice+kr.df$friend+kr.df$reports>0,]
# Convert to network using edgelist
kr.net <- graph.edgelist(cbind(kr.nz$ego,kr.nz$alter),directed=TRUE)

# Set edge attributes
E(kr.net)$advice<-kr.nz$advice
E(kr.net)$friend<-kr.nz$friend
E(kr.net)$reports<-kr.nz$reports
# Set vertex attributes

V(kr.net)$age<-kr.attrs$AGE
V(kr.net)$tenure<-kr.attrs$TENURE
V(kr.net)$dept<-kr.attrs$DEPT
V(kr.net)$level<-kr.attrs$LEVEL
           
# Create subnetworks based on types of edges
                        
# Divide by edge types: advice
advice.net<-delete.edges(kr.net,which(E(kr.net)$advice==0))
# Divide by edge types: friend
friend.net<-delete.edges(kr.net,which(E(kr.net)$friend==0))
# Divide by edge types: reportsTo
reports.net<-delete.edges(kr.net,which(E(kr.net)$reports==0))
# Show all of the networks together in a single figure.
# Creates a 2x2 array of plots
par(mfrow=c(2,2))
plot(kr.net,vertex.label=NA,edge.arrow.size=0.2,main="Full Network")
plot(advice.net,vertex.label=NA,edge.arrow.size=0.2,main="Advice Network")
plot(friend.net,vertex.label=NA,edge.arrow.size=0.2,main="Friend Network")
plot(reports.net,vertex.label=NA,edge.arrow.size=0.2,main="Reports Network")

# Goes back to 1 plot at a time
par(mfrow=c(1,1)) # Good practice to reset figure parameters

# Do the same thing but output to PDF.
# Opens a PDF output file
pdf("lab1-all-nets.pdf")
par(mfrow=c(2,2))

plot(kr.net,vertex.label=NA,edge.arrow.size=0.2,main="Full Network")
plot(advice.net,vertex.label=NA,edge.arrow.size=0.2,main="Advice Network")
plot(friend.net,vertex.label=NA,edge.arrow.size=0.2,main="Friend Network")
plot(reports.net,vertex.label=NA,edge.arrow.size=0.2,main="Reports Network")
# Goes back to 1 plot at a time
par(mfrow=c(1,1))
# Closes the file
dev.off()

# Advice in-degree
# Test if tenure and advice are linked


# Plot the advice network, size the nodes by tenure.
plot(advice.net,vertex.size=V(advice.net)$tenure,vertex.label=NA,edge.arrow.size=0.2)                        
# Collect the in-degree data for the advice network
advice.ind<-degree(advice.net,mode='in')   
#histogram of indegreees

# Regression on this variable
advice.lm<-lm(advice.ind~V(advice.net)$tenure)                        
# See the results
summary(advice.lm)
# Create a plot of in-degree vs tenure
plot(V(advice.net)$tenure,advice.ind)
# Add the regression line to the plot
abline(advice.lm)

# For goodness-of-fit info, we can look at the residuals in a QQ plot
plot(advice.lm,which=2)

# Compute the reportsTo layout
reports.layout<-layout.fruchterman.reingold(reports.net)

                        
# Plot, sizing by tenure
plot(advice.net,vertex.size=V(advice.net)$tenure,vertex.label=NA,edge.arrow.size=0.2,layout=reports.layout)
# Set up some edge colors (use transparency)
edge.colors<- c(rgb(1,0,0,.5), rgb(0,0,1,.5), rgb(0,0,0,0.75))
                        
# Create an edge attribute called "color" and set it correctly.
E(kr.net)[E(kr.net)$advice==1]$color<-edge.colors[1] 
E(kr.net)[E(kr.net)$friend==1]$color<-edge.colors[2] 
E(kr.net)[E(kr.net)$reports==1]$color<-edge.colors[3] 
# Plot the full network with the different links
# Plot, sizing by tenure
plot(kr.net,vertex.size=(V(kr.net)$tenure/2)+5,vertex.label=NA,edge.arrow.size=0.2,layout=reports.layout,edge.color=E(kr.net)$color)
# Add a legend to explain the colors
legend("topleft",
       legend = c('Advice', 
                  'Friendship',
                  'Reports To'), 
       col = edge.colors, 
       lty=1, lwd=3,
       cex = 0.6)


