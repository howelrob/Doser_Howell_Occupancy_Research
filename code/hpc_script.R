rm(list = ls())
library(spOccupancy)

#set working directory to where all the files are stored
#setwd("C:/Users/howel/OneDrive/Documents/GitHub/Doser_Howell_Occupancy_Research/code")

#load utils methods and parameters csv
source("utils.R")
parameters = read.csv("parameters.csv")


#parameter rows and the number of iterations can easily be changed
current_params = parameters[1:2,]
n_iters = 5

#loop through each row of the given parameters
for (i in 1:nrow(current_params)){
  design = current_params[i, 1]
  prevalence = current_params[i, 2]
  neighbors = current_params[i, 3]
  decay = current_params[i, 4]
  
  #run each set of parameters a number of given times
  for (j in 1:n_iters){
    output = data_simulation(n.neighbors=neighbors, method=design, species_prev=prevalence, spatial_decay=decay)
    
    #Need to save the output to a file
  }  
}
