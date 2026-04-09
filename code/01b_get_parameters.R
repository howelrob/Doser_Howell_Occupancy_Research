# 01_get_parameters.R: script to get a flat file of the different combination 
#                      of parameter values that are used to determine the 
#                      different simulation runs. Each one of the parameter 
#                      combinations will be run for one of the 1000 simulated 
#                      landscapes. 
# Author: Robbie Howell and Jeffrey Doser


# Number of plots to "collect" data from
n.plots <- c(50, 100, 200, 400, 600)

# Different types of plot location designs. 
design <- c("random", "grid", "h_line", "v_line", "box4", "box16", "heavy_pref", "mod_pref")

# Five different numbers of neighbors for the NNGP approximation
n_neighbors <- c(5, 10, 15, 20, 25)


# Determine all unique combinations of those parameter values and output to a csv.
parameter_combinations = expand.grid(n.plots = n.plots, design=design, n_neighbors=n_neighbors)

write.csv(parameter_combinations, "data/parameters.csv", row.names=FALSE)


# TODO: note that really what should happen is 40 data sets should be simulated for each of the 100 occupancy landscapes, and then models with different numbers of neighbors should be fit for each of those 100 occupancy landscapes. Otherwise, you're still adding in noise when you compare different numbers of neighbors.  
