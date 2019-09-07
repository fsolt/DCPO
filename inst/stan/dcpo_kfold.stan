data{
  int<lower=1> K;                     // number of countries
  int<lower=1> T;                     // number of years
  int<lower=1> Q;                     // number of questions
  int<lower=1> R;                     // maximum number of response cutpoints
  int<lower=1> N;                     // number of KTQR observations, training set
  int<lower=1, upper=K> kk[N];        // country k for opinion n
  int<lower=1, upper=T> tt[N];        // year t for opinion n
  int<lower=1, upper=Q> qq[N];        // question q for opinion n
  int<lower=1, upper=R> rr[N];        // response cutpoint r for opinion n
  int<lower=1> y_r[N];                // vector of survey responses, cumulative count
  int<lower=1> n_r[N];                // vector of sample sizes
  int<lower=1> N_test;                // number of KTQR observations, testing set
  int<lower=1, upper=K> kk_test[N_test]; // country k for opinion n, testing set
  int<lower=1, upper=T> tt_test[N_test]; // year t for opinion n, testing set
  int<lower=1, upper=Q> qq_test[N_test]; // question q for opinion n, testing set
  int<lower=1, upper=R> rr_test[N_test]; // response cutpoint r for opinion n, testing set
  int<lower=1> n_r_test[N_test];      // vector of sample sizes, testing set
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
  row_vector[K] raw_sigma_N01[T];     // opinion variance, before transition model
  real<lower=0> sd_sigma_evolve;      // opinion variance evolution
  row_vector[K] sigma_init;           // initial opinion variance, for first year
  real<lower=0> phi;                  // response model beta-binomial dispersion parameter
}

transformed parameters{
  row_vector[Q] beta[R];              // question-response difficulty component
  vector[N] beta_rr_qq;               // N-vector for question-response difficulty component
  vector[N_test] beta_rr_qq_test;     // N-vector for question-response difficulty component, test set
  vector[K] raw_delta[Q];             // question-country difficulty component, std normal prior
  vector[Q] mean_raw_delta;           // mean question-country difficulty component, std normal prior, by question
  vector[K] delta[Q];                 // question-country difficulty component, mean centered by question
  vector[N] delta_qq_kk;              // N-vector for question-country difficulty component values
  vector[N_test] delta_qq_kk_test;    // N-vector for question-country difficulty component values, test set
  row_vector[K] raw_theta[T]; 	      // public opinion, after transition model
  row_vector[K] theta[T]; 	          // public opinion, after transition model, on [0, 1] scale
  vector[N] raw_theta_tt_kk;				  // N-vector for raw public opinion values
  vector[N_test] raw_theta_tt_kk_test;// N-vector for raw public opinion values, test set
  row_vector[K] raw_sigma[T];         // public opinion variance, after transition model
  row_vector[K] sigma[T];             // public opinion variance, after transition model, on [0, .25] scale
  vector[N] sigma_tt_kk;				      // N-vector for opinion variance values
  vector[N_test] sigma_tt_kk_test;		// N-vector for opinion variance values, test set
  vector<lower=0,upper=1>[N] eta;     // fitted values, on logit scale
  vector<lower=0,upper=1>[N_test] eta_test; // fitted values, on logit scale, test set
  vector<lower=0>[N] a;					      // response model beta-binomial alpha parameter
  vector<lower=0>[N_test] a_test;			// response model beta-binomial alpha parameter, test set
  vector<lower=0>[N] b;					      // response model beta-binomial beta parameter
  vector<lower=0>[N_test] b_test;			// response model beta-binomial beta parameter, test set

  // difficulty
  for (q in 1:Q) {
    // ordered beta from (unordered) beta_raw, with fixed cut point
    for (r in 1:R) {
      if (fixed_cutp[q, r] == 1) {
        beta[r, q] = .5;
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
  theta[1] = Phi_approx(theta_init - .5);
  raw_sigma[1] = sigma_init;
  sigma[1] = Phi_approx(sigma_init) * .25;

  // later year values for raw_theta, theta, raw_sigma, and sigma
  for (t in 2:T) {
	  raw_theta[t] = raw_theta[t-1] + sd_theta_evolve * raw_theta_N01[t]; // transition model, implies raw_theta[t] ~ normal(raw_theta[t-1], sd_theta_evolve)
	  theta[t] = Phi_approx(raw_theta[t] - .5);  // scale to [0, 1]
	  raw_sigma[t] = raw_sigma[t-1] + sd_sigma_evolve * raw_sigma_N01[t]; // transition model, implies raw_sigma[t] ~ normal(raw_sigma[t-1], sd_sigma_evolve)
	  sigma[t] = Phi_approx(raw_sigma[t]) * .25; // scale to [0, .25]
  }

  for (n in 1:N) {                            // N-vector expansion
  	beta_rr_qq[n] = beta[rr[n], qq[n]];
  	delta_qq_kk[n] = delta[qq[n], kk[n]];
  	raw_theta_tt_kk[n] = raw_theta[tt[n], kk[n]];
  	sigma_tt_kk[n] = sigma[tt[n], kk[n]];
  }

  for (n in 1:N_test) {                       // N-vector expansion, test set
  	beta_rr_qq_test[n] = beta[rr_test[n], qq_test[n]];
  	delta_qq_kk_test[n] = delta[qq_test[n], kk_test[n]];
  	raw_theta_tt_kk_test[n] = raw_theta[tt_test[n], kk_test[n]];
  	sigma_tt_kk_test[n] = sigma[tt_test[n], kk_test[n]];
  }

  // fitted values model
  eta = inv_logit((raw_theta_tt_kk - (beta_rr_qq + delta_qq_kk)) ./ sqrt(sigma_tt_kk + square(alpha[qq])));
  a = phi * eta;
  b = phi * (1 - eta);

  // fitted values model, test set
  eta_test = inv_logit((raw_theta_tt_kk_test - (beta_rr_qq_test + delta_qq_kk_test)) ./ sqrt(sigma_tt_kk_test + square(alpha[qq_test])));
  a_test = phi * eta_test;
  b_test = phi * (1 - eta_test);
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
  sigma_init ~ std_normal();
  for (t in 1:T) {
    raw_theta_N01[t] ~ std_normal();
    raw_sigma_N01[t] ~ std_normal();
  }
  sd_theta_evolve ~ std_normal();
  sd_sigma_evolve ~ std_normal();
}

generated quantities {
  vector[N_test] y_r_test;					        // fitted data to check model
  for (n in 1:N_test) {
    y_r_test[n] = beta_binomial_rng(n_r_test[n], a_test[n], b_test[n]);
  }
}
