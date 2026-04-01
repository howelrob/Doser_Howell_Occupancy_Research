# 03_main_misspec.R: script to run the complete set of simulations under a 
#                    model misspecification scenario. Inputs to the 
#                    script are assumed to come from the command line for use on the 
#                    NC State HPC. 
# Author: Robbie Howell and Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)

set.seed(1357)

# Read in given arguments (two numbers, e.g. (current row and number of replicates))
args <- commandArgs(trailingOnly = TRUE)

# Inputs from command line. 
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
  if (Sys.info()["user"] == 'jwdoser') { # Jeff running it
    code_dir <- '/share/doserlab/jwdoser/DHB25/code/'
    results_dir <- '/share/doserlab/jwdoser/DHB25/results/'
    data_dir <- '/share/doserlab/jwdoser/DHB25/data/'
  } else { # Robbie running it 
    code_dir <- '/share/doserlab/rmhowel3/occ_research/code/'
    results_dir <- '/share/doserlab/rmhowel3/occ_research/results/'
    data_dir <- '/share/doserlab/rmhowel3/occ_research/data/'
          
  }
}

# load utils methods and parameters csv
source(paste0(code_dir, "00_utils.R"))
parameters <- read.csv(paste0(data_dir, 'parameters.csv'))

# Parameter rows and the number of iterations can easily be changed
current_params <- parameters[curr_row,]
n_iters <- replicates
# Current parameters
n.plots <- current_params$n.plots
design <- current_params$design
neighbors <- current_params$n_neighbors
  
# Read in landscape parameters
landscape_params <- read.csv(paste0(data_dir, "landscape_params.csv"))
n_landscapes <- nrow(landscape_params)

# Loop through each row of the given parameters
# Run each set of parameters a number of given times
for (i in 1:n_iters) {
  print(paste0("Currently on iteration ", i, " out of ", n_iters))
  for (l in 1:n_landscapes) {
    print(paste0("Currently on landscape ", l, " out of ", n_landscapes))
    # Load in the current data set
    load(paste0(data_dir, "sim_data/misspec_landscape_", l, "_simulation_", i, ".rda"))

    output <- run_simulation(dat = dat, n.plots = n.plots, n.neighbors=neighbors, method=design)
   
    # Save the output. 
    save(output, file=paste0(results_dir, 'misspec-occupancy-sampling-row-', curr_row, '-landscape-', l, 
                             '-replicate-', i, '-', Sys.Date(), '.rda'))
  }
}  

