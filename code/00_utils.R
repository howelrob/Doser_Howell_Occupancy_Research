# 00_utils.R: script containing multiple functions used for generating data
#             and running simulations. 
# Author: Robbie Howell and Jeffrey W. Doser
#Random Sampling
random_sampling = function(n.plots=400, J=4900){
  plot.indx = sample(1:J, n.plots, replace=FALSE)
  return(plot.indx)
}


#Grid Sampling
grid_sampling = function(n.plots=400, J.x=70, J.y=70){
  plot.indx = c()
  
  side.length = floor(sqrt(n.plots))
  
  #Generates vertical indices of the rows
  v_points = round(seq(from=1, to=J.y, length.out=side.length))
  
  #Loops through the vertical indices to fill out the rows horizontally
  for (i in v_points){
    h_points = round(seq(from=1+(J.x*(i-1)), to=J.x*i, length.out=side.length))
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
  noisy_psi = occ_prob + runif(J, -noise_factor, noise_factor)
  scaled_noise = (noisy_psi - min(noisy_psi)) / (max(noisy_psi) - min(noisy_psi))
  #Does have the side effect of giving one plot a 0% chance of being sampled and one plot a 100% chance
  
  plot.indx = sample(1:J, n.plots, prob=scaled_noise, replace=FALSE)
  
  return(plot.indx)
}



data_simulation = function(x_axis=70, y_axis=70, species_prev=-1, spatial_decay=3/.7, misspec = FALSE) {
  J.x <- x_axis
  J.y <- y_axis
  J <- J.x * J.y  # Total number of grid cells across the landscape
  n.rep <- sample(3, J, replace = TRUE)  # Number of hypothetical repeat surveys at each site. 
  beta <- c(species_prev, 0.2, 0.3)  # The occupancy parameters. The first is the intercept, then the effects of two simulated covariates. 
  p.occ <- length(beta)  # Number of occupancy regression parameters.
  alpha <- c(0.3, 0.5)  # The detection parameters. The first is the intercept, second is a covariate.
  p.det <- length(alpha)  # Number of detection regression parameters.
  phi <- spatial_decay  # The spatial decay parameter. 
  sigma.sq <- 1.5  # The spatial variance parameter
  sp <- TRUE  # Indicates that we want to simulate with a spatial model
  cov.model = 'exponential'  # Using the exponential spatial covariance function. 
  
  
  if (!misspec) {
    # If no mis-specification, can simulate with the default simOcc() function in spOccupancy
    # The simOcc() function generates data with the above characteristics. 
    dat <- simOcc(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha, 
                  sigma.sq = sigma.sq, phi = phi, sp = sp, cov.model = cov.model)
  } else {
    # If there is mis-specification, simulate with custom function   
    dat <- simOcc_misspec(J.x = J.x, J.y = J.y, n.rep = n.rep, beta = beta, alpha = alpha, 
                          sigma.sq = sigma.sq, phi = phi, sp = sp, cov.model = cov.model)
  }  

  return(dat)
}

run_simulation <- function(dat, n.neighbors = 15, n.threads = 1, method = 'random',
                           n.plots = 400, line_length = 10, line_spacing = 2, nonspatial = FALSE) {
  J <- nrow(dat$X)
  J.x <- sqrt(J)
  J.y <- sqrt(J)
  #Simulate data collection
  if (method == "grid"){
    plot.indx = grid_sampling(n.plots=n.plots, J.x=J.x, J.y=J.y)
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
  n.chains <- 1
  
  
  # Run the model -----------------------------------------------------------
  if (nonspatial) {
    out <- PGOcc(occ.formula = ~ occ.cov.1 + occ.cov.2, 
                 det.formula = ~ det.cov.1, 
                 data = data.list, 
                 n.samples = n.batch * batch.length,
                 inits = inits.list, 
                 priors = prior.list,
                 verbose = FALSE, 
                 n.burn = n.burn, 
                 n.thin = n.thin, 
                 n.chains = n.chains) 
  } else {
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
  }
  
  # Prediction
  # Prediction covariates
  X.0 <- dat$X
  # Prediction coordinates
  coords.0 <- dat$coords
  
  # Predict occupancy probability at each cell in the study area (most of which 
  # do not have any observed data). 
  if (nonspatial) {
    out.pred <- predict(out, X.0 = X.0)
  } else {
    out.pred <- predict(out, X.0 = X.0, coords.0 = coords.0, n.omp.threads = n.threads, 
                        verbose = FALSE)
  }
  
  # Predicted occupancy probability at each grid cell
  psi.pred <- apply(out.pred$psi.0.samples, 2, median)
  # True occupancy probability at each grid cell
  psi.true <- dat$psi
  
  psi.ci <- apply(out.pred$psi.0.samples, 2, quantile, probs = c(0.025, 0.975))
  psi.sd <- apply(out.pred$psi.0.samples, 2, sd)
  
  out.list <- list(psi.est = psi.pred, psi.ci = psi.ci, 
                   psi.sd = psi.sd, psi.true = psi.true)
  
  return(out.list)
  
}


simOcc_misspec <- function(J.x, J.y, n.rep, n.rep.max, beta, alpha, psi.RE = list(), p.RE = list(),
                           sp = FALSE, svc.cols = 1, cov.model, sigma.sq, phi, nu, x.positive = FALSE,
                           grid, ...) {

  # Check for unused arguments ------------------------------------------
  formal.args <- names(formals(sys.function(sys.parent())))
  elip.args <- names(list(...))
  for(i in elip.args){
      if(! i %in% formal.args)
          warning("'",i, "' is not an argument")
  }

  # Subroutines -----------------------------------------------------------
  rmvn <- function(n, mu=0, V = matrix(1)){
    p <- length(mu)
    if(any(is.na(match(dim(V),p)))){stop("Dimension problem!")}
    D <- chol(V)
    t(matrix(rnorm(n*p), ncol=p)%*%D + rep(mu,rep(n,p)))
  }

  # Check function inputs -------------------------------------------------
  # J.x -------------------------------
  if (missing(J.x)) {
    stop("error: J.x must be specified")
  }
  if (length(J.x) != 1) {
    stop("error: J.x must be a single numeric value.")
  }
  # J.y -------------------------------
  if (missing(J.y)) {
    stop("error: J.y must be specified")
  }
  if (length(J.y) != 1) {
    stop("error: J.y must be a single numeric value.")
  }
  J <- J.x * J.y
  # n.rep -----------------------------
  if (missing(n.rep)) {
    stop("error: n.rep must be specified.")
  }
  if (length(n.rep) != J) {
    stop(paste("error: n.rep must be a vector of length ", J, sep = ''))
  }
  if (missing(n.rep.max)) {
    n.rep.max <- max(n.rep)
  }
  # beta ------------------------------
  if (missing(beta)) {
    stop("error: beta must be specified.")
  }
  # alpha -----------------------------
  if (missing(alpha)) {
    stop("error: alpha must be specified.")
  }
  # psi.RE ----------------------------
  names(psi.RE) <- tolower(names(psi.RE))
  if (!is.list(psi.RE)) {
    stop("error: if specified, psi.RE must be a list with tags 'levels' and 'sigma.sq.psi'")
  }
  if (length(names(psi.RE)) > 0) {
    if (!'sigma.sq.psi' %in% names(psi.RE)) {
      stop("error: sigma.sq.psi must be a tag in psi.RE with values for the occurrence random effect variances")
    }
    if (!'levels' %in% names(psi.RE)) {
      stop("error: levels must be a tag in psi.RE with the number of random effect levels for each occurrence random intercept.")
    }
    if (!'beta.indx' %in% names(psi.RE)) {
      psi.RE$beta.indx <- list()
      for (i in 1:length(psi.RE$sigma.sq.psi)) {
        psi.RE$beta.indx[[i]] <- 1
      }
    }
  }
  # p.RE ----------------------------
  names(p.RE) <- tolower(names(p.RE))
  if (!is.list(p.RE)) {
    stop("error: if specified, p.RE must be a list with tags 'levels' and 'sigma.sq.p'")
  }
  if (length(names(p.RE)) > 0) {
    if (!'sigma.sq.p' %in% names(p.RE)) {
      stop("error: sigma.sq.p must be a tag in p.RE with values for the detection random effect variances")
    }
    if (!'levels' %in% names(p.RE)) {
      stop("error: levels must be a tag in p.RE with the number of random effect levels for each detection random intercept.")
    }
    if (!'alpha.indx' %in% names(p.RE)) {
      p.RE$alpha.indx <- list()
      for (i in 1:length(p.RE$sigma.sq.p)) {
        p.RE$alpha.indx[[i]] <- 1
      }
    }
  }
  if (length(svc.cols) > 1 & !sp) {
    stop("error: if simulating data with spatially-varying coefficients, set sp = TRUE")
  }
  # Spatial parameters ----------------
  p.svc <- length(svc.cols)
  if (sp) {
    if(missing(sigma.sq)) {
      stop("error: sigma.sq must be specified when sp = TRUE")
    }
    if(missing(phi)) {
      stop("error: phi must be specified when sp = TRUE")
    }
    if(missing(cov.model)) {
      stop("error: cov.model must be specified when sp = TRUE")
    }
    cov.model.names <- c("exponential", "spherical", "matern", "gaussian")
    if(! cov.model %in% cov.model.names){
      stop("error: specified cov.model '",cov.model,"' is not a valid option; choose from ",
           paste(cov.model.names, collapse=", ", sep="") ,".")
    }
    if (cov.model == 'matern' & missing(nu)) {
      stop("error: nu must be specified when cov.model = 'matern'")
    }
    if (length(phi) != p.svc) {
      stop("error: phi must have the same number of elements as svc.cols")
    }
    if (length(sigma.sq) != p.svc) {
      stop("error: sigma.sq must have the same number of elements as svc.cols")
    }
    if (cov.model == 'matern') {
      if (length(nu) != p.svc) {
        stop("error: nu must have the same number of elements as svc.cols")
      }
    }
  }
  # Grid for spatial REs that doesn't match the sites ---------------------
  if (!missing(grid) & sp) {
    if (!is.atomic(grid)) {
      stop("grid must be a vector")
    }
    if (length(grid) != J) {
      stop(paste0("grid must be of length ", J))
    }
  } else {
    grid <- 1:J
  }

  # Subroutines -----------------------------------------------------------
  logit <- function(theta, a = 0, b = 1){log((theta-a)/(b-theta))}
  logit.inv <- function(z, a = 0, b = 1){b-(b-a)/(1+exp(z))}

  # Matrix of spatial locations
  s.x <- seq(0, 1, length.out = J.x)
  s.y <- seq(0, 1, length.out = J.y)
  coords.full <- as.matrix(expand.grid(s.x, s.y))
  coords <- cbind(tapply(coords.full[, 1], grid, mean),
                  tapply(coords.full[, 2], grid, mean))

  # Form occupancy covariates (if any) ------------------------------------
  n.beta <- length(beta)
  X <- matrix(1, nrow = J, ncol = n.beta)
  if (n.beta > 1) {
    for (i in 2:n.beta) {
      X[, i] <- rnorm(J)
    } # i
    if (x.positive) {
      for (i in 2:n.beta) {
        X[, i] <- runif(J, 0, 1)
      }
    }
  }

  # Form detection covariate (if any) -------------------------------------
  n.alpha <- length(alpha)
  X.p <- array(NA, dim = c(J, n.rep.max, n.alpha))
  # Get index of surveyed replicates for each site.
  rep.indx <- list()
  for (j in 1:J) {
    rep.indx[[j]] <- sample(1:n.rep.max, n.rep[j], replace = FALSE)
  }
  X.p[, , 1] <- 1
  if (n.alpha > 1) {
    for (i in 2:n.alpha) {
      for (j in 1:J) {
        X.p[j, rep.indx[[j]], i] <- rnorm(n.rep[j])
      } # j
    } # i
  }

  # Simulate spatial random effect ----------------------------------------
  # Matrix of spatial locations
  if (sp) {
    J <- nrow(coords.full)
    w.mat.full <- matrix(NA, J, p.svc)
    if (cov.model == 'matern') {
      theta <- cbind(phi, nu)
    } else {
      theta <- as.matrix(phi)
    }
    w.mat <- matrix(NA, nrow(coords), p.svc)
    for (i in 1:p.svc) {
      Sigma.full <- spBayes::mkSpCov(coords, as.matrix(sigma.sq[i]), as.matrix(0), theta[i, ], cov.model)
      w.mat[, i] <- rmvn(1, rep(0, nrow(Sigma.full)), Sigma.full)
      # Random spatial process
      w.mat.full[, i] <- w.mat[grid, i]
    }
    X.w <- X[, svc.cols, drop = FALSE]
    # Convert w to a J*ptilde x 1 vector, sorted so that the p.svc values for
    # each site are given, then the next site, then the next, etc.
    w <- c(t(w.mat.full))
    # Create X.tilde, which is a J x J*p.tilde matrix.
    X.tilde <- matrix(0, J, J * p.svc)
    # Fill in the matrix
    for (j in 1:J) {
      X.tilde[j, ((j - 1) * p.svc + 1):(j * p.svc)] <- X.w[j, ]
    }
  } else {
    w.mat.full <- NA
    w.mat <- NA
    X.w <- NA
  }

  # Simulate two additional REs not included in model ---------------------
  Sigma.1 <- mkSpCov(coords, as.matrix(0.75), as.matrix(0), 3 / 0.9, cov.model)
  w.1 <- rmvn(1, rep(0, nrow(Sigma.1)), Sigma.1) 
  Sigma.2 <- mkSpCov(coords, as.matrix(0.75), as.matrix(0), 3 / 0.01, cov.model)
  w.2 <- rmvn(1, rep(0, nrow(Sigma.2)), Sigma.2) 


  # Random effects --------------------------------------------------------
  if (length(psi.RE) > 0) {
    p.occ.re <- length(unlist(psi.RE$beta.indx))
    tmp <- sapply(psi.RE$beta.indx, length)
    re.col.indx <- unlist(lapply(1:length(psi.RE$beta.indx), function(a) rep(a, tmp[a])))
    sigma.sq.psi <- psi.RE$sigma.sq.psi[re.col.indx]
    n.occ.re.long <- psi.RE$levels[re.col.indx]
    n.occ.re <- sum(n.occ.re.long)
    beta.star.indx <- rep(1:p.occ.re, n.occ.re.long)
    beta.star <- rep(0, n.occ.re)
    X.random <- X[, unlist(psi.RE$beta.indx), drop = FALSE]
    n.random <- ncol(X.random)
    X.re <- matrix(NA, J, length(psi.RE$levels))
    for (i in 1:length(psi.RE$levels)) {
      X.re[, i] <- sample(1:psi.RE$levels[i], J, replace = TRUE)
    }
    indx.mat <- X.re[, re.col.indx, drop = FALSE]
    for (i in 1:p.occ.re) {
      beta.star[which(beta.star.indx == i)] <- rnorm(n.occ.re.long[i], 0,
						     sqrt(sigma.sq.psi[i]))
    }
    if (length(psi.RE$levels) > 1) {
      for (j in 2:length(psi.RE$levels)) {
        X.re[, j] <- X.re[, j] + max(X.re[, j - 1], na.rm = TRUE)
      }
    }
    if (p.occ.re > 1) {
      for (j in 2:p.occ.re) {
        indx.mat[, j] <- indx.mat[, j] + max(indx.mat[, j - 1], na.rm = TRUE)
      }
    }
    beta.star.sites <- rep(NA, J)
    for (j in 1:J) {
      beta.star.sites[j] <- beta.star[indx.mat[j, , drop = FALSE]] %*% t(X.random[j, , drop = FALSE])
    }
  } else {
    X.re <- NA
    beta.star <- NA
  }
  if (length(p.RE) > 0) {
    p.det.re <- length(unlist(p.RE$alpha.indx))
    tmp <- sapply(p.RE$alpha.indx, length)
    p.re.col.indx <- unlist(lapply(1:length(p.RE$alpha.indx), function(a) rep(a, tmp[a])))
    sigma.sq.p <- p.RE$sigma.sq.p[p.re.col.indx]
    n.det.re.long <- p.RE$levels[p.re.col.indx]
    n.det.re <- sum(n.det.re.long)
    alpha.star.indx <- rep(1:p.det.re, n.det.re.long)
    alpha.star <- rep(0, n.det.re)
    X.p.random <- X.p[, , unlist(p.RE$alpha.indx), drop = FALSE]
    X.p.re <- array(NA, dim = c(J, n.rep.max, length(p.RE$levels)))
    for (i in 1:length(p.RE$levels)) {
      X.p.re[, , i] <- matrix(sample(1:p.RE$levels[i], J * n.rep.max, replace = TRUE),
		              J, n.rep.max)
    }
    for (i in 1:p.det.re) {
      alpha.star[which(alpha.star.indx == i)] <- rnorm(n.det.re.long[i], 0, sqrt(sigma.sq.p[i]))
    }
    X.p.re <- X.p.re[, , p.re.col.indx, drop = FALSE]
    for (j in 1:J) {
      X.p.re[j, -rep.indx[[j]], ] <- NA
    }
    if (p.det.re > 1) {
      for (j in 2:p.det.re) {
        X.p.re[, , j] <- X.p.re[, , j] + max(X.p.re[, , j - 1], na.rm = TRUE)
      }
    }
    alpha.star.sites <- matrix(NA, J, n.rep.max)
    for (j in 1:J) {
      for (k in rep.indx[[j]]) {
        alpha.star.sites[j, k] <- alpha.star[X.p.re[j, k, ]] %*% X.p.random[j, k, ]
      }
    }
  } else {
    X.p.re <- NA
    alpha.star <- NA
  }

  # Latent Occupancy Process ----------------------------------------------
  # Note that all of these have w.1 and w.2 added, which represent covariates that are not included
  # in the model fit for testing the robustness of the models under a misspecification scenario. 
  if (sp) {
    if (length(psi.RE) > 0) {
      psi <- logit.inv(X %*% as.matrix(beta) + X.tilde %*% w + beta.star.sites + w.1 + w.2)
    } else {
      psi <- logit.inv(X %*% as.matrix(beta) + X.tilde %*% w + w.1 + w.2)
    }
  } else {
    if (length(psi.RE) > 0) {
      psi <- logit.inv(X %*% as.matrix(beta) + beta.star.sites + w.1 + w.2)
    } else {
      psi <- logit.inv(X %*% as.matrix(beta) + w.1 + w.2)
    }
  }
  z <- rbinom(J, 1, psi)

  # Data Formation --------------------------------------------------------
  p <- matrix(NA, nrow = J, ncol = n.rep.max)
  y <- matrix(NA, nrow = J, ncol = n.rep.max)
  for (j in 1:J) {
    if (length(p.RE) > 0) {
      p[j, rep.indx[[j]]] <- logit.inv(X.p[j, rep.indx[[j]], ] %*% as.matrix(alpha) +
				    alpha.star.sites[j, rep.indx[[j]]])
    } else {
      p[j, rep.indx[[j]]] <- logit.inv(X.p[j, rep.indx[[j]], ] %*% as.matrix(alpha))
    }
    y[j, rep.indx[[j]]] <- rbinom(n.rep[j], 1, p[j, rep.indx[[j]]] * z[j])
  } # j

  return(
    list(X = X, X.p = X.p, coords = coords, coords.full = coords.full,
         w = w.mat.full, w.grid = w.mat, psi = psi, z = z, p = p, y = y,
	 X.p.re = X.p.re, X.re = X.re, X.w = X.w,
	 alpha.star = alpha.star, beta.star = beta.star)
  )
}

