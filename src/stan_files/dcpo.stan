data {
  int<lower=1> K;     			    // number of countries
  int<lower=1> T; 				      // number of years
  int<lower=1> Q; 				      // number of questions
  int<lower=1> R;         	  	// number of question-cutpoints
  int<lower=1> S;               // number of country-questions
  int<lower=1> N; 				      // number of KTQR observations
  int<lower=1, upper=K> kk[N]; 	// country for observation n
  int<lower=1, upper=T> tt[N]; 	// year for observation n
  int<lower=1> kktt[N];         // country-year for observation n
  int<lower=1, upper=Q> qq[N];  // question for observation n
  int<lower=1, upper=R> rr[N]; 	// question-cutpoint for observation n
  int<lower=1, upper=S> ss[N];  // country-question for observation n
  int<lower=1, upper=Q> rq[R];  // question for question-cutpoint r
  int<lower=0, upper=Q> r_fixed;  // question-cutpoint with difficulty fixed at .5
  int<lower=1> rcp[R]; 		    	// cutpoint for question-cutpoint r
  int<lower=0> y_r[N];      		// number of respondents giving selected answer for observation n
  int<lower=0> n_r[N];    	  	// total number of respondents for observation n
}

parameters {
  vector[K*T] theta_raw; 		  	// non-centered public opinion ("ability")
  vector[2] xi[R]; 				    	// alpha/beta (discrimination/difficulty) pair vectors
  vector[2] mu; 				      	// vector for alpha/beta means
  vector<lower=0>[2] tau; 			// vector for alpha/beta residual sds
  cholesky_factor_corr[2] L_Omega;	// Cholesky decomposition of the correlation matrix for log(alpha) and beta
  real<lower=0> sigma_theta[K]; // country-specific error variance parameter (see Linzer and Stanton 2012, 12)
  real<lower=0> sigma_delta;    // country-question-cutpoint intercept error variance
  vector[S] delta_raw;					// raw country-question-cutpoint intercepts
}

transformed parameters {
  vector[R] alpha; 		// discrimination of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using 1/alpha))
  vector[R] beta; 		// difficulty of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  vector[K*T] theta; 	// public opinion ("ability")
  vector[S] delta;    // country-question-cutpoint intercepts
  vector[N] pi;       // predicted probability

  alpha[1] = exp(xi[1,1]);
  beta[1] = xi[1,2];

  for (r in 2:R) {
    alpha[r] = exp(xi[r,1]);
    if (r == r_fixed) {       // set difficulty for scale question-cutpoint
      beta[r] = .5;
    } else {                  // difficulty for higher responses to same question must be greater
    	if (rq[r] == rq[r-1] && xi[r,2] < xi[r-1,2]) {
    	  beta[r] = beta[r-1];
    	} else {
    	  beta[r] = xi[r,2];    // difficulty for lowest response to any question
    	}
    }
  }

  delta = .00005 * sigma_delta * delta_raw;

  for (k in 1:K) {            // random walk prior for opinion
    theta[(k-1)*T+1] = theta_raw[(k-1)*T+1];  // first year in all countries
    for (t in 2:T) {
      theta[(k-1)*T+t] = theta[(k-1)*T+t-1] + .025 * sigma_theta[k] * theta_raw[(k-1)*T+t];
    }
  }

  pi = inv_logit(alpha[rr] .* (theta[kktt] - beta[rr]) + delta[ss]);
}

model {
  matrix[2,2] L_Sigma;
  L_Sigma = diag_pre_multiply(tau, L_Omega);
  for (r in 1:R) {
    xi[r] ~ multi_normal_cholesky(mu, L_Sigma);
  }
  sigma_theta ~ normal(0, 1);
  sigma_delta ~ cauchy(0, 1);
  L_Omega ~ lkj_corr_cholesky(4);
  mu[1] ~ normal(1, 1);
  tau[1] ~ exponential(.2);
  mu[2] ~ normal(-1, 1);
  tau[2] ~ exponential(.2);
  delta_raw ~ normal(0, 1);

  // transition model
  theta_raw ~ normal(0, 1);

  // measurement model
  y_r ~ binomial_logit(n_r, pi);   // likelihood

}

generated quantities {
  vector[N] y_r_pred;
  vector[N] log_likelihood;

  // Simulations from the posterior predictive distribution (in my tests, vectorizing this was slower)
  for (n in 1:N) {
    y_r_pred[n] = binomial_rng(n_r[n], pi[n]);
    log_likelihood[n] = binomial_lpmf(y_r[n] | n_r[n], pi[n]);
  }
}
