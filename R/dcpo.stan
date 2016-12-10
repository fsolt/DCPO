data {
  int<lower=1> K;     		// number of countries
  int<lower=1> T; 				// number of years
  int<lower=1> Q; 				// number of questions
  int<lower=1> R;         // number of question-cutpoints
  int<lower=1> N; 				// number of KTQR observations
  int<lower=1, upper=K> kk[N]; 	// country for observation n
  int<lower=1, upper=T> tt[N]; 	// year for observation n
  int<lower=1> kktt[N];         // country-year for observation n
  int<lower=1, upper=Q> qq[N];  // question for observation n
  int<lower=1, upper=R> rr[N]; 	// question-cutpoint for observation n
  int<lower=1, upper=R> rq[R];  // question for question-cutpoint r
  int<lower=1, upper=R> rcp[R]; // cutpoint for question-cutpoint r
  int<lower=0> y_r[N];    // number of respondents giving selected answer for observation n
  int<lower=0> n_r[N];    // total number of respondents for observation n
  int<lower=0, upper=1> rob;    // robust dynamic model indicator
	int<lower=0, upper=1> c_a;		// constant alpha indicator
}

parameters {
  vector[K*T] theta_raw; // non-centered public opinion ("ability")
  vector[2] xi[R]; // alpha/beta (discrimination/difficulty) pair vectors
  vector[2] mu; // vector for alpha/beta means
  vector<lower=0>[2] tau; // vector for alpha/beta residual sds
  cholesky_factor_corr[2] L_Omega; // Cholesky decomposition of the correlation matrix for log(alpha) and beta
  real<lower=0> sigma_theta[K]; 	// country variance parameter (see Linzer and Stanton 2012, 12)
}

transformed parameters {
  vector[R] alpha; // discrimination of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using 1/alpha))
  vector[R] beta; // difficulty of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  vector[K*T] theta; // public opinion ("ability")
  for (r in 1:R) {
    alpha[r] = exp(xi[r,1]);
    beta[r] = xi[r,2];
    if (r > 1) {
      if (rq[r]==rq[r-1]) {
        beta[r] = beta[r-1] + exp(beta[r]);
        if (c_a == 1) {
          alpha[r] = alpha[r-1];
        }
      }
    }
  }

  for (k in 1:K) {
    theta[(k-1)*T+1] = theta_raw[(k-1)*T+1];
    for (t in 2:T) {
      theta[(k-1)*T+t] = theta[(k-1)*T+t-1] + sigma_theta[k] * theta_raw[(k-1)*T+t];
    }
  }
}

model {
  matrix[2,2] L_Sigma;
  L_Sigma = diag_pre_multiply(tau, L_Omega);
  for (r in 1:R) {
    xi[r] ~ multi_normal_cholesky(mu, L_Sigma);
  }
  sigma_theta ~ normal(0, .05);
  L_Omega ~ lkj_corr_cholesky(4);
  mu[1] ~ normal(1, 1);
  tau[1] ~ exponential(.2);
  mu[2] ~ normal(-1, 1);
  tau[2] ~ exponential(.2);

  // transition model
  if (rob == 1) {  // robust dynamic prior (see Reuning, Kenwick, and Fariss 2016)
    theta_raw ~ student_t(10, 0, 1);
  } else { // standard dynamic prior
    theta_raw ~ normal(0, 1);
  }

  // measurement model
  y_r ~ binomial_logit(n_r, alpha[rr] .* (theta[kktt] - beta[rr])); // likelihood

}

generated quantities {
  corr_matrix[2] Omega;
  Omega = multiply_lower_tri_self_transpose(L_Omega);
}
