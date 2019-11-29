data{
  int<lower = 0> N ; // number of individuals
  int<lower = 0> J ; // number of group 2 ob
  int<lower = 0> K ; // number of latent observations
  int X[(N*J), 2]  ; // covariate matrix
  vector[(N*J)] y ; // outcome
}
parameters{
  vector[N] indiv_betas; // non-interacted coefficients
  vector[J] group_2_betas; // non-interacted coefficients
  matrix[N, K] gammas; // individual factors
  matrix[J, K] deltas; // group 2 factors
  positive_ordered[K] gamma_sd; //gamma prior sd
  positive_ordered[K] delta_sd; //delta prior sd
  real<lower = 0> a; // gamma hyperprior a
  real<lower = 0> b; // gamma hyperprior b
  real<lower = 0> c; // gamma hyperprior c
  real<lower = 0> d; // gamma hyperprior d
  
}
transformed parameters{
  vector[(N*J)] linear_predictor ;
  for(i in 1:(N*J)){
    linear_predictor[i] = indiv_betas[X[i, 1]] + group_2_betas[X[i, 2]] + (gammas[X[i, 1], ]  * deltas[ X[i, 2], ]');
  }
}
model{
  indiv_betas ~ normal(1, 3) ;
  group_2_betas ~ normal(1, 3) ;
  
  gamma_sd ~ gamma( a, b) ;
  delta_sd ~ gamma( c, d) ;
  
  a ~ gamma(.1, .1) ;
  b ~ gamma(.1, .1) ;
  c ~ gamma(.1, .1) ;
  d ~ gamma(.1, .1) ;
  for(n in 1:N){
    gammas[n, ] ~ normal(rep_vector(0, K), gamma_sd) ;
  }
    for(j in 1:J){
    deltas[j, ] ~ normal(rep_vector(0, K), delta_sd) ;
  }
  y ~normal(linear_predictor, 1) ;
}

