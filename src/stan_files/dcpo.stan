data{
  int<lower=1> K;                     // number of countries
  int<lower=1> T;                     // number of years
  int<lower=1> Q;                     // number of questions
  int<lower=1> P;                     // number of question-country combinations
  int<lower=1> N;                     // number of KTQR observations
  int<lower=1,upper=K> kk[N];         // country j for opinion n
  int<lower=1,upper=T> tt[N];         // year t for opinion n
  int<lower=1,upper=Q> qq[N];         // item k for opinion n
  int<lower=1,upper=P> pp[N];         // item-country p for opinion n
  int<lower=1> y_r[N];                // vector of survey responses, count
  int<lower=1> n_r[N];                // vector of sample sizes
}

parameters{
  real<lower=0> sigma_theta;	        // opinion evolution error variance
  real<lower=0> sigma_delta;	        // question-country intercept error variance
  vector[Q] beta;           			    // item difficulty
  vector<lower=0>[Q] alpha;        		// item discrimination
  matrix[T,K] theta_raw; 	           	// raw matrix of T by K latent traits
  vector[P] delta_raw;					      // question-country intercepts
  row_vector[K] theta_init;				    // initial latent traits for first year
  real<lower=0> phi;					        // dispersion parameter
}

transformed parameters{
  matrix[T,K] theta; 	                // matrix of T by K latent traits
  vector[N] theta_tt_kk;				      // N-vector for expanded theta vales
  vector<lower=0,upper=1>[N] eta;     // fitted values, on logit scale
  vector[P] delta;						        // item-country intercepts
  vector<lower=0>[N] a;					      // beta-binomial alpha parameter
  vector<lower=0>[N] b;					      // beta-binomial beta parameter

  theta[1] = theta_init;
  delta = sigma_delta * delta_raw;    // parameter expansion for delta

  for (t in 2:T) {                    // random walk
	  theta[t] = theta[t-1] + sigma_theta * theta_raw[t-1];
  }
  for (n in 1:N) {                    // expand theta to N-vector
  	theta_tt_kk[n] = theta[tt[n], kk[n]];
  }
  eta = inv_logit(beta[qq] + alpha[qq] .* theta_tt_kk + delta[pp]);  // fitted values model
  a = phi * eta; 						          // reparamaterise beta-binomial alpha par
  b = phi * (1 - eta); 					      // reparamaterise beta-binomial beta par
}

model{
  y_r ~ beta_binomial(n_r, a, b); 		// response model
  phi ~ gamma(4, 0.1);
  sigma_theta ~ std_normal();
  sigma_delta ~ std_normal();
  theta_init ~ std_normal();
  delta_raw ~ std_normal();
  for(t in 1:T) {
	  theta_raw[t] ~ std_normal();
  }
  beta ~ std_normal();
  alpha ~ std_normal();
}

generated quantities {
  vector[N] y_r_pred;					        // fitted data to check model
  vector[N] log_lik;					        // log likelihood for WAIC calculation
  for (n in 1:N) {
    y_r_pred[n] = beta_binomial_rng(n_r[n], a[n], b[n]);
    log_lik[n] = beta_binomial_lpmf(y_r[n] | n_r[n], a[n], b[n]);
  }
}
