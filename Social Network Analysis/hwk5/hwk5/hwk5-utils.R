# Homework 5 Utils

# Inverse logit
# Useful for converting from log-odds to probabilities
invlogit <- function(x) {
  exp(x) / (1 + exp(x))
}

# Helper function for accessing the Florentine marriage data
loadflo <- function(x) {
  data(florentine)

  flo.gr.m <<- asIgraph(flomarriage)
  flo.gr.b <<- asIgraph(flobusiness)
}

