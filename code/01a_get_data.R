# 01a_get_data.R: script to extract the data sets for the correctly specified simulation
#                 scenarios. 
# Author: Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)
# Load utils for simulation function
source("code/00_utils.R")
# Set seed to ensure reproducibility of the same values. 
set.seed(173920)

# Specify parameter combinations needed for simulation of landscape -------
# Species prevalence
species_prev <- c(-1.734601, 0)
# Spatial decay
spatial_decay = c(3/.1, 3/.3, 3/.5, 3/.7, 3/.9)
parameter_comb <- expand.grid(prevalence = species_prev, decay = spatial_decay)
write.csv(parameter_comb, "data/landscape_params.csv", row.names = FALSE)

# Number of simulation replicates for each combination of the parameters
n_sims <- 100

# Generate the data sets --------------------------------------------------
for (i in 1:nrow(parameter_comb)) {
  print(paste0("Currently on landscape ", i, " out of ", nrow(parameter_comb)))
  for (l in 1:n_sims) {
    if (l %% 10 == 0) print(paste0("Currently on sim ", l, " out of ", n_sims))
    dat <- data_simulation(species_prev = parameter_comb$prevalence[i], 
                           spatial_decay = parameter_comb$decay[i])
    save(dat, file = paste0("data/sim_data/landscape_", i, "_simulation_", l, 
                            ".rda"))
  } # Sim replicates (l)
} # parameter list (i)
