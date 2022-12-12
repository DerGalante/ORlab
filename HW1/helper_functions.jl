import Random
import Printf

"""
    get_input_data(dims; no_affine = false, seed = 123) 

Gets the matrix and stepsize data for gradient descent.

If the keyword argument no_affine is true, q is set to a vector of zeros.

In case you want to test your implementation on different values, other random parameters can be created by changing the seed argument.

# Example 1
```julia-repl
julia> Q,q,x,α = get_input_data(2);
julia> Q
2×2 Matrix{Float64}:
 64.4403  27.4023
 27.4023  46.1919
julia> q
2-element Vector{Float64}:
 0.4922456865251828
 0.9809798121241488
```
# Example 2
```julia-repl
julia> Q,q,x,α = get_input_data(2; no_affine = true);
julia> q
2-element Vector{Float64}:
 0.0
 0.0
```
# Example 3
```julia-repl
julia> Q,q,x,α = get_input_data(2; seed = 345);
julia> Q
2×2 Matrix{Float64}:
  0.520874  -0.682132
 -0.682132   1.19627
 julia> q
 2-element Vector{Float64}:
 -0.14768081976427083
 -0.04992428510992252
```
"""
function get_input_data(dims; no_affine = false, seed = 123)
    rng_q = Random.seed!(seed)
    Qᵣ = randn(rng_q, Float64, (dims,dims))
    Qᵣ = Qᵣ/maximum(Qᵣ)
    Q = Qᵣ*Qᵣ'
    isposdef(Q) || error("Random matrix not positive definite.")
    if no_affine
        q = zeros(dims)
    else
        q = randn(rng_q, Float64, (dims))
    end
    rng_x = Random.seed!(seed+1)
    x = randn(rng_x, Float64, (dims))
    α = 1e-2
    return Q, q, x, α
end

"""
    print_objective_f(Q,q,x,iteration; log_print_base = 2, force = false, grad_norm = false)

Prints the objective value for the respective iteration:

    f(x)= 0.5 * xᵀQx + qᵀx

By default, every 2ⁿ iteration is printed.

If the keyword argument force=true, the respecitve iteration is always printed. 

If a different log_print_base is provided, every log_print_baseⁿ iteration is actually printed. 

When specified by grad_norm=true, the norm of the gradient is printed additionally. This is not needed for this task. 

# Example 1
```julia-repl
julia> for iteration in 1:10
           print_objective_f(Q,q,x,iteration)
       end
Iteration         1:      f(x)= 4.41323005e+02
Iteration         2:      f(x)= 4.41323005e+02
Iteration         4:      f(x)= 4.41323005e+02
Iteration         8:      f(x)= 4.41323005e+02
```
# Example 2
```julia-repl
julia> for iteration in 1:10
           print_objective_f(Q,q,x,iteration;force=true)
       end
Iteration         1:      f(x)= 4.41323005e+02
Iteration         2:      f(x)= 4.41323005e+02
Iteration         3:      f(x)= 4.41323005e+02
Iteration         4:      f(x)= 4.41323005e+02
Iteration         5:      f(x)= 4.41323005e+02
Iteration         6:      f(x)= 4.41323005e+02
Iteration         7:      f(x)= 4.41323005e+02
Iteration         8:      f(x)= 4.41323005e+02
Iteration         9:      f(x)= 4.41323005e+02
Iteration        10:      f(x)= 4.41323005e+02
```
# Example 3
```julia-repl
for iteration in 1:100
    print_objective_f(Q,q,x,iteration;log_print_base=10)
end
Iteration         1:      f(x)= 4.41323005e+02
Iteration        10:      f(x)= 4.41323005e+02
Iteration       100:      f(x)= 4.41323005e+02
```
"""
function print_objective_f(Q,q,x,iteration; log_print_base = 2, force = false, grad_norm = false)
    if mod(log(log_print_base,iteration),1) == 0 || force
        obj_val = f(Q,q,x)
        if grad_norm
            grad_norm = norm(Q*x + q)
            println("Iteration", lpad(iteration,10), ": ","     f(x)=", lpad(Printf.@sprintf("%.8e", obj_val),15), "     |∇f(x)|=", lpad(Printf.@sprintf("%.8e", grad_norm),15))
        else
            println("Iteration", lpad(iteration,10), ": ","     f(x)=", lpad(Printf.@sprintf("%.8e", obj_val),15))
        end
    end
end

