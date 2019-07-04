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
  vector<lower=0>[Q] alpha;        		// item discrimination
  vector[Q] beta;           			    // item difficulty component
  vector[P] delta_raw;					      // question-country intercepts
  real<lower=0> sigma_delta;	        // question-country intercept error variance
  row_vector[K] raw_theta_N01[T]; 	  // public opinion, before transition model, std normal scale
  real<lower=0> sd_theta_evolve;	    // public opinion evolution
  row_vector[K] theta_init;				    // initial latent traits for first year
  real<lower=0> phi;					        // dispersion parameter
}

transformed parameters{
  row_vector[K] raw_theta[T]; 	      // public opinion, after transition model
  row_vector[K] theta[T]; 	          // public opinion, after transition model, on [0, 1] scale
  vector[N] theta_tt_kk;				      // N-vector for expanded theta vales
  vector<lower=0,upper=1>[N] eta;     // fitted values, on logit scale
  vector[P] delta;						        // item-country difficulty component
  vector<lower=0>[N] a;					      // beta-binomial alpha parameter
  vector<lower=0>[N] b;					      // beta-binomial beta parameter

  delta = sigma_delta * delta_raw;    // parameter expansion for delta

  // first year values for raw_theta and theta
  raw_theta[1] = theta_init;
  theta[1] = inv_logit(theta_init);

  // later year values for raw_theta and theta
  for (t in 2:T) {
	  raw_theta[t] = raw_theta[t-1] + sd_theta_evolve * raw_theta_N01[t]; // transition model
	  theta[t] = inv_logit(raw_theta[t]); // scale to [0, 1]
  }

  for (n in 1:N) {                    // expand theta to N-vector
  	theta_tt_kk[n] = raw_theta[tt[n], kk[n]];
  }

  eta = inv_logit((theta_tt_kk - beta[qq] + delta[pp]) ./ alpha[qq]);  // fitted values model
  a = phi * eta; 						          // reparamaterise beta-binomial alpha par
  b = phi * (1 - eta); 					      // reparamaterise beta-binomial beta par
}

model{
  y_r ~ beta_binomial(n_r, a, b); 		// response model
  phi ~ gamma(4, 0.1);
  sd_theta_evolve ~ std_normal();
  sigma_delta ~ std_normal();
  theta_init ~ std_normal();
  delta_raw ~ std_normal();
  for (t in 1:T) {
    raw_theta_N01[t] ~ std_normal();
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
