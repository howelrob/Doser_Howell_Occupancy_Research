design = c("random", "grid", "h_line", "v_line", "box4", "box16", "heavy_pref", "mod_pref")

species_prev = c(-1.734601, 0)

n_neighbors = c(5, 10, 15, 20, 25)

spatial_decay = c(3/.1, 3/.3, 3/.5, 3/.7, 3/.9)


parameter_combinations = expand.grid(design=design, prevalence=species_prev, 
                                     n_neighbors=n_neighbors, spatial_decay=spatial_decay)

write.csv(parameter_combinations, "C:/Users/howel/OneDrive/Documents/Occupancy Research/parameters.csv", row.names=FALSE)
