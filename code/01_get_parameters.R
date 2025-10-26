# 01_get_parameters.R: script to get a flat file of the different combination 
#                      of parameter values that are used to determine the 
#                      different simulation runs. 
# Author: Robbie Howell

# Different types of plot location designs. 
design = c("random", "grid", "h_line", "v_line", "box4", "box16", "heavy_pref", "mod_pref")

# Two different types of species prevalences
species_prev = c(-1.734601, 0)

# Five different numbers of neighbors for the NNGP approximation
n_neighbors = c(5, 10, 15, 20, 25)

# Five different values of spatial decay 
spatial_decay = c(3/.1, 3/.3, 3/.5, 3/.7, 3/.9)

# Determine all unique combinations of those parameter values and output to a csv.
parameter_combinations = expand.grid(design=design, prevalence=species_prev, 
                                     n_neighbors=n_neighbors, spatial_decay=spatial_decay)

write.csv(parameter_combinations, "data/parameters.csv", row.names=FALSE)
