data{
  int<lower=1> K;                     // number of countries
  int<lower=1> T;                     // number of years
  int<lower=1> Q;                     // number of questions
  int<lower=1> R;                     // number of question-response categories
  int<lower=1> P;                     // number of question-country combinations
  int<lower=1> N;                     // number of KTQR observations
  int<lower=1, upper=K> kk[N];        // country j for opinion n
  int<lower=1, upper=T> tt[N];        // year t for opinion n
  int<lower=1, upper=Q> qq[N];        // item k for opinion n
  int<lower=1, upper=R> rr[N];        // question-response category r for opinion n
  int<lower=1, upper=Q> rq[R];        // question for question-response category r
  int<lower=1> rc[R];                 // response category for question-response category r
  int<lower=1, upper=P> pp[N];        // item-country p for opinion n
  int<lower=1> y_r[N];                // vector of survey responses, cumulative count
  int<lower=1> n_r[N];                // vector of sample sizes
}

parameters{
  vector<lower=0>[Q] alpha;           // item discrimination
  vector<lower=0>[R] beta_raw;        // question-response difficulty component
  vector[Q] beta_init;                // initial question-response difficulty component, for first response
  vector[P] delta_raw;					      // question-country difficulty component
  real<lower=0> sd_delta;	            // question-country difficulty component variation
  row_vector[K] raw_theta_N01[T]; 	  // public opinion, before transition model, std normal scale
  real<lower=0> sd_theta_evolve;	    // public opinion evolution
  row_vector[K] theta_init;				    // initial public opinion, for first year
  real<lower=0> phi;					        // beta-binomial dispersion parameter
  row_vector<lower=0, upper=.5>[K] raw_sigma[T]; // opinion variance, before transition model
  real<lower=0, upper=.1> sd_sigma_evolve; // opinion variance evolution
  row_vector<lower=0, upper=.5>[K] sigma_init; // initial opinion variance, for first year
}

transformed parameters{
  vector[R] beta;                     // question-response difficulty component
  row_vector[K] raw_theta[T]; 	      // public opinion, after transition model
  row_vector[K] theta[T]; 	          // public opinion, after transition model, on [0, 1] scale
  vector[N] raw_theta_tt_kk;				  // N-vector for raw public opinion values
  row_vector[K] sigma[T];             // opinion variance
  vector[N] sigma_tt_kk;				      // N-vector for expanded raw opinion variance values
  vector<lower=0,upper=1>[N] eta;     // fitted values, on logit scale
  vector[P] delta;						        // item-country difficulty component
  vector<lower=0>[N] a;					      // beta-binomial alpha parameter
  vector<lower=0>[N] b;					      // beta-binomial beta parameter

  for (r in 1:R) {
    if (rc[r] == 1) {
      beta[r] = beta_init[rq[r]];
    } else {
      beta[r] = beta[r-1] + beta_raw[r];
    }
  }

  delta = sd_delta * delta_raw;    // parameter expansion for delta

  // first year values for raw_theta, theta, and sigma
  raw_theta[1] = theta_init;
  theta[1] = inv_logit(theta_init);
  sigma[1] = square(sigma_init);

  // later year values for raw_theta, theta, and sigma
  for (t in 2:T) {
	  raw_theta[t] = raw_theta[t-1] + sd_theta_evolve * raw_theta_N01[t]; // transition model
	  theta[t] = inv_logit(raw_theta[t]); // scale to [0, 1]
	  sigma[t] = square(raw_sigma[t-1] + sd_sigma_evolve * raw_sigma[t]); // transition model
  }

  for (n in 1:N) {                    // expand raw_theta to N-vector
  	raw_theta_tt_kk[n] = raw_theta[tt[n], kk[n]];
  	sigma_tt_kk[n] = sigma[tt[n], kk[n]];
  }

  eta = inv_logit((raw_theta_tt_kk - beta[rr] + delta[pp]) ./ sqrt(sigma_tt_kk + square(alpha[qq])));  // fitted values model
  a = phi * eta; 						          // reparamaterise beta-binomial alpha par
  b = phi * (1 - eta); 					      // reparamaterise beta-binomial beta par
}

model{
  y_r ~ beta_binomial(n_r, a, b); 		// response model
  phi ~ gamma(4, 0.1);
  sd_theta_evolve ~ std_normal();
  sd_delta ~ std_normal();
  theta_init ~ std_normal();
  delta_raw ~ std_normal();
  for (t in 1:T) {
    raw_theta_N01[t] ~ std_normal();
  }
  beta_init ~ std_normal();
  beta_raw ~ std_normal();
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
