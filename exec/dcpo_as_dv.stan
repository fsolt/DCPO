// _as_dv additions drawn from Furr (2017) http://mc-stan.org/users/documentation/case-studies/rasch_and_2pl.html

functions {
  matrix obtain_adjustments(matrix W) {
    real min_w;
    real max_w;
    int minmax_count;
    matrix[2, cols(W)] adj;
    adj[1, 1] = 0;
    adj[2, 1] = 1;
    if(cols(W) > 1) {
      for(k in 2:cols(W)) {                       // remaining columns
        min_w = min(W[1:rows(W), k]);
        max_w = max(W[1:rows(W), k]);
        minmax_count = 0;
        for(j in 1:rows(W))
          minmax_count = minmax_count + W[j,k] == min_w || W[j,k] == max_w;
        if(minmax_count == rows(W)) {       // if column takes only 2 values
          adj[1, k] = mean(W[1:rows(W), k]);
          adj[2, k] = (max_w - min_w);
        } else {                            // if column takes > 2 values
          adj[1, k] = mean(W[1:rows(W), k]);
          adj[2, k] = sd(W[1:rows(W), k]) * 2;
        }
      }
    }
    return adj;
  }
}

data {
  int<lower=1> K;     			    // number of countries
  int<lower=1> T; 				      // number of years
  int<lower=1> Q; 				      // number of questions
  int<lower=1> R;         		  // number of question-cutpoints
  int<lower=1> N; 				      // number of KTQR observations
  int<lower=1, upper=K> kk[N]; 	// country for observation n
  int<lower=1, upper=T> tt[N]; 	// year for observation n
  int<lower=1> kktt[N];         // country-year for observation n
  int<lower=1, upper=Q> qq[N];  // question for observation n
  int<lower=1, upper=R> rr[N]; 	// question-cutpoint for observation n
  int<lower=1, upper=Q> rq[R];  // question for question-cutpoint r
  int<lower=1> rcp[R]; 			    // cutpoint for question-cutpoint r
  int<lower=0> y_r[N];    		  // number of respondents giving selected answer for observation n
  int<lower=0> n_r[N];    		  // total number of respondents for observation n
  int<lower=1> V;               // number of independent variables
  matrix[K*T, V] W;              // matrix of country-year independent variables
}

transformed data {
  matrix[2, V] adj;              // values for centering and scaling independent variables
  matrix[K*T, V] W_adj;          // centered and scaled independent variables
  adj = obtain_adjustments(W);
  for(kt in 1:(K*T)) for(v in 1:V)
      W_adj[v, kt] = (W[v, kt] - adj[1, kt]) / adj[2, kt];
}

parameters {
  vector[K*T] theta_raw; 			// non-centered public opinion ("ability")
  vector[2] xi[R]; 					  // alpha/beta (discrimination/difficulty) pair vectors
  vector[2] mu; 					    // vector for alpha/beta means
  vector<lower=0>[2] tau; 		// vector for alpha/beta residual sds
  cholesky_factor_corr[2] L_Omega;	// Cholesky decomposition of the correlation matrix for log(alpha) and beta
  real<lower=0> sigma_theta[K]; 	  // country variance parameter (see Linzer and Stanton 2012, 12)
  vector[V] lambda_adj;       // vector for adjusted regression coefficients
}

transformed parameters {
  vector[R] alpha; 		// discrimination of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using 1/alpha))
  vector[R] beta; 		// difficulty of question-cutpoint r (see Stan Development Team 2015, 61; Gelman and Hill 2007, 314-320; McGann 2014, 118-120 (using lambda))
  vector[K*T] theta; 	// public opinion ("ability")

  alpha[1] = exp(xi[1,1]);
  beta[1] = xi[1,2];

  for (r in 2:R) {
    alpha[r] = exp(xi[r,1]);
  	if (rq[r] == rq[r-1]) {
  	  beta[r] = beta[r-1] + exp(xi[r,2]);
  	} else {
  	  beta[r] = xi[r,2];
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
  lambda_adj ~ student_t(3, 0, 1);

  // transition model
  theta_raw ~ normal(0, 1);

  // regression model
  theta ~ normal(W_adj * lambda_adj, 1);

  // measurement model
  y_r ~ binomial_logit(n_r, alpha[rr] .* (theta[kktt] - beta[rr])); // likelihood

}

generated quantities {
  vector[V] lambda;
  corr_matrix[2] Omega;
  vector[N] pred_prob;

  lambda[2:V] = lambda_adj[2:V] ./ to_vector(adj[2, 2:V]);
  lambda[1] = W_adj[1, 1:V] * lambda_adj[1:V] - W[1, 2:V] * lambda[2:V];

  Omega = multiply_lower_tri_self_transpose(L_Omega);

  // Simulations from the posterior predictive distribution (in my tests, vectorizing this was slower)
  for (n in 1:N) {
    pred_prob[n] = inv_logit(alpha[rr[n]] .* (theta[kktt[n]] - beta[rr[n]]));
  }
}
