rm(list = ls())
library(spOccupancy)


#read in given arguments (three numbers, e.g. (first row, last row, replicates))
args <- commandArgs(trailingOnly = TRUE)

start_row = as.numeric(args[1])
end_row = as.numeric(args[2])
replicates = as.numeric(args[3])


#load utils methods and parameters csv
source("utils.R")
parameters = read.csv("parameters.csv")

#set directories, unsure how to read in the utils and parameters csv through the HPC
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os') {
  #out.dir <- 'results/occupancy_sampling_results/'
  #data.dir <- 'data/sim_data_replicates/'
} else { # Running on NCSU HPC
  #out.dir <- '/share/doserlab/jwdoser/F25/results/occupancy_sampling_results/'
  #data.dir <- '/share/doserlab/jwdoser/F25/data/sim_data_replicates/'
}


#parameter rows and the number of iterations can easily be changed
current_params = parameters[start_row:end_row,]
n_iters = replicates

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
    save(output, file=paste0(out.dir, 'occupancy-sampling-row-', i, '-replicate-', j, '-', 
                             Sys.Date(), '.rda'))
  }  
}
