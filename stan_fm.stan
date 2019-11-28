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
  vector[K] gamma_mean; //gamma prior mean
  vector<lower=0>[K] gamma_sd; //gamma prior sd
  vector[K] delta_mean; //gamma prior mean
  vector<lower=0>[K] delta_sd; //gamma prior sd
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
  
  gamma_mean ~ normal(2, 1) ;
  gamma_sd ~ gamma( 1, 1) ;
  
  delta_mean ~ normal(-2, 1) ;
  delta_sd ~ gamma( .5, .5) ;
  
  for(n in 1:N){
    gammas[n, ] ~ normal(gamma_mean, gamma_sd) ;
  }
    for(j in 1:J){
    deltas[j, ] ~ normal(delta_mean, delta_sd) ;
  }
  y ~normal(linear_predictor, 1) ;
}

