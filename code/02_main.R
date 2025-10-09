# 02_main.R: script to run the complete set of simulations. Inputs to the 
#            script are assumed to come from the command line for use on the 
#            NC State HPC. 
# Author: Robbie Howell
rm(list = ls())
library(spOccupancy)

# read in given arguments (three numbers, e.g. (first row, last row, replicates))
args <- commandArgs(trailingOnly = TRUE)

start_row = as.numeric(args[1])
end_row = as.numeric(args[2])
replicates = as.numeric(args[3])

# Set directories, which differ depending on if we run on our machines locally or 
# if running on the NC State HPC
# JWD: Robbie, replace the XXX with whatever your local computer names shows up as 
#      in the "machine.name" variable.
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os' | machine.name == 'XXX') {
  code_dir <- 'code/'
  results_dir <- 'results/full_sim_results/'
  data_dir <- 'data/'
} else { # Running on NCSU HPC
  # JWD: You'll need to tell the HPC the full absolute path to get to the desired 
  #      location of the files. The "/share/doserlab/rmhowel3/" will not change, 
  #      but you can change the name of the "occ_model_design", which should just
  #      be the name of the folder on the HPC where you store the project contents. 
  #      Within "occ_model_design", you should set up the same directory structure
  #      as what I've laid out on the github repo (i.e., code, data, docs, figures, results).  
  #      You could probably use scp to copy over the full contents of your local folder
  #      to the remote "occ_model_design" on the HPC. 
  code_dir <- '/share/doserlab/rmhowel3/occ_model_design/code/'
  results_dir <- '/share/doserlab/rmhowel3/occ_model_design/results/'
  data_dir <- '/share/doserlab/rmhowel3/occ_model_design/data/'
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
    save(output, file=paste0(out.dir, 'occupancy-sampling-row-', i, '-replicate-', j, '-', 
                             Sys.Date(), '.rda'))
  }  
}
