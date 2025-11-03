# 02_main.R: script to run the complete set of simulations. Inputs to the 
#            script are assumed to come from the command line for use on the 
#            NC State HPC. 
# Author: Robbie Howell
rm(list = ls())
library(spOccupancy)

set.seed(1357)

# read in given arguments (three numbers, e.g. (first row, last row, replicates))
args <- commandArgs(trailingOnly = TRUE)

start_row = as.numeric(args[1])
end_row = as.numeric(args[2])
replicates = as.numeric(args[3])

# Set directories, which differ depending on if we run on our machines locally or 
# if running on the NC State HPC
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os' | machine.name == 'ROBBIESLAPTOP') {
  code_dir <- 'code/'
  results_dir <- 'results/full_sim_results/'
  data_dir <- 'data/'
} else { # Running on NCSU HPC
  code_dir <- '/share/doserlab/rmhowel3/occ_research/code/'
  results_dir <- '/share/doserlab/rmhowel3/occ_research/results/'
  data_dir <- '/share/doserlab/rmhowel3/occ_research/data/'
}

# load utils methods and parameters csv
# JWD: Note how I'm using paste0() here such that the code will work regardless
#      of whether you're on your local computer or on the HPC. 
source(paste0(code_dir, "00_utils.R"))
parameters <- read.csv(paste0(data_dir, 'parameters.csv'))

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
    save(output, file=paste0(results.dir, 'occupancy-sampling-row-', i, '-replicate-', j, '-', 
                             Sys.Date(), '.rda'))
  }  
}
