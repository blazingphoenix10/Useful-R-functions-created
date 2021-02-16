# Source: https://stackoverflow.com/a/25455968/8281802

loadRData <- function(fileName){
  # loads an RData file, and returns it
  load(fileName)
  get(ls()[ls() != "fileName"])
}
