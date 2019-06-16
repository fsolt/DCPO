functions {
  real p2l_real (real x) {      // coverts scalar from probit to logit scale
    real y;
    y = 0.07056 * pow(x, 3) + 1.5976 * x;
    return y;
  }
  vector p2l_vector (vector x) { // coverts vector from probit to logit scale
    vector[num_elements(x)] y;
    for (i in 1:num_elements(x)) {
      y[i] = 0.07056 * pow(x[i], 3) + 1.5976 * x[i];
    }
    return y;
  }
}

data {
  int<lower=1> K;               // number of countries
  int<lower=1> T;               // number of years
  int<lower=1> Q;               // number of questions
  int<lower=1> R;               // maximum number of response categories
  real<lower=0> N[T, K, Q, R]; 	// number of KTQR observations
  int unused_cut[Q, (R-1)];     // indicates categories with no responses
  int fixed_cutp[Q, (R-1)];     // indicates single category with difficulty fixed to .5
  int<lower=0> N_nonzero;
}

parameters {
  real raw_bar_theta_N01[T, K];     // country means (on N(0,1) scale, without random walk)
  real<lower=0> alpha[Q, 1];      // question discrimination
  ordered[R-1] raw_beta[Q];         // response difficulty (before fixed_cutp)
  vector<lower=0>[1] sd_theta_N01;  // standard normal
  vector<lower=0>[1] sd_theta_IG;   // inverse-gamma
  real<lower=0> sd_raw_bar_theta_evolve_N01;  // standard normal
  vector[K] sd_raw_bar_theta_evolve_N01_kk;   // standard normal by country
  real<lower=0> B_cut;              // slope for cutpoint prior
}

transformed parameters {
  // Declarations
  real raw_bar_theta[T, K];     // country means (on N(0,1) scale, with random walk)
  real bar_theta[T, K];         // country means (on [0, 1] scale)
  ordered[R-1] beta[Q];         // response difficulty
  vector[1] sd_theta;           // SD of theta
  vector<lower=0>[K] sd_raw_bar_theta_evolve;   // country-specific transition SD of theta
  cov_matrix[1] Sigma_theta;    // variance of theta
  // Assignments
  sd_theta = sd_theta_N01 .* sqrt(sd_theta_IG); // sd_theta ~ cauchy(0, 1);
  Sigma_theta = diag_matrix(sd_theta .* sd_theta);
  for (k in 1:K) {
    // sd_raw_bar_theta_evolve[k] via normal(0, 1) constant and normal(0, .2) country-level term;
    sd_raw_bar_theta_evolve[k] =
      sd_raw_bar_theta_evolve_N01 + sd_raw_bar_theta_evolve_N01_kk[k] * .2;
  }
  for (q in 1:Q) {
    for (r in 1:(R-1)) {
      if (fixed_cutp[q, r] == 1) {
        beta[q][r] = .5;
      } else {
        beta[q][r] = raw_beta[q, r];
      }
    }
  }
  for (k in 1:K) {
    raw_bar_theta[1, k] = raw_bar_theta_N01[1, k];
    bar_theta[1, k] = inv_logit(raw_bar_theta[1, k]); // scale
    for (t in 2:T) {
      // implies raw_bar_theta[t, k] ~ N(raw_bar_theta[t-1, k], sd_raw_bar_theta_evolve[k])
      raw_bar_theta[t, k] = raw_bar_theta[t-1, k] +
        sd_raw_bar_theta_evolve[k] * raw_bar_theta_N01[t, k];
      bar_theta[t, k] = inv_logit(raw_bar_theta[t, k]); // scale
    }
  }
}

model {
  vector[N_nonzero] loglike_summands; // to store log-likelihood for summation
  int N_pos = 0;
  // Priors
  for (q in 1:Q) {
    real used_cutp = R-1 - sum(unused_cut[q, 1:(R-1)]);
    real adjust_int = (used_cutp / 2) + .5;
    real adjust_slp = 1;
    if (used_cutp > 1) {
      adjust_slp = used_cutp - 1;
    }
    for (r in 1:(R-1)) {
      real priormean = 100 * unused_cut[q, r] + B_cut / adjust_slp * (r - adjust_int);
      raw_beta[q][r] ~ normal(priormean, 1);
    }
  }
  to_array_1d(raw_bar_theta_N01) ~ normal(0, 1);
  to_array_1d(alpha) ~ normal(0, 10);
  sd_theta_N01 ~ normal(0, 1);                      // sd_theta ~ cauchy(0, 1);
  sd_theta_IG ~ inv_gamma(0.5, 0.5);                // ditto
  sd_raw_bar_theta_evolve_N01 ~ normal(0, 1);       // constant term
  sd_raw_bar_theta_evolve_N01_kk ~ normal(0, 1);    // country-level term
  B_cut ~ normal(0, 1);
  // Likelihood
  for (r in 1:R) {
    for (q in 1:Q) {
      real z_denom = sqrt(1 + quad_form(Sigma_theta, to_vector(alpha[q])));
      vector[R-1] cut = p2l_vector(beta[q][1:(R-1)] / z_denom);
      for (k in 1:K) {
        for (t in 1:T) {
  	      if (N[t, k, q, r] > 0) {
      	    real eta;
      	    N_pos += 1;
      	    eta = p2l_real(alpha[q][1] * bar_theta[t, k] / z_denom);
      	    loglike_summands[N_pos] = N[t, k, q, r] * ordered_logistic_lpmf(r | eta, cut);
      	  }
        }
      }
    }
  }
  target += sum(loglike_summands);
}

