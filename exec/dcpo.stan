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
}

parameters {
  vector[K*T] theta_raw; // non-centered public opinion ("ability")
  vector<lower=0>[R] alpha; // discrimination of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using 1/alpha))
  vector[Q] beta1; // difficulty of first cutpoint for question q (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  vector<lower=0>[R-Q] beta2; // difficulty of any additional question-cutpoints for question q (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  real<lower=0> sigma_theta[K]; 	// country variance parameter (see Linzer and Stanton 2012, 12)
}

transformed parameters {
  vector[R] beta; // difficulty of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  vector[K*T] theta; // public opinion ("ability")

  beta[1] = beta1[1];
  for (r in 2:R) {
    if (rq[r] != rq[r-1]) {
      beta[r] = beta1[rq[r]];
    } else {
      beta[r] = beta[r-1] + beta2[r - rq[r]];
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
  alpha ~ lognormal(1, 1);
  beta1 ~ normal(0, 1);
  beta2 ~ normal(0, 1);

  // transition model
  theta_raw ~ normal(0, 1);

  // measurement model
  y_r ~ binomial_logit(n_r, alpha[rr] .* (theta[kktt] - beta[rr])); // likelihood

}

generated quantities {
  vector[N] pred_prob;

  // Simulations from the posterior predictive distribution (in my tests, vectorizing this was slower)
  for (n in 1:N) {
    pred_prob[n] = inv_logit(alpha[rr[n]] .* (theta[kktt[n]] - beta[rr[n]]));
  }
}
