would we imagine that individual trees are variable around this as well? so max size shows up as a factor. If individuals have variable max size between individuals, and different growth rates as well, that will create variation..

is this the function we could also use to model the growth of indivuals out of the size interval iand into the  -- I mean out of the small size intervals and into the large, more detectable one? maybe. I supose that since we don't know the distribution of k, then we would have to marginalize over it.

is that where all probability distirbutions come from marginalizing over unknowns?





 Today Will and I realized that modelling Ingrow is interesting because we can write down an expression for size at time 2, given size at time t1 and the parameters of the growth equation. 

thus the ingrow of the seedlings depends on the 
growth of the plants. and also their mortality. 

so what is the probability of size 2 being greater than or equal to the cutoff (that is, 1 - Pr(size at t2 is < 12) as another way to put it. 
but integrated over the probable values of t1  (that is, over that quantile of the size distribution function). 

But how exactly do to that? from t1 = 0 to t1 < 12.5, I would need to get the probability that the size at time 2 over the time specified would be above 12.5

remember the probability that a tree of size s grows to at least 12.5 is the product of the probability that it is size s at time t and the probability that it is size 12.5 at t2, 

(1 - Pr(12.5| s, k, delta t, Lmax)) X Pr(s | mean, var)

integrated over all s.
the result would be a probability. the second term is a tail of a distribution -- its the cdf 

product rule
(1 - Pr(12.5| s, k, delta t, Lmax)) * cdf(pr(s | mean, var)) - INTEGRAL over (wtf is the derivative of a probability distribution * cdf(pr( s |  mean, var)) 

looks like taking a derivative of a PDF is a thing that people do -- though not obviously already a defined function

nah I don't get it -- why does the s stay, and not go away. shouldn't integrating over something make it drop out? I think I'm not understanding this. properly. 

but this is not all that regcruitment would be -- it is not just growth but also mortality, a probability that you don't make it at all. 
