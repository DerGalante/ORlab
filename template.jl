using Formatting
import Base.show

mutable struct SimplexTableau
    mat::Matrix{Float64}
    b::Vector{Float64}
    f::Vector{Float64}
    z::Float64
    bv::Vector{Int}
    iteration::Int

    function SimplexTableau(mat::Matrix, b::Vector, c::Vector)

        n_var = size(mat,2)
        n_bv = length(b)

        if size(mat, 1) != length(b)
            error("Number of rows of A ($(size(mat, 1))) and length of b ($(length(b))) is not identical")
        end

        if length(c)-1 != size(mat, 2)
            error("Length of vector c has a length of $(length(c)) but should be $(size(mat, 2)+1) to fit to A")
        end

        return new(
            mat,
            b,
            c[1:end-1],
            c[end],
            collect(n_var-n_bv+1:n_var),
            0
        )
    end
end


function Base.show(io::IO, t::SimplexTableau)
    n, m = size(t.mat)
    hline0 = repeat("-", 6)
    hline1 = repeat("-", 7*m)
    hline2 = repeat("-", 8)
    hline = join([hline0, "+", hline1, "+", hline2, "\n"])

    line_iteration = sprintf1("%30s", "Iteration $(t.iteration) \n")
    output_str = [line_iteration, hline]
    push!(output_str, sprintf1("%4s", "bv"))
    push!(output_str, sprintf1("%2s| ", ""))

    vars = collect(1:m)
    for i in 1:m
        push!(output_str, sprintf1(" x[%1d] |", vars[i]))
    end
    push!(output_str, sprintf1("%6s", "b\n"))
    push!(output_str, hline)

    for i in 1:n
        push!(output_str, sprintf1(" x[%1d] |", t.bv[i]))
        for j in 1:m
            push!(output_str, sprintf1("%6.2f ", t.mat[i,j]))
        end
        push!(output_str, sprintf1("| %7.2f\n", t.b[i]))
    end

    push!(output_str, hline)
    push!(output_str, sprintf1("%6s|", ""))
    for j in 1:length(t.f)
        push!(output_str, sprintf1("%6.2f ", t.f[j]))
    end

    push!(output_str, sprintf1("| %7.2f\n", t.z))
    push!(output_str, hline)

    print(io, join(output_str))
end

function Base.show(io::IO, ::MIME"text/plain", t::SimplexTableau)
    n_nv = length(t.bv)
    n_con = length(t.b)
    print(io, "SimplexTableau with $n_nv bv and $n_con constaints")
end

function minimum_positive(a, b)
    min_val = Inf
    pivot_row = 0
    for (i,v) in enumerate(a)
        if v > 0
            b_a = b[i]/v
            if b_a < min_val
                min_val = b_a
                pivot_row = i
            end
        end
    end

    return pivot_row
end

function maximum_negative(a, f)
    max_val = -Inf
    pivot_column = 0
    for (i,v) in enumerate(a)
        if v < 0
            f_a = f[i]/v
            if f_a > max_val
                max_val = f_a
                pivot_column = i
            end
        end
    end

    return pivot_column
end

function get_primal_pivot_element(t::SimplexTableau)
    pivot_column = argmin(t.f)
    a = t.mat[:,pivot_column]

    ### Check here if problem is unbounded

    pivot_row = minimum_positive(a, t.b)
    return pivot_row, pivot_column
end

function get_dual_pivot_element(t::SimplexTableau)
    # determine the pivot row
    # assigne the pivot row from the matrix to a variable
    # Check here if no solutin is available
    # Use the `maximum_negative` function to determin the pivot column
    # return pivot row and pivot column

    error("Not yet implemented!") # this is a placeholder, delete once you implemented the function correctly!
end

function exchange_variables!(t::SimplexTableau, r, c)
    t.bv[r] = c
    return nothing
end

function normalize_row!(t::SimplexTableau, r, c)
    normalization_factor = 1/t.mat[r, c]
    t.mat[r,:] .*= normalization_factor
    t.b[r] *= normalization_factor
    return nothing
end

function update_rows!(t::SimplexTableau, r, c)
    other_bv = filter(x-> x != r, 1:size(t.mat, 1))

    for row in other_bv
        # update matrix rows
        factor_val = t.mat[row, c]
        sub_row = factor_val .* t.mat[r, :]
        t.mat[row, :] .-= sub_row

        # update b vector
        t.b[row] -= factor_val * t.b[r]
    end

    f_factor = t.f[c]
    t.f .-= f_factor .* t.mat[r, :]
    t.z -= f_factor * t.b[r]
    return nothing
end

issuboptimal(t::SimplexTableau) = any(x-> x < 0, t.f)

function pivoting!(t::SimplexTableau, pivot_row, pivot_column)
    exchange_variables!(t, pivot_row, pivot_column)
    normalize_row!(t, pivot_row, pivot_column)
    update_rows!(t, pivot_row, pivot_column)
    return nothing
end

function primal_simplex!(t::SimplexTableau; print_tab=true, max_iter=100)

    println("Phase 2")
    println("Basic solution available: Starting primal simplex")

    while issuboptimal(t)
        if t.iteration >= max_iter
            print_tab && println(t)
            println("Primal Simplex terminated")
            println("Reason: max iterations of $max_iter reached")
            println(sprintf1("Current objective value of %.2f", t.z))
            return nothing
        end

        print_tab && print(t)
        pivot_row, pivot_column = get_primal_pivot_element(t)
        pivoting!(t, pivot_row, pivot_column)
        t.iteration += 1
    end
    print_tab && println(t)

    println("Primal Simplex found an optimal solution")
    println("Iterations: $(t.iteration)")
    println(sprintf1("Optimal objective value is %.2f", t.z))
end

isbasicsolution(t::SimplexTableau) = all(x-> x >= 0, t.b)

function dual_simplex!(t::SimplexTableau; print_tab=true, max_iter=100)

    while !isbasicsolution(t)
        if t.iteration >= max_iter
            print_tab && println(t)
            println("Dual Simplex terminated")
            println("Reason: max iterations of $max_iter reached")
            println(sprintf1("Current objective value of %.2f", t.z))
            return nothing
        end

        print_tab && print(t)
        pivot_row, pivot_column = get_dual_pivot_element(t)
        pivoting!(t, pivot_row, pivot_column)
        t.iteration += 1
    end

    print_tab && println(t)
    println("Dual Simplex found basic solution solution")
    println("Iterations: $(t.iteration)")
    println("Moving on to phase 2")
    println(repeat("-", 15))
    t.iteration = 0
    return nothing
end

function simplex!(t::SimplexTableau; kwargs...)
    println("Phase 1")

    if !isbasicsolution(t)
        println(repeat("-", 15))
        println("Starting dual simplex")
        dual_simplex!(t; kwargs...)
    else
        println("Basic solution already available")
        println("Moving on to phase 2")
        println(repeat("-", 15))
    end

    primal_simplex!(t; kwargs...)
    println(sprintf1("Simplex found the optimal objective value of %.2f ", t.z), "after $(t.iteration) iterations")

    return t.z
end