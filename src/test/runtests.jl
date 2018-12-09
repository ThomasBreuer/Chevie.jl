# auto-generated tests from julia-repl docstrings
using Test, Gapjm
function mytest(a::String,b::String)
  a=repr(MIME("text/plain"),eval(Meta.parse(a)))
  a=replace(a,r" *\n"s=>"\n")
  a=replace(a,r" *$"s=>"")
  a==b
end
@testset "CoxGroups.jl" begin
@test mytest("W=coxsym(4)","coxsym(4)")
@test mytest("p=eltword(W,[1,3,2,1,3])","{UInt8}(1,4)")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 2\n 3\n 2\n 1")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 2\n 3\n 2\n 1")
@test mytest("word(W,longest(W))","6-element Array{Int64,1}:\n 1\n 2\n 1\n 3\n 2\n 1")
@test mytest("w0=longest(W)","{UInt8}(1,4)(2,3)")
@test mytest("length(W,w0)","6")
@test mytest("map(i->word(W,reflection(W,i)),1:nref(W))","6-element Array{Array{Int64,1},1}:\n [1]\n [2]\n [3]\n [1, 2, 1]\n [2, 3, 2]\n [1, 2, 3, 2, 1]")
@test mytest("[length(elements(W,i)) for i in 0:nref(W)]","7-element Array{Int64,1}:\n 1\n 3\n 5\n 6\n 5\n 3\n 1")
end
@testset "Cycs.jl" begin
@test mytest("E(3)+E(4)","ζ₁₂⁴-ζ₁₂⁷-ζ₁₂¹¹")
@test mytest("E(3,2)","ζ₃²")
@test mytest("1+E(3,2)","-ζ₃")
@test mytest("a=E(4)-E(4)","0")
@test mytest("conductor(a)","4")
@test mytest("conductor(lower(a))","1")
@test mytest("typeof(convert(Int,a))","Int64")
@test mytest("c=inv(1+E(4))","1//2-1//2ζ₄")
@test mytest("typeof(c)","Cyc{Rational{Int64}}")
@test mytest("typeof(1+E(4))","Cyc{Int64}")
@test mytest("Cyc(1+im)","1+ζ₄")
@test mytest("1//(1+E(4))","1//2-1//2ζ₄")
@test mytest("typeof(Cyc(1//2))","Cyc{Rational{Int64}}")
@test mytest("conj(1+E(4))","1-ζ₄")
@test mytest("c=E(9)","-ζ₉⁴-ζ₉⁷")
@test mytest("AsRootOfUnity(c)","1//9")
@test mytest("c=Complex(E(3))","-0.4999999999999998 + 0.8660254037844387im")
@test mytest("Cyc(c)","-0.4999999999999998+0.8660254037844387ζ₄")
@test mytest("Cyc(c)","-0.4999999999999998+0.8660254037844387ζ₄")
@test mytest("galois(1+E(4),-1)","1-ζ₄")
@test mytest("galois(ER(5),2)==-ER(5)","true")
@test mytest("galois(ER(5),2)==-ER(5)","true")
@test mytest("ER(-3)","ζ₃-ζ₃²")
@test mytest("ER(3)","-ζ₁₂⁷+ζ₁₂¹¹")
@test mytest("ER(3)","-ζ₁₂⁷+ζ₁₂¹¹")
@test mytest("quadratic(1+E(3))","(a = 1, b = 1, root = -3, den = 2)")
@test mytest("quadratic(1+E(5))","nothing")
end
@testset "Hecke.jl" begin
@test mytest("W=WeylGroup(:A,2)","WeylGroup(:A,2)")
@test mytest("H=hecke(W,0)","Hecke(WeylGroup(:A,2),0)")
@test mytest("T=Tbasis(H)","(::getfield(Gapjm.Hecke, Symbol(\"#f#8\")){Int64,Perm{UInt8},HeckeAlgebra{Int64,WeylGroup}}) (generic function with 3 methods)")
@test mytest("el=words(W)","6-element Array{Array{Int64,1},1}:\n []\n [2]\n [1]\n [2, 1]\n [1, 2]\n [1, 2, 1]")
@test mytest("T.(el)*permutedims(T.(el))","6×6 Array{HeckeElt{Perm{UInt8},Int64},2}:\n T()       T(2)       T(1)       T(2,1)     T(1,2)     T(1,2,1)\n T(2)      -T(2)      T(2,1)     -T(2,1)    T(1,2,1)   -T(1,2,1)\n T(1)      T(1,2)     -T(1)      T(1,2,1)   -T(1,2)    -T(1,2,1)\n T(2,1)    T(1,2,1)   -T(2,1)    -T(1,2,1)  -T(1,2,1)  T(1,2,1)\n T(1,2)    -T(1,2)    T(1,2,1)   -T(1,2,1)  -T(1,2,1)  T(1,2,1)\n T(1,2,1)  -T(1,2,1)  -T(1,2,1)  T(1,2,1)   T(1,2,1)   -T(1,2,1)")
@test mytest("T.(el)*permutedims(T.(el))","6×6 Array{HeckeElt{Perm{UInt8},Int64},2}:\n T()       T(2)       T(1)       T(2,1)     T(1,2)     T(1,2,1)\n T(2)      -T(2)      T(2,1)     -T(2,1)    T(1,2,1)   -T(1,2,1)\n T(1)      T(1,2)     -T(1)      T(1,2,1)   -T(1,2)    -T(1,2,1)\n T(2,1)    T(1,2,1)   -T(2,1)    -T(1,2,1)  -T(1,2,1)  T(1,2,1)\n T(1,2)    -T(1,2)    T(1,2,1)   -T(1,2,1)  -T(1,2,1)  T(1,2,1)\n T(1,2,1)  -T(1,2,1)  -T(1,2,1)  T(1,2,1)   T(1,2,1)   -T(1,2,1)")
@test mytest("W=WeylGroup(:B,2)","WeylGroup(:B,2)")
@test mytest("Pol(:q)","q")
@test mytest("H=hecke(W,q)","Hecke(WeylGroup(:B,2),q)")
@test mytest("[H.para,H.sqpara]","2-element Array{Array{T,1} where T,1}:\n Tuple{Pol{Int64},Pol{Int64}}[(q, -1), (q, -1)]\n Missing[missing, missing]")
@test mytest("H=hecke(W,q^2,q)","Hecke(WeylGroup(:B,2),q^2,q)")
@test mytest("[H.para,H.sqpara]","2-element Array{Array{T,1} where T,1}:\n Tuple{Pol{Int64},Pol{Int64}}[(q^2, -1), (q^2, -1)]\n Pol{Int64}[q, q]")
@test mytest("H=hecke(W,[q^2,q^4],[q,q^2])","Hecke(WeylGroup(:B,2),Pol{Int64}[q^2, q^4],Pol{Int64}[q, q^2])")
@test mytest("[H.para,H.sqpara]","2-element Array{Array{T,1} where T,1}:\n Tuple{Pol{Int64},Pol{Int64}}[(q^2, -1), (q^4, -1)]\n Pol{Int64}[q, q^2]")
@test mytest("H=hecke(W,9,3)","Hecke(WeylGroup(:B,2),9,3)")
@test mytest("[H.para,H.sqpara]","2-element Array{Array{T,1} where T,1}:\n Tuple{Int64,Int64}[(9, -1), (9, -1)]\n [3, 3]")
end
@testset "PermGroups.jl" begin
@test mytest("G=PermGroup([Perm(i,i+1) for i in 1:2])","PermGroup((1,2),(2,3))")
@test mytest("collect(G)","6-element Array{Perm{Int64},1}:\n (1,2)\n (1,3,2)\n ()\n (1,2,3)\n (1,3)\n (2,3)")
@test mytest("degree(G)","3")
@test mytest("orbit(G,1)","3-element Array{Int64,1}:\n 1\n 2\n 3")
@test mytest("orbit_and_representative(G,1)","Dict{Int64,Perm{Int64}} with 3 entries:\n  2 => (1,2)\n  3 => (1,3,2)\n  1 => ()")
@test mytest("orbit_and_representative(G,[1,2],(x,y)->x.^Ref(y))","Dict{Array{Int64,1},Perm{Int64}} with 6 entries:\n  [1, 3] => (2,3)\n  [1, 2] => ()\n  [2, 3] => (1,2,3)\n  [3, 2] => (1,3)\n  [2, 1] => (1,2)\n  [3, 1] => (1,3,2)")
@test mytest("Perm(1,2) in G","true")
@test mytest("Perm(1,2,4) in G","false")
@test mytest("base(G)","2-element Array{Int64,1}:\n 1\n 2")
@test mytest("centralizers(G)","2-element Array{PermGroup{Int64},1}:\n PermGroup((1,2),(2,3))\n PermGroup((2,3))")
@test mytest("centralizer_orbits(G)","2-element Array{Dict{Int64,Perm{Int64}},1}:\n Dict(2=>(1,2),3=>(1,3,2),1=>())\n Dict(2=>(),3=>(2,3))")
@test mytest("words(G)","6-element Array{Array{Int64,1},1}:\n []\n [1]\n [2]\n [1, 2]\n [2, 1]\n [1, 2, 1]")
@test mytest("elements(G)","6-element Array{Perm{Int64},1}:\n ()\n (1,2)\n (2,3)\n (1,3,2)\n (1,2,3)\n (1,3)")
end
@testset "Perms.jl" begin
@test mytest("p=Perm(1,2)*Perm(2,3)","(1,3,2)")
@test mytest("Perm{Int8}(p)","{Int8}(1,3,2)")
@test mytest("1^p","3")
@test mytest("p^Perm(3,10)","(1,10,2)")
@test mytest("inv(p)","(1,2,3)")
@test mytest("one(p)","()")
@test mytest("order(p)","3")
@test mytest("degree.((Perm(1,2),Perm(2,3)))","(2, 3)")
@test mytest("largest_moved_point(Perm(1,2)*Perm(2,3)^2)","2")
@test mytest("smallest_moved_point(Perm(2,3))","2")
@test mytest("Matrix(p)","3×3 Array{Float64,2}:\n 0.0  0.0  1.0\n 1.0  0.0  0.0\n 0.0  1.0  0.0")
@test mytest("Matrix{Int}(p)","3×3 Array{Int64,2}:\n 0  0  1\n 1  0  0\n 0  1  0")
@test mytest("Matrix{Int}(p)","3×3 Array{Int64,2}:\n 0  0  1\n 1  0  0\n 0  1  0")
@test mytest("cycles(Perm(1,2)*Perm(4,5))","3-element Array{Array{Int64,1},1}:\n [1, 2]\n [3]\n [4, 5]")
@test mytest("cycles(Perm(1,2)*Perm(4,5))","3-element Array{Array{Int64,1},1}:\n [1, 2]\n [3]\n [4, 5]")
@test mytest("cycletype(Perm(1,2)*Perm(3,4))","2-element Array{Int64,1}:\n 2\n 2")
end
@testset "Pols.jl" begin
@test mytest("Pol(:q)","q")
@test mytest("Pol([1,2],0)","1+2q")
@test mytest("p=Pol([1,2],-1)","q^-1+2")
@test mytest("valuation(p)","-1")
@test mytest("p=(q+1)^2","1+2q+q^2")
@test mytest("degree(p)","2")
@test mytest("p(1//2)","9//4")
@test mytest("divrem(q^3+1,q+2)","(4.0-2.0q+1.0q^2, -7.0)")
@test mytest("divrem1(q^3+1,q+2)","(4-2q+q^2, -7)")
@test mytest("cyclotomic_polynomial(24)","1-q^4+q^8")
@test mytest("cyclotomic_polynomial(24)","1-q^4+q^8")
@test mytest("gcd(q+1,q^2-1)","1.0+1.0q")
@test mytest("gcd(q+1//1,q^2-1//1)","(1//1)+(1//1)q")
end
@testset "Weyl.jl" begin
@test mytest("W=WeylGroup(:D,4)","WeylGroup(:D,4)")
@test mytest("p=eltword(W,[1,3,2,1,3])","{UInt8}(1,14,13,2)(3,17,8,18)(4,12)(5,20,6,15)(7,10,11,9)(16,24)(19,22,23,21)")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 3\n 1\n 2\n 3")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 3\n 1\n 2\n 3")
@test mytest("cartan(:A,4)","4×4 Array{Int8,2}:\n  2  -1   0   0\n -1   2  -1   0\n  0  -1   2  -1\n  0   0  -1   2")
@test mytest("cartan(:A,4)","4×4 Array{Int8,2}:\n  2  -1   0   0\n -1   2  -1   0\n  0  -1   2  -1\n  0   0  -1   2")
@test mytest("CoxGroups.two_tree(cartan(:A,4))","4-element Array{Int64,1}:\n 1\n 2\n 3\n 4")
@test mytest("CoxGroups.two_tree(cartan(:E,8))","(4, [2], [3, 1], [5, 6, 7, 8])")
end
