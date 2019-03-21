using JuMP, JSON, Ipopt


d = JSON.Parser.parsefile("m2_5_data.json")


function parse_data(key)
    x = Dict()

    if d[key]["type"] == "GamsSet"
        if d[key]["dimension"] == 1
            x = d[key]["elements"]
            return x
        end
    end

    # need to work on import multidimentional sets (i.e., mappings)

    if d[key]["type"] == "GamsParameter"
        if d[key]["dimension"] == 0
            x = d[key]["values"]
            return x
        end

        if d[key]["dimension"] == 1
            for i in 1:length(d[key]["values"]["domain"])
                a = d[key]["values"]["domain"][i]
                x[a] = d[key]["values"]["data"][i]
            end
            return x
        end

        if d[key]["dimension"] > 1
            for i in 1:length(d[key]["values"]["domain"])
                a = tuple(d[key]["values"]["domain"][i]...)
                x[a] = d[key]["values"]["data"][i]
            end
        return x
        end
    end
end

# data pull
LBAR = parse_data("LBAR")
a = parse_data("ALPHA")



# model object
GE_NLP = Model(with_optimizer(Ipopt.Optimizer, print_level = 0))

# add variables and initial point to model object
@variable(GE_NLP, P >= 0, start=1)
@variable(GE_NLP, X >= 0, start=200)
@variable(GE_NLP, W)
@variable(GE_NLP, INCOME >= 0, start=100)
@variable(GE_NLP, U, start=100)


# add constartins to model object
@NLparameter(GE_NLP, ALPHA == a)
@NLconstraint(GE_NLP, UTILITY, U == X^0.5 )
@NLconstraint(GE_NLP, ZPROFIT, W / ALPHA >= P)
@NLconstraint(GE_NLP, CMKTCLEAR, X >= INCOME / P )
@NLconstraint(GE_NLP, LMKTCLEAR, LBAR >= X / ALPHA )
@NLconstraint(GE_NLP, CONSINCOME, INCOME >= W * LBAR )

# add in objective
@NLobjective(GE_NLP, Max, U)

# fix numeraire
fix(W, 1)

# output model in a human readable format
print(GE_NLP)

# solve the model
optimize!(GE_NLP)


# post processing / output solution check
print(termination_status(m))
print(primal_status(m))
print(dual_status(m))


report = Dict()

report["bmk","X"] = value(X)
report["bmk","P"] = value(P)
report["bmk","W"] = value(W)
report["bmk","INCOME"] = value(INCOME)
report["bmk","U"] = value(U)



# SOLVE #2: double the labor productivity
set_value(ALPHA, 2 * a)
optimize!(GE_NLP)

report["solve_2","X"] = value(X)
report["solve_2","P"] = value(P)
report["solve_2","W"] = value(W)
report["solve_2","INCOME"] = value(INCOME)
report["solve_2","U"] = value(U)



# SOLVE #3: change the numeraire
set_value(ALPHA, a)
fix(P, 1, force=true)
unfix(W)
@constraint(GE_NLP, W >= 0)

optimize!(GE_NLP)

report["solve_3","X"] = value(X)
report["solve_3","P"] = value(P)
report["solve_3","W"] = value(W)
report["solve_3","INCOME"] = value(INCOME)
report["solve_3","U"] = value(U)


# SOLVE #4: double the labor productivity again
set_value(ALPHA, 2 * a)
optimize!(GE_NLP)

report["solve_4","X"] = value(X)
report["solve_4","P"] = value(P)
report["solve_4","W"] = value(W)
report["solve_4","INCOME"] = value(INCOME)
report["solve_4","U"] = value(U)
