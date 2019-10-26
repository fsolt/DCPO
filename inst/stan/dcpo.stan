data{
  int<lower=1> K;                     // number of countries
  int<lower=1> T;                     // number of years
  int<lower=1> Q;                     // number of questions
  int<lower=1> R;                     // maximum number of response cutpoints
  int<lower=1> N;                     // number of KTQR observations
  int<lower=1, upper=K> kk[N];        // country k for opinion n
  int<lower=1, upper=T> tt[N];        // year t for opinion n
  int<lower=1, upper=Q> qq[N];        // question q for opinion n
  int<lower=1, upper=R> rr[N];        // response cutpoint r for opinion n
  int<lower=1> y_r[N];                // vector of survey responses, cumulative count
  int<lower=1> n_r[N];                // vector of sample sizes
  int fixed_cutp[Q, R];               // indicates single category with difficulty fixed to .5
  vector<lower=0, upper=1>[K] use_delta[Q]; // indicates multiple years observed of question q in country k
}

parameters{
  vector<lower=0>[Q] alpha;           // question discrimination
  row_vector<lower=0>[Q] raw_beta[R]; // question-response difficulty component
  row_vector[Q] beta_init;            // initial question-response difficulty component, for first response
  vector[K] raw_delta_N01[Q];         // question-country difficulty component
  real<lower=0> sd_delta;             // question-country difficulty component variation
  row_vector[K] raw_theta_N01[T];     // public opinion, before transition model, std normal scale
  real<lower=0> sd_theta_evolve;      // public opinion evolution
  row_vector[K] theta_init;           // initial public opinion, for first year
  row_vector[K] raw_sigma_N01[T];     // raw public opinion std deviation, before transition model, std normal scale
  real<lower=0> sd_sigma_evolve;      // raw public opinion std deviation evolution
  row_vector[K] raw_sigma_init;       // initial raw public opinion std deviation, for first year
  real<lower=0> phi;                  // response model beta-binomial dispersion parameter
}

transformed parameters{
  row_vector[Q] beta[R];              // question-response difficulty component
  vector[N] beta_rr_qq;               // N-vector for question-response difficulty component
  vector[K] raw_delta[Q];             // question-country difficulty component, std normal prior
  vector[Q] mean_raw_delta;           // mean question-country difficulty component, std normal prior, by question
  vector[K] delta[Q];                 // question-country difficulty component, mean centered by question
  vector[N] delta_qq_kk;              // N-vector for question-country difficulty component values
  row_vector[K] raw_theta[T]; 	      // public opinion, after transition model
  row_vector[K] theta[T]; 	          // public opinion, after transition model, on [0, 1] scale
  vector[N] raw_theta_tt_kk;				  // N-vector for raw public opinion values
  row_vector[K] raw_sigma[T];         // raw public opinion std deviation, after transition model
  row_vector[K] sigma[T];             // public opinion std deviation, after transition model
  vector[N] sigma_tt_kk;				      // N-vector for public opinion std deviation values
  vector<lower=0,upper=1>[N] eta;     // fitted values, on logit scale
  vector<lower=0>[N] a;					      // response model beta-binomial alpha parameter
  vector<lower=0>[N] b;					      // response model beta-binomial beta parameter

  // difficulty
  for (q in 1:Q) {
    // ordered beta from (unordered) beta_raw, with fixed cut point
    for (r in 1:R) {
      if (fixed_cutp[q, r] == 1) {
        beta[r, q] = 1;
      } else {
        if (r == 1) {
          beta[r, q] = beta_init[q];
        } else {
          beta[r, q] = beta[r-1, q] + raw_beta[r, q];
        }
      }
    }
    // delta, with mean zero for each question
    raw_delta[q] = sd_delta * raw_delta_N01[q] .* use_delta[q]; // implies raw_delta ~ normal(0, sd_delta), but only if use_delta == 1
    mean_raw_delta[q] = mean(raw_delta[q]);
    for (k in 1:K) {
      delta[q, k] = raw_delta[q, k] - mean_raw_delta[q];
    }
  }

  // first year values for raw_theta, theta, raw_sigma, and sigma
  raw_theta[1] = theta_init;
  theta[1] = inv_logit(raw_theta[1] - 1); // scale to [0, 1]; raw_theta = 1 -> 50% agreement when beta = 1
  raw_sigma[1] = raw_sigma_init;
  sigma[1] = exp(raw_sigma[1]); // implies sigma ~ lognormal(raw_sigma[t-1], sd_sigma_evolve)

  // later year values for raw_theta, theta, raw_sigma, and sigma
  for (t in 2:T) {
	  raw_theta[t] = raw_theta[t-1] + sd_theta_evolve * raw_theta_N01[t]; // transition model, implies raw_theta[t] ~ normal(raw_theta[t-1], sd_theta_evolve)
	  theta[t] = inv_logit(raw_theta[t] - 1); // scale to [0, 1]; raw_theta = 1 -> 50% agreement when beta = 1
	  raw_sigma[t] = raw_sigma[t-1] + sd_sigma_evolve * raw_sigma_N01[t]; // transition model, implies raw_sigma[t] ~ normal(raw_sigma[t-1], sd_sigma_evolve)
	  sigma[t] = exp(raw_sigma[t]); // implies sigma[t] ~ lognormal(raw_sigma[t-1], sd_sigma_evolve)
  }

  for (n in 1:N) {                            // N-vector expansion
  	beta_rr_qq[n] = beta[rr[n], qq[n]];
  	delta_qq_kk[n] = delta[qq[n], kk[n]];
  	raw_theta_tt_kk[n] = raw_theta[tt[n], kk[n]];
  	sigma_tt_kk[n] = sigma[tt[n], kk[n]];
  }

  // fitted values model
  eta = inv_logit((raw_theta_tt_kk - (beta_rr_qq + delta_qq_kk)) ./ sqrt(square(1.7 * sigma_tt_kk) + square(alpha[qq])));
  a = phi * eta;
  b = phi * (1 - eta);
}

model{
  y_r ~ beta_binomial(n_r, a, b); 		// response model
  phi ~ gamma(4, 0.1);

  alpha ~ std_normal();
  beta_init ~ std_normal();
  for (r in 1:R) {
    raw_beta[r] ~ std_normal();
  }
  for (q in 1:Q) {
    raw_delta_N01[q] ~ std_normal();
  }
  sd_delta ~ std_normal();
  theta_init ~ std_normal();
  raw_sigma_init ~ std_normal();
  for (t in 1:T) {
    raw_theta_N01[t] ~ std_normal();
    raw_sigma_N01[t] ~ std_normal();
  }
  sd_theta_evolve ~ std_normal();
  sd_sigma_evolve ~ std_normal();
}

generated quantities {
  vector[N] y_r_pred;					        // fitted data to check model
  vector[N] log_lik;					        // log likelihood for WAIC calculation
  for (n in 1:N) {
    y_r_pred[n] = beta_binomial_rng(n_r[n], a[n], b[n]);
    log_lik[n] = beta_binomial_lpmf(y_r[n] | n_r[n], a[n], b[n]);
  }
}
