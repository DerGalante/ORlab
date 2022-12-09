using LinearAlgebra

include("helper_functions.jl");

# You can hover over get_input_data to see the documentation 
# (or use the help mode in the repl)
Q,q,x,α = get_input_data(100;no_affine=true);

# This is the function to be minimized
f(Q,q,x) = 0.5 * dot(x,Q,x) + q'*x

# This gives us the current value
f(Q,q,x)

function gradient_descent(Q,q,x,α,iterations)
    iteration = 0
    print_objective_f(Q,q,x,iteration;force = true)
    ### your code here ###
end

gradient_descent(Q,q,x,α,1000)
