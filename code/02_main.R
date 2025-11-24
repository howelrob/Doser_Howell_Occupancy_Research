# 02_main.R: script to run the complete set of simulations. Inputs to the 
#            script are assumed to come from the command line for use on the 
#            NC State HPC. 
# Author: Robbie Howell
rm(list = ls())
library(spOccupancy)

set.seed(1357)

# read in given arguments (three numbers, e.g. (first row, last row, replicates))
args <- commandArgs(trailingOnly = TRUE)

# JWD: notice only inputting the current row and the number of replicates to do 
#      for that row (scenario)
curr_row = as.numeric(args[1])
replicates = as.numeric(args[2])

# Set directories, which differ depending on if we run on our machines locally or 
# if running on the NC State HPC
machine.name <- Sys.info()['nodename']
if (machine.name == 'pop-os' | machine.name == 'ROBBIESLAPTOP') {
  code_dir <- 'code/'
  results_dir <- 'results/full_sim_results/'
  data_dir <- 'data/'
} else { # Running on NCSU HPC
  # JWD: added in an option here so we can both run it if need be. I don't have
  #      privileges to your folder on the HPC so I have to specify mine to get it to work.
  if (Sys.info()["user"] == 'jwdoser') { # Jeff running it
    code_dir <- '/share/doserlab/jwdoser/HBD25/code/'
    results_dir <- '/share/doserlab/jwdoser/HBD25/results/test/'
    data_dir <- '/share/doserlab/jwdoser/HBD25/data/'
  } else { # Robbie running it 
    code_dir <- '/share/doserlab/rmhowel3/occ_research/code/'
    results_dir <- '/share/doserlab/rmhowel3/occ_research/results/test/'
    data_dir <- '/share/doserlab/rmhowel3/occ_research/data/'
          
  }
}

# load utils methods and parameters csv
# JWD: Note how I'm using paste0() here such that the code will work regardless
#      of whether you're on your local computer or on the HPC. 
source(paste0(code_dir, "00_utils.R"))
parameters <- read.csv(paste0(data_dir, 'parameters.csv'))

# JWD: got rid of the outer loop here. 
#parameter rows and the number of iterations can easily be changed
current_params = parameters[curr_row,]
n_iters = replicates
# Current parameters
n.plots = current_params$n.plots
design = current_params$design
prevalence = current_params$prevalence
neighbors = current_params$n_neighbors
decay = current_params$spatial_decay
  

#loop through each row of the given parameters
#run each set of parameters a number of given times
for (i in 1:n_iters) {
  # JWD: add this in, otherwise its nearly impossible to track how much longer
  #      the code will need to run. 
  print(paste0("Currently on iteration ", i, " out of ", n_iters))
  # JWD: also note that I changed the verbose argument in the spOccupancy functions
  #      inside data_simulation to not print the model progress output, otherwise it's clunky
  output = data_simulation(n.plots = n.plots, n.neighbors=neighbors, method=design, species_prev=prevalence, spatial_decay=decay)
  
  #Need to save the output to a file
  save(output, file=paste0(results_dir, 'occupancy-sampling-row-', curr_row, '-replicate-', i, '-', 
                           Sys.Date(), '.rda'))
}  
