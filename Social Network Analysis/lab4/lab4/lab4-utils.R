# Lab 4 Utilities

# Plot GA networks
# Just a regular plot, but with men blue and women pink
# Assumes "sex" attribute
gaplot <- function(gr, names=TRUE)
{
  nlist <- rep("", vcount(ga.gr))
  if (names)
  {
    nlist <- V(gr)$vertex.names
  }
  plot(gr, vertex.color=c("#8888FF","pink")[1+(V(gr)$sex=="F")],
      vertex.label=nlist, 
     #   vertex.label.size=.75, 
     vertex.size=15)
}

invlogit <- function(x) {
  exp(x) / (1 + exp(x))
}
