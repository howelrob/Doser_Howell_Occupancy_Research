# 05a_extract_metrics_nonspatial.R: script to process the massive amount of results files
#                                   into the specific metrics that will be used to calculate 
#                                   bias, coverage rates, and credible interval widths. This 
#                                   file processes the nonspatial models for the 
#                                   correctly specified scenario. 
# Author: Jeffrey W. Doser and Robert M. Howell
rm(list = ls())

# Directories -------------------------------------------------------------
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

# Setup -------------------------------------------------------------------
# Read in landscape parameters
land_params <- read.csv(paste0(data_dir, "landscape_params.csv"))
# Data set level parameters
params <- read.csv(paste0(data_dir, "parameters.csv"))
# Simulation reps. NOTE: hardcoded
replicates <- 1:100
# Scenarios for parameters that vary by each model run/simulated data set.  
n_params <- nrow(params)
# Number of different landscape parameters
n_landscapes_params <- nrow(land_params)
# Number of data replicates
n_replicates <- length(replicates)
# Iterator
n_cur_row <- 1

# Unique values for all parameters that vary across simulations. 
prevalence_vals <- unique(land_params$prevalence)
decay_vals <- unique(land_params$decay)
n_plot_vals <- unique(params$n.plots)
design_vals <- unique(params$design)
neighbors_vals <- unique(params$n_neighbors)

summary_df <- expand.grid(prevalence_vals, decay_vals, n_plot_vals, 
                          design_vals, neighbors_vals, replicates)
colnames(summary_df) <- c("prevalence", "sp_decay", "n_plot", "design", 
                          "neighbors", "replicate")
attr(summary_df, "out.attrs") <- NULL
summary_df$bias <- NA
summary_df$coverage <- NA
summary_df$ci_width <- NA

# Calculate the metrics ---------------------------------------------------
# Total number of models run 
n_total <- n_params * n_landscapes_params * n_replicates

for (i in 1:n_total) {
  if (i %% 100 == 0){
    print(paste0("Currently on simulation ", i, " out of ", n_total))
  }
  curr_row <- which(params$n.plots == summary_df$n_plot[i] & 
                      params$design == summary_df$design[i] & 
                      params$n_neighbors == summary_df$neighbors[i])
  curr_land <- which(land_params$prevalence == summary_df$prevalence[i] & 
                       land_params$decay == summary_df$sp_decay[i])
  tryCatch({
    load(Sys.glob(paste0(results_dir, 'nonspatial-occupancy-sampling-row-', curr_row, 
                         '-landscape-', curr_land, '-replicate-', 
                         summary_df$replicate[i], '-2026*.rda')))
    summary_df$bias[i] <- mean(output$psi.est - output$psi.true)
    summary_df$coverage[i] <- mean(output$psi.true <= output$psi.ci[2, ] & 
                                     output$psi.true >= output$psi.ci[1, ])
    summary_df$ci_width[i] <- mean(output$psi.ci[2, ] - output$psi.ci[1, ])
    rm(output)
  }, error = function(e) {
    message("Error: ", e$message)
  })
}

# Save results to hard drive ----------------------------------------------
save(summary_df, file = paste0(results_dir, "nonspatial_summary_sim_1_results.rda"))
