

example2_list = list(
  
  index_date = node(
    variable_formula = ~"2020-01-01",
    keep = FALSE
  ),
  end_date = node(
    variable_formula = ~"2020-10-01",
    keep = FALSE
  ),
  region = node(
    variable_formula = ~rcat(n=1, levels=c("N", "S", "E", "W"), p = c(0.1,0.2,0.3,0.4))
  ),
  age = node(
    variable_formula = ~floor(rnorm(n=1, mean=60, sd=15))
  ),
  sex = node(
    variable_formula = ~rcat(n=1, levels = c("F", "M"), p = c(0.51, 0.49)),
    missing_rate = ~0.1 # this is shorthand for ~(rbernoulli(n=1, p = 0.2))
  ),
  diabetes = node(
    variable_formula = ~rbernoulli(n=1, p = plogis(-1 + age*0.02 + I(sex=='F')*-0.2))*1
  ),
  hosp_admission_count = node(
    variable_formula = ~rpois(n = 1, lambda = exp(-2.5 + age*0.03 + I(sex=='F')*-0.2 +diabetes*1)),
    missing_rate = ~plogis(-2 + I(!diabetes)*0.5)
  ),
  time_to_death = node(
    variable_formula = ~rexp(n=1, rate = exp(-5 + age*0.01 + I(age^2)*0.0001 + diabetes*1.5 + hosp_admission_count*1)/365),
    keep = FALSE
  ),
  death_date = node(
    variable_formula = ~censor(as.Date(index_date) + time_to_death, end_date, na.censor=TRUE),
    missing_rate = ~0
  ),
  var2 = node(
    variable_formula = ~var1+4,
    needs = "death_date"
  )
)


known_data = tibble(
  var1 = rnorm(1000)
)

example2_pdag <- pdag_create(example2_list, c("var1"))

example2_simulation <- pdag_simulate(example2_pdag, data=known_data)
#example2_simulation <- pdag_simulate(example2_pdag, pop_size=20)




OS_data <- tibble(
  ptid = 1:1000,
  age = rnorm(n=1000, mean=60, sd=15),
  sex = rcat(n=1000, levels = c("F", "M"), p = c(0.51, 0.49))
)

OS_data

example3_list = list(
  diabetes = node(
    variable_formula = ~(rbernoulli(n=1, p = plogis(-1 + age*0.002 + I(sex=='F')*-0.2))),
  ),
  hosp_admission_count = node(
    variable_formula = ~(rpois(n=1, lambda = exp(-2.5 + age*0.03 + I(sex=='F')*-0.2 +diabetes*1)))
  ),
  time_to_death = node(
    variable_formula = ~(round(rexp(n=1, rate = exp(-5 + age*0.01 + I(age^2)*0.0001 + diabetes*1.5 + hosp_admission_count*1)/365))),
  )
)

example3_pdag <- pdag_create(example3_list, known_variables = c( "age", "sex"))
example3_simulation <- pdag_simulate(example3_pdag, data=OS_data)





df <- example2_list %>%
  enframe(name="variable", value="list") %>% 
  unnest_wider("list", simplify=TRUE)

df$needs = map(df$needs, ~{if(is.na(.)) character() else . })

df$needs=list(character())


View(df[[2]][[10]])


