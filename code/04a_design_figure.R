# 04a_design_figure.R: script to generate Figure 1 in the manuscript that shows 
#                      the spatial design and different approaches for data 
#                      collection.
# Author: Jeffrey W. Doser
rm(list = ls())
library(spOccupancy)
library(ggplot2)
library(patchwork)
# Load utility functions
source("code/00_utils.R")

set.seed(1200)

# Note that this shows values for a single set of the other parameters.

J.x <- 70
J.y <- 70
J <- J.x * J.y
phi <- 3 / 0.7
species_prev <- 0

n.rep <- sample(3, J, replace = TRUE)  # Number of hypothetical repeat surveys at each site.
beta <- c(species_prev, 0.2, 0.3)  # The occupancy parameters. The first is the intercept, then the effects of two simulated covariates.
p.occ <- length(beta)  # Number of occupancy regression parameters.
alpha <- c(0.3, 0.5)  # The detection parameters. The first is the intercept, second is a covariate.
p.det <- length(alpha)  # Number of detection regression parameters.
sigma.sq <- 1.5  # The spatial variance parameter
sp <- TRUE  # Indicates that we want to simulate with a spatial model
cov.model = 'exponential'  # Using the exponential spatial covariance function.


# The simOcc() function generates data with the above characteristics.
dat <- simOcc(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha,
              sigma.sq = sigma.sq, phi = phi, sp = sp, cov.model = cov.model)

plot.df <- data.frame(x = dat$coords[, 1],
                      y = dat$coords[, 2],
                      occupancy = dat$psi)

# The full species distribution map across the area of interest. This is the base map. 
base.plot <- ggplot(data = plot.df, aes(x = x, y = y, fill = occupancy)) +
  # geom_point(col = 'black', pch = 21) +
  geom_raster() +
  theme_bw(base_size = 14) +
  # scale_fill_viridis_c(limits = c(0, 1), option = 'cividis') + 
  scale_fill_gradient(low = 'white', high = 'seagreen', limits = c(0, 1)) + 
  labs(x = 'Easting', y = 'Northing', fill = 'Occupancy Probability') + 
  theme(text = element_text(family="LM Roman 10"))
base.plot

# Number of plots to include in figure
n.plots <- 100
# Random sample
plots.random <- random_sampling(n.plots = n.plots, J = J)
random.plot.df <- plot.df[plots.random, ]
random.plot <- base.plot + 
  geom_point(data = random.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(a) Simple random sampling')

# Systematic sample
plots.sys <- grid_sampling(n.plots = n.plots, J.x = J.x, J.y = J.y)
sys.plot.df <- plot.df[plots.sys, ]
sys.plot <- base.plot + 
  geom_point(data = sys.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(b) Systematic sampling')

# Horizontal line
set.seed(8383)
plots.hline <- line_clusters(n.plots = n.plots)
hline.plot.df <- plot.df[plots.hline, ]
hline.plot <- base.plot + 
  geom_point(data = hline.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(c) Horizontal transects')

# Vertical line
set.seed(777373)
plots.vline <- line_clusters(n.plots = n.plots, method = 'v')
vline.plot.df <- plot.df[plots.vline, ]
vline.plot <- base.plot + 
  geom_point(data = vline.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(d) Vertical transects')

# 4-plot box 
set.seed(378)
plots.box4 <- box_clusters(n.plots = n.plots, cluster_size = 4)
box4.plot.df <- plot.df[plots.box4, ]
box4.plot <- base.plot + 
  geom_point(data = box4.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(e) Small arrays')

# 16-plot box 
set.seed(3770)
plots.box16 <- box_clusters(n.plots = n.plots, cluster_size = 16)
box16.plot.df <- plot.df[plots.box16, ]
box16.plot <- base.plot + 
  geom_point(data = box16.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(f) Large arrays')

# Moderate preferential sampling
set.seed(97382)
plots.mod.pref <- pref_sampling(n.plots = n.plots, occ_prob = dat$psi, noise_factor = 0.3)
mod.pref.plot.df <- plot.df[plots.mod.pref, ]
mod.pref.plot <- base.plot + 
  geom_point(data = mod.pref.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(g) Moderate preferential sampling')

# Heavy preferential sampling
set.seed(77373732)
plots.heavy.pref <- pref_sampling(n.plots = n.plots, occ_prob = dat$psi, noise_factor = 0.1)
heavy.pref.plot.df <- plot.df[plots.heavy.pref, ]
heavy.pref.plot <- base.plot + 
  geom_point(data = heavy.pref.plot.df, aes(x = x, y = y), col = 'black', size = 0.7) + 
  labs(title = '(h) Heavy preferential sampling')

# Put it all together
fig.1 <- (random.plot + sys.plot) / (hline.plot + vline.plot) / 
(box4.plot + box16.plot) / (mod.pref.plot + heavy.pref.plot) + 
plot_layout(guides = 'collect') & theme(legend.position = 'bottom', legend.key.width = unit(0.5, 'in'))

ggsave(fig.1, file = 'figures/Figure-1.png', width = 10, height = 14, units = 'in', 
       bg = 'white')
