using Test
include("template.jl")

# tab1 = SimplexTableau(
#     [2 1 1 0 0; 2 -1 0 1 0; 0 1 0 0 1],
#     [10, 6, 6],
#     [-5, -2, 0, 0, 0, 6]
# )

# simplex!(tab1)

# tab2 = SimplexTableau(
#     [-1/3 1 1 0 0 0; 3 -1 0 1 0 0; -1 0 0 0 1 0; 0 1 0 0 0 1],
#     [7, 9, -1, 6],
#     [3, -5, 0, 0, 0, 0, 0]
# )

# simplex!(tab2)

# tab3 = SimplexTableau(
#     [-4 3 1 0; 1 -4 0 1],
#     [20, 0],
#     [-2, -1, 0, 0, 0]
# )

# simplex!(tab3)

# tab4 = SimplexTableau(
#     [2 -1 1 0 0; 1 2 0 1 0; -2 -1 0 0 1],
#     [0, 1,-2],
#     [1, -1, 0, 0, 0, 0]
# )

# simplex!(tab4)

@testset "Tableau 1" begin
    tab1 = SimplexTableau(
        [2 1 1 0 0; 2 -1 0 1 0; 0 1 0 0 1],
        [10, 6, 6],
        [-5, -2, 0, 0, 0, 6]
    )

    @test tab1.mat == [2 1 1 0 0; 2 -1 0 1 0; 0 1 0 0 1]
    @test tab1.b == [10, 6, 6]
    @test tab1.f == [-5, -2, 0, 0, 0]
    @test tab1.z == 6
    @test tab1.bv == [3, 4, 5]

    z = simplex!(tab1; print_tab=false)


    @test z == 30.0

    @test tab1.mat ==  [0.0  1.0   0.5   -0.5   0.0; 1.0  0.0   0.25   0.25  0.0; 0.0  0.0  -0.5    0.5   1.0]

    @test tab1.iteration == 2
end

@testset "Tableau 2" begin
    tab2 = SimplexTableau(
        [-1/3 1 1 0 0 0; 3 -1 0 1 0 0; -1 0 0 0 1 0; 0 1 0 0 0 1],
        [7, 9, -1, 6],
        [3, -5, 0, 0, 0, 0, 0]
    )

    @test tab2.mat == [-1/3 1 1 0 0 0; 3 -1 0 1 0 0; -1 0 0 0 1 0; 0 1 0 0 0 1]
    @test tab2.b == [7, 9, -1, 6]
    @test tab2.f == [3, -5, 0, 0, 0, 0]
    @test tab2.z == 0
    @test tab2.bv == [3, 4, 5, 6]

    z = simplex!(tab2; print_tab=false)

    @test z == 27.0

    res_mat = [0.0  0.0  1.0  0.0  -1/3  -1.0
    0.0  0.0  0.0  1.0   3.0    1.0
    1.0  0.0  0.0  0.0  -1.0    0.0
    0.0  1.0  0.0  0.0   0.0    1.0
    ]

    @test tab2.mat == res_mat
    @test tab2.iteration == 1
end


@testset "Tableau 3" begin
    tab3 = SimplexTableau(
        [-4 3 1 0; 1 -4 0 1],
        [20, 0],
        [-2, -1, 0, 0, 0]
    )

    @test tab3.mat == [-4 3 1 0; 1 -4 0 1]
    @test tab3.b == [20, 0]
    @test tab3.f == [-2, -1, 0, 0]
    @test tab3.z == 0
    @test tab3.bv == [3, 4]

    @test_throws r"[Uu]nbounded" simplex!(tab3; print_tab=false)
    @test tab3.iteration == 1
end


@testset "Tableau 4" begin
    tab4 = SimplexTableau(
        [2 -1 1 0 0; 1 2 0 1 0; -2 -1 0 0 1],
        [0, 1,-2],
        [1, -1, 0, 0, 0, 0]
    )

    @test tab4.mat == [2 -1 1 0 0; 1 2 0 1 0; -2 -1 0 0 1]
    @test tab4.b == [0, 1,-2]
    @test tab4.f == [1, -1, 0, 0, 0]
    @test tab4.z == 0
    @test tab4.bv == [3, 4, 5]

    @test_throws r"[Ii]nfeasable" simplex!(tab4; print_tab=false)
    @test tab4.iteration == 2
end