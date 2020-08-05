## Version 0.5.0
1. Initial release to CRAN.

## Version 0.5.1
1. The package now exports `demsup_data` so that the examples do not need to create it (this makes CRAN happy).

## Version 0.5.2
1. Revise examples to work consistently on CRAN's test suite

## Version 0.5.3
1. Revise examples again to work within CRAN constraints

## Version 0.5.4
1. Update for R v4.0 and accompanying revisions to rstan ecosystem in v2.19.3
1. Fix a bug in dcpo_xvt() that would cause the function to fail when all of the data for a country was randomly assigned to a single fold
