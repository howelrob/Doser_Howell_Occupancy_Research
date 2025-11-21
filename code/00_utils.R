# 00_utils.R: script containing multiple functions used for generating data
#             and running simulations. 
# Author: Robbie Howell and Jeffrey W. Doser
#Random Sampling
random_sampling = function(n.plots=400, J=4900){
  plot.indx = sample(1:J, n.plots, replace=FALSE)
  return(plot.indx)
}


#Grid Sampling
grid_sampling = function(h_spacing=2, v_spacing=2, J.x=70, J.y=70){
  plot.indx = c()
  
  #Adds 1 to the provided spacing values so that the spacing value is the number of empty spaces between plots
  v_points = seq(from=1, to=J.y, by=v_spacing+1)
  
  for (i in v_points){
    h_points = seq(from=1+(J.x*(i-1)), to=J.x*i, by=h_spacing+1)
    plot.indx = c(plot.indx, h_points)
  }
  
  return(plot.indx)
}


#Line Clusters
line_clusters = function(n.plots=400, line_length=10, method="h", spacing=1, J=4900, J.x=70, J.y=70){
  n.plots = n.plots
  line_length = line_length
  spacing = spacing
  num_lines = floor(n.plots / line_length)
  
  plot.indx = c()
  
  #Horizontal Lines
  if (method == "h"){
    
    #Determine possible plots to sample without going past edges
    to_remove = c()
    for (i in 1:J.y){
      to_remove = c(to_remove, seq(from=(J.x*i)-(line_length*spacing)+(spacing+1), to=(J.x*i), by=1))
    }
    avl_plts = c(1:J)
    avl_plts = avl_plts[!avl_plts %in% to_remove]
    
    #Add subsequent plots that will be sampled
    for (j in 1:num_lines){
      line_start = sample(avl_plts, 1, replace=FALSE)
      plot.indx = c(plot.indx, line_start)
      
      for (k in 1:line_length-1){
        plot.indx = c(plot.indx, (line_start + k*spacing))
      }
      
      #Update list of possible plots, including those behind to prevent line overlap
      taken_plts = seq(from=line_start-(line_length*spacing), to=line_start+(line_length*spacing), by=1)
      avl_plts = avl_plts[!avl_plts %in% taken_plts]
    }
    
    #Vertical Lines
  } else if (method == "v"){
    
    #Determine which plots can be sampled to prevent going past edges
    avl_plts = c(1:(J-(J.y*(line_length-1)*spacing)))
    
    #Add subsequent plots to list of plots that will be sampled
    for (i in 1:num_lines){
      line_start = sample(avl_plts, 1, replace=FALSE)
      plot.indx = c(plot.indx, line_start)
      
      for (j in 1:line_length-1){
        plot.indx = c(plot.indx, line_start + spacing*J.y*j)
      }
      
      #Update list of possible plots, including those behind to prevent line overlap
      taken_plts = seq(from=line_start-(J.y*line_length*spacing), to=line_start+(J.y*line_length*spacing), by=J.y)
      avl_plts = avl_plts[!avl_plts %in% taken_plts]
    }
  }
  
  return(plot.indx)
}


#Box Clusters
box_clusters = function(n.plots=400, cluster_size=4, J=4900, J.x=70, J.y=70){
  
  n.plots = n.plots
  cluster_size = cluster_size
  num_clusters = floor(n.plots / cluster_size)
  
  plot.indx = c()
  index = 1
  
  
  if (cluster_size == 4){
    #Removing the plots that would cause the boxes to extend outside the edges
    top_remove = seq(from=J-(J.x*2), to=J, by=1)
    side_remove = c()
    for (i in 0:1){
      side_remove = c(side_remove, seq(from=J.x-i, to=(J.x*J.y)-i, by=J.y))
    }
    
    avl_plts = c(1:J)
    avl_plts = avl_plts[!avl_plts %in% top_remove]
    avl_plts = avl_plts[!avl_plts %in% side_remove]
    
    #Random cluster start point and list of cluster points
    for (j in 1:num_clusters){
      corner = sample(avl_plts, 1, replace=FALSE)
      points = c(corner, corner+2,
                 corner+2*J.y, corner+2+2*J.y)
      
      for (k in 1:cluster_size){
        plot.indx = c(plot.indx, points[k])
      }
      
      #Remove plots so no overlap
      remove_corner = corner - 2 - J.y*2
      remove_plts = c()
      
      for (m in 0:4){
        remove_plts = c(remove_plts, seq(from=remove_corner + J.y*m, to=remove_corner + J.y*m + 4, by=1))
      }
      
      avl_plts = avl_plts[!avl_plts %in% remove_plts]
    }
  } else if (cluster_size == 16){
    #Removing the plots that would cause the boxes to extend outside the edges
    top_remove = seq(from=J-(J.x*6), to=J, by=1)
    side_remove = c()
    for (i in 0:5){
      side_remove = c(side_remove, seq(from=J.x-i, to=(J.x*J.y)-i, by=J.y))
    }
    
    avl_plts = c(1:J)
    avl_plts = avl_plts[!avl_plts %in% top_remove]
    avl_plts = avl_plts[!avl_plts %in% side_remove]
    
    #Random cluster start point and list of cluster points
    for (j in 1:num_clusters){
      corner = sample(avl_plts, 1, replace=FALSE)
      points = c(corner, corner+2, corner+4, corner+6,
                 corner+2*J.y, corner+2+2*J.y, corner+4+2*J.y, corner+6+2*J.y,
                 corner+4*J.y, corner+2+4*J.y, corner+4+4*J.y, corner+6+4*J.y,
                 corner+6*J.y, corner+2+6*J.y, corner+4+6*J.y, corner+6+6*J.y)
      
      for (k in 1:cluster_size){
        plot.indx = c(plot.indx, points[k])
      }
      
      #Remove plots so no overlap
      remove_corner = corner - 6 - J.y*6
      remove_plts = c()
      
      for (m in 0:12){
        remove_plts = c(remove_plts, seq(from=remove_corner+J.y*m, to=remove_corner+J.y*m+12, by=1))
      }
      
      avl_plts = avl_plts[!avl_plts %in% remove_plts]
    }
  }
  
  return(plot.indx)
}


#Preferential Sampling
pref_sampling = function(n.plots=400, occ_prob, noise_factor=0.1, J=4900){
  #Add uncertainty and scale the noisy data so there are no values above 1
  noisy_psi = occ_prob + runif(J, 0, noise_factor)
  scaled_noise = (noisy_psi - min(noisy_psi)) / (max(noisy_psi) - min(noisy_psi))
  #Does have the side effect of giving one plot a 0% chance of being sampled and one plot a 100% chance
  
  plot.indx = sample(1:J, n.plots, prob=scaled_noise, replace=FALSE)
  
  return(plot.indx)
}



data_simulation = function(x_axis=70, y_axis=70, n.neighbors=15, n.threads=1, method="random", n.plots=400, grid_h=2, grid_v=2,
                           line_length=10, line_spacing=2, box_size=4, pref_noise=0.1, species_prev=-1, spatial_decay=3/.7){
  J.x <- x_axis
  J.y <- y_axis
  J <- J.x * J.y  # Total number of grid cells across the landscape
  n.rep <- sample(3, J, replace = TRUE)  # Number of hypothetical repeat surveys at each site. 
  # TODO: make the first element of beta here an input to the function that we can change.
  beta <- c(species_prev, 0.2, 0.3)  # The occupancy parameters. The first is the intercept, then the effects of two simulated covariates. 
  p.occ <- length(beta)  # Number of occupancy regression parameters.
  alpha <- c(0.3, 0.5)  # The detection parameters. The first is the intercept, second is a covariate.
  p.det <- length(alpha)  # Number of detection regression parameters.
  # TODO: make phi an input into the function. 
  phi <- spatial_decay  # The spatial decay parameter. 
  sigma.sq <- 1.5  # The spatial variance parameter
  sp <- TRUE  # Indicates that we want to simulate with a spatial model
  cov.model = 'exponential'  # Using the exponential spatial covariance function. 
  
  
  # The simOcc() function generates data with the above characteristics. 
  dat <- simOcc(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha, 
                sigma.sq = sigma.sq, phi = phi, sp = sp, cov.model = cov.model)
  #str(dat)
  
  
  #Creating the simulated landscape
  plot.df <- data.frame(x = dat$coords[, 1],
                        y = dat$coords[, 2],
                        occupancy = dat$psi)
  
  #Simulate data collection
  if (method == "grid"){
    plot.indx = grid_sampling(grid_h, grid_v, J.x=J.x, J.y=J.y)
  } else if (method == "h_line"){
    plot.indx = line_clusters(n.plots=n.plots, line_length=line_length, method="h", spacing=line_spacing, J=J, J.x=J.x, J.y=J.y)
  } else if (method == "v_line"){
    plot.indx = line_clusters(n.plots=n.plots, line_length=line_length, method="v", spacing=line_spacing, J=J, J.x=J.x, J.y=J.y)
  } else if (method == "box4"){
    plot.indx = box_clusters(n.plots=n.plots, cluster_size=4, J=J, J.x=J.x, J.y=J.y)
  } else if (method == "box16"){
    plot.indx = box_clusters(n.plots=n.plots, cluster_size=16, J=J, J.x=J.x, J.y=J.y)
  } else if (method == "heavy_pref"){
    plot.indx = pref_sampling(n.plots=n.plots, occ_prob=dat$psi, noise_factor=0.1, J=J)
  } else if (method == "mod_pref"){
    plot.indx = pref_sampling(n.plots=n.plots, occ_prob=dat$psi, noise_factor=0.3, J=J)
  } else {
    plot.indx = random_sampling(n.plots=n.plots, J=J)
  }
  
  
  # Extract the data that we "collected" at the n.plots locations. 
  # The detection-nondetection data. 
  y <- dat$y[plot.indx, ]
  # Three dimensional array of all the detection covariates
  X.p <- dat$X.p[plot.indx, , ]
  # Matrix of the occupancy covariates
  X <- dat$X[plot.indx, ]
  coords <- dat$coords[plot.indx, ]
  
  coords.df <- data.frame(x = coords[, 1], 
                          y = coords[, 2])
  
  #Setting Model Parameters
  occ.covs <- X
  colnames(occ.covs) <- c('int', 'occ.cov.1', 'occ.cov.2')
  det.covs <- list(int = X.p[, , 1], 
                   det.cov.1 = X.p[, , 2]) 
  data.list <- list(y = y, 
                    occ.covs = occ.covs, 
                    det.covs = det.covs, 
                    coords = coords)
  
  # Here using mostly default priors, except specifying a prior for phi and sigma sq
  prior.list <- list(sigma.sq.ig = c(2, 1),
                     phi.unif = c(3 / 1, 3 / .1))
  
  # Setting some basic initial values
  inits.list <- list(alpha = 0, 
                     beta = 0, 
                     phi = 3 / .5, 
                     sigma.sq = 1,
                     nu = 1, 
                     z = apply(y, 1, max, na.rm = TRUE))
  
  
  # Specify MCMC settings ---------------
  # Number of batches
  n.batch <- 400
  # Batch length
  batch.length <- 25
  # Total number of MCMC samples (the algorithm requires splitting the 
  # MCMC samples up into a series of batches, where each batch has a specific
  # amount of MCMC samples). 
  (n.samples <- n.batch * batch.length)
  # Number of burn-in (amount of samples you throw away at the beginning)
  n.burn <- 5000
  n.thin <- 5
  # JWD: note that I changed this to 1. The number of MCMC simulations we're 
  #      currently running for is sufficient enough to reach convergence for 
  #      the parameters that we're interested in, so we don't need to take the 
  #      extra time to run three chains for each simulation.
  n.chains <- 1
  
  
  # Run the model -----------------------------------------------------------
  out <- spPGOcc(occ.formula = ~ occ.cov.1 + occ.cov.2, 
                 det.formula = ~ det.cov.1, 
                 data = data.list, 
                 n.batch = n.batch, 
                 batch.length = batch.length, 
                 inits = inits.list, 
                 priors = prior.list,
                 accept.rate = 0.43, 
                 cov.model = "exponential", 
                 verbose = FALSE, 
                 NNGP = TRUE, 
                 n.neighbors = n.neighbors,
                 n.report = 50, 
                 n.burn = n.burn, 
                 n.thin = n.thin, 
                 n.chains = n.chains) 
  
  #Prediction
  # Prediction covariates
  X.0 <- dat$X
  # Prediction coordinates
  coords.0 <- dat$coords
  
  # Predict occupancy probability at each cell in the study area (most of which 
  # do not have any observed data). 
  out.pred <- predict(out, X.0 = X.0, coords.0 = coords.0, n.omp.threads = n.threads, 
                      verbose = FALSE)
  
  # Predicted occupancy probability at each grid cell
  psi.pred <- apply(out.pred$psi.0.samples, 2, median)
  # True occupancy probability at each grid cell
  psi.true <- dat$psi
  
  # JWD: in addition to returning the median values of the occupancy estimates, 
  #      we'll also want some measures of uncertainty. Here I extract two things: 
  #      the lower and upper bound of a 95% credible interval, then the posterior
  #      standard deviation. These are two ways to quantify uncertainty in a Bayesian
  #      analysis. 
  psi.ci <- apply(out.pred$psi.0.samples, 2, quantile, probs = c(0.025, 0.975))
  psi.sd <- apply(out.pred$psi.0.samples, 2, sd)
  
  # JWD: output the occupancy estimates and the true occupancy values. 
  out.list <- list(psi.est = psi.pred, psi.ci = psi.ci, 
                   psi.sd = psi.sd, psi.true = psi.true)
  
  return(out.list)
  
}


