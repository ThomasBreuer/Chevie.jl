"""
This   module  ports   Chevie  functionality   for  Iwahori-Hecke  algebras
associated to Coxeter groups.

Let  (W,S) be a Coxeter  system where `mₛₜ` is  the order of `st` for `s,t∈
S`. Let `R` be a commutative ring with 1 and for `s∈ S` let `uₛ₀,uₛ₁∈ R` be
elements which depend ony on the conjugacy class of `s` in `W` (this is the
same  as requiring that `uₛᵢ=uₜᵢ` whenever `mₛₜ` is odd). The Iwahori-Hecke
algebra of `W` over `R` with parameters `uₛᵢ` is a deformation of the group
algebra  of `W` over `R` defined as  follows: it is the unitary associative
`R`-algebra generated by elements `Tₛ, s∈ S` subject to the relations:

``(Tₛ-uₛ₀)(Tₛ-uₛ₁)=0`` for all `s∈ S` (the quadratic relations)

``TₛTₜTₛ…= TₜTₛTₜ…`` with `mₛₜ` factors on each side (the braid relations)

If  `uₛ₀=1` and  `uₛ₁=-1` for  all `s`  then the quadratic relations become
`Tₛ²=1` and the deformation of the group algebra is trivial.

Since  the generators `Tₛ` satisfy the  braid relations, the algebra `H` is
in  fact a quotient of the group algebra of the braid group associated with
`W`.  It follows that, if `w=s_1⋯ s_m`  is a reduced expression of `w ∈ W`
then  the  product  `Tₛ_1⋯ Tₛ_m`  depends  only  on `w`. We will therefore
denote by `T_w`. We have `T_1=1`.

If  one of `uₛ₀` or `uₛ₁` is invertible  in `R`, for example `uₛ₁`, then by
changing  the generators  to `T′ₛ=-Tₛ/uₛ₁`,  and setting `qₛ=-uₛ₀/uₛ₁`, the
braid  relations do no change  (since when `mₛₜ` is  odd we have `uₛᵢ=uₜᵢ`)
but  the quadratic relations become  `(T′ₛ-qₛ)(T′ₛ+1)=0`. This last form is
the  most common  form considered  in the  literature. Another common form,
considered  in  the  context  of  Kazhdan-Lusztig  theory, is `uₛ₀=√qₛ` and
`uₛ₁=-√qₛ⁻¹`.  The general form of parameters provided is a special case
of general cyclotomic Hecke algebras, and can be useful in many contexts.

For  some  algebras  the  character  table,  and in general Kazhdan-Lusztig
bases,  require a square root of `-uₛ₀uₛ₁`.  We provide a way to specify it
with  the  field  `.rootpara`  which  can  be  given  when constructing the
algebra. If not given a root is automatically extracted when needed (and we
know  how to compute it) by the function `RootParameter`. Note however that
sometimes  an  explicit  choice  of  root  is  necessary  which  cannot  be
automatically determined.

There  is a universal choice  for `R` and `uₛᵢ`:  Let `uₛᵢ:s∈ S,i∈[0,1]` be
indeterminates   such  that  `uₛᵢ=uₜᵢ`  whenever  `mₛₜ`  is  odd,  and  let
`A=ℤ[uₛᵢ]` be the corresponding polynomial ring. Then the Hecke algebra `H`
of  `W` over a  with parameters `uₛᵢ`  is called the *generic Iwahori-Hecke
algebra*  of  with  `W`.  Any  other  algebra  with parameters `vₛᵢ` can be
obtained  by specialization from  `H`: There is  a unique ring homomorphism
`f:A  → R` such that `f(uₛᵢ)=vₛᵢ`  for all `i`. Then we  can view `R` as an
`A`-module via `f` and we can identify the other algebra to ``R⊗ _A H``.

The  elements `{T_w∣w∈ W}` actually form an  `R`-basis of `H` if one of the
`uₛᵢ`  is invertible for all `s`. The  structure constants in that basis is
obtained  as  follows.  To  multiply  `T_v`  by  `T_w`,  choose  a  reduced
expression for `v`, say `v=s_1 ⋯ s_k` and apply inductively the formula:

``T_sT_w=T_{sw}``               if `l(sw)=l(w)+1`

``T_sT_w=-uₛ₀uₛ₁T_{sw}+(uₛ₀+uₛ₁)T_w`` if `l(sw)=l(w)-1`.

If all `s` we have `uₛ₀=q`, `uₛ₁=-1` then we call the corresponding algebra
the one-parameter or Spetsial Iwahori-Hecke algebra associated with `W`; it
can  be obtained with the  simplified call 'hecke(W,q)'. Certain invariants
of  the irreducible characters of  this algebra play a  special role in the
representation  theory of the underlying  finite Coxeter groups, namely the
`a`- and `A`-invariants. For basic properties of Iwahori-Hecke algebras and
their  relevance to the representation theory of finite groups of Lie type,
see for example Curtis and Reiner 1987, Sections~67 and 68.

In  the  following  example,  we  compute  the multiplication table for the
`0`-Iwahori--Hecke algebra associated with the Coxeter group of type `A_2`.

```julia-repl
julia> W=coxgroup(:A,2)
A₂

julia> H=hecke(W,0)            # One-parameter algebra with `q=0`
hecke(A₂,0)

julia> T=Tbasis(H);            # Create the `T` basis

julia> el=words(W)
6-element Vector{Vector{Int8}}:
 []       
 [2]      
 [1]      
 [2, 1]   
 [1, 2]   
 [1, 2, 1]

julia> T.(el)*permutedims(T.(el))        # multiplication table
6×6 Matrix{HeckeTElt{Perm{Int16}, Int64, HeckeAlgebra{Int64, FiniteCoxeterGroup{Perm{Int16},Int64}}}}:
 T.    T₂     T₁     T₂₁    T₁₂    T₁₂₁ 
 T₂    -T₂    T₂₁    -T₂₁   T₁₂₁   -T₁₂₁
 T₁    T₁₂    -T₁    T₁₂₁   -T₁₂   -T₁₂₁
 T₂₁   T₁₂₁   -T₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁ 
 T₁₂   -T₁₂   T₁₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁ 
 T₁₂₁  -T₁₂₁  -T₁₂₁  T₁₂₁   T₁₂₁   -T₁₂₁

```
Thus,  we work  with algebras  with arbitrary  parameters. We will see that
this also works on the level of characters and representations.
 
finally, benchmarks on julia 1.0.2
```benchmark
julia> function test_w0(n)
         W=coxgroup(:A,n)
         Tbasis(hecke(W,Pol()))(longest(W))^2
       end
test_w0 (generic function with 1 method)

julia> @btime test_w0(7);
  132.737 ms (1788153 allocations: 157.37 MiB)
```
Compare to GAP3 where the following function takes 0.92s
```
test_w0:=function(n)local W,T,H;
  W:=CoxeterGroup("A",n);H:=Hecke(W,X(Rationals));T:=Basis(H,"T");
  T(LongestCoxeterWord(W))^2;
end;
```
"""
module HeckeAlgebras
using ..Gapjm
export HeckeElt, Tbasis, central_monomials, hecke, HeckeAlgebra, HeckeTElt, 
  rootpara, equalpara, class_polynomials, char_values, schur_elements,
  schur_element, isrepresentation, FactorizedSchurElements, 
  FactorizedSchurElement, VFactorSchurElement, alt, coefftype, HeckeCoset

@GapObj struct HeckeAlgebra{C,TW}
  W::TW
  para::Vector{Vector{C}}
end

"""
`hecke( W [, parameter][,rootpara=r])`

Hecke  algebra for the complex reflection group or Coxeter group `W`. If no
`parameter` is given, `1` is assumed which gives the group algebra of `W`.

The  following forms are accepted for  `parameter`: if `parameter` is not a
vector,  it is  replaced by  `fill(parameter,ngens(W))`. If  it is a vector
with   one  entry,  it   is  replaced  with  `fill(parameter[1],ngens(W))`.
Otherwise,  `parameter` should be  a list of  length `ngens(W)`. Entries of
`parameter`  corresponding to  the same  `W`-orbit of  generators should be
identical.  `parameter` can be shorter than `ngens(W)` provided there is at
least one entry bound for each orbit of reflections.

An  entry in  `parameter` for  a reflection  of order  `e` can  be either a
single  value or  a `Vector`  of length  'e'. If  it is  a `Vector`,  it is
interpreted as the list `[u₀,…,u_(e-1)]` of parameters for that reflection.
If  it is a single  value `q`, it is  interpreted as the partly specialized
list of parameters `[q,ζ_e,…,ζ_{e-1}]` (thus `[q,-1]` for Coxeter groups).

Computing characters or representations of Hecke algebra needs sometimes to
extract  roots of the  parameters. These roots  are extracted automatically
(when  possible). For Coxeter groups it  is possible to give explicit roots
by  giving a keyword argument `rootpara`:  it should be a vector containing
at  the `i`-th position a square root of `-parameter[i][1]*parameter[i][2]`
(if `rootpara` is not a `Vector` it is replaced by
`fill(rootpara,ngens(W))`).

# Example
```julia-repl
julia> W=coxgroup(:B,2)
B₂

julia> @Pol q
Pol{Int64}: q

julia> H=hecke(W,q)
hecke(B₂,q)

julia> H.para
2-element Vector{Vector{Pol{Int64}}}:
 [q, -1]
 [q, -1]

julia> H=hecke(W,q^2,rootpara=q)
hecke(B₂,q²,rootpara=q)

julia> H.para,rootpara(H)
(Vector{Pol{Int64}}[[q², -1], [q², -1]], Pol{Int64}[q, q])

julia> H=hecke(W,[q^2,q^4],rootpara=[q,q^2])
hecke(B₂,Pol{Int64}[q², q⁴],rootpara=Pol{Int64}[q, q²])

julia> H.para,rootpara(H)
(Vector{Pol{Int64}}[[q², -1], [q⁴, -1]], Pol{Int64}[q, q²])

julia> H=hecke(W,9,rootpara=3)
hecke(B₂,9,rootpara=3)

julia> H.para,rootpara(H)
([[9, -1], [9, -1]], [3, 3])

julia> @Mvp x,y,z,t

julia> H=hecke(W,[[x,y]])
hecke(B₂,Vector{Mvp{Int64, Int64}}[[x, y]])

julia> H.para,rootpara(H)
(Vector{Mvp{Int64, Int64}}[[x, y], [x, y]], Mvp{Cyc{Int64}, Rational{Int64}}[ζ₄x½y½, ζ₄x½y½])

julia> H=hecke(W,[[x,y],[z,t]])
hecke(B₂,Vector{Mvp{Int64, Int64}}[[x, y], [z, t]])

julia> H.para,rootpara(H)
(Vector{Mvp{Int64, Int64}}[[x, y], [z, t]], Mvp{Cyc{Int64}, Rational{Int64}}[ζ₄x½y½, ζ₄t½z½])

julia> hecke(complex_reflection_group(3,1,2),q).para
2-element Vector{Vector{Pol{Cyc{Int64}}}}:
 [q, ζ₃, ζ₃²]
 [q, -1]
```
"""
function hecke(W::Group,para::Vector{<:Vector{C}};rootpara::Vector=C[])where C
  para=map(eachindex(gens(W)))do i
    j=simple_reps(W)[i]
    if i<=length(para) 
     if j<i && para[i]!=para[j] error("one should have  para[$i]==para[$j]") end
      return para[i]
    elseif length(para)==1 return para[1]
    elseif j<i return para[j]
    else error("parameters should be given for first reflection in a class")
    end
  end
  d=Dict{Symbol,Any}(:equal=>allequal(para))
  if !isempty(rootpara) d[:rootpara]=rootpara end
  HeckeAlgebra(W,improve_type(para),d)
end

function hecke(W::Group,p::Vector;rootpara::Vector=Any[])
  oo=order.(gens(W))
  para=map(p,oo)do p, o
    if p isa Vector return p end
    o==2 ? [p,-one(p)] : vcat([p],E.(o,1:o-1))
  end
  if isempty(para) 
   return HeckeAlgebra(W,Vector{Int}[],Dict{Symbol,Any}(:rootpara=>rootpara))
  end
  hecke(W,improve_type(para);rootpara=convert(Vector{eltype(para[1])},rootpara))
end
  
function hecke(W::Group,p::C=1;rootpara::C=zero(C))where C
  rootpara= iszero(rootpara) ? C[] : fill(rootpara,ngens(W))
  hecke(W,fill(p,ngens(W));rootpara)
end

function hecke(W::Group,p::Tuple;rootpara=zero(p[1]))
  rootpara= iszero(rootpara) ? typeof(p[1])[] : fill(rootpara,ngens(W))
  hecke(W,[collect(p) for j in 1:ngens(W)];rootpara=rootpara)
end

function rootpara(H::HeckeAlgebra)
  get!(H,:rootpara)do
    map(eachindex(H.para)) do i
       if isone(-prod(H.para[i])) return -prod(H.para[i]) end
       return root(-prod(H.para[i]))
    end
  end
end

equalpara(H::HeckeAlgebra)::Bool=H.equal

coefftype(H::HeckeAlgebra{C}) where C=C

function simplify_para(para)
  tr(p)=all(i->p[i]==E(length(p),i-1),2:length(p)) ? p[1] : p
  if isempty(para) para
  elseif allequal(tr.(para)) 
    p=tr(para[1])
    p isa Vector ? [p] : p
  else map(tr,para)
  end
end

function Base.show(io::IO, H::HeckeAlgebra)
  if isempty(H.para) print(io,"hecke(",H.W,")"); return end
  print(io,"hecke(",H.W,",",simplify_para(H.para))
  if haskey(H,:rootpara)
    rp=rootpara(H)
    if !isempty(rp) && allequal(rp) print(io,",rootpara=",rp[1])
    else print(io,",rootpara=",rp)
    end
  end
  print(io,")")
end

function Chars.CharTable(H::HeckeAlgebra;opt...)
  get!(H,:chartable)do
    W=H.W
    if isempty(refltype(W)) 
      ct=CharTable(fill(1,1,1),["Id"],["."],[1],1,Dict{Symbol,Any}())
    else
      cts=map(refltype(W))do t
        ct=getchev(t,:HeckeCharTable,H.para[t.indices], haskey(H,:rootpara) ?
                 rootpara(H)[t.indices] : fill(nothing,length(H.para)))
        CharTable(improve_type(toM(ct[:irreducibles])),charnames(t;opt...),
             string.(classnames(t;opt...)),Int.(ct[:centralizers]),
             Int(ct[:centralizers][1]),Dict{Symbol,Any}())
      end
      ct=prod(cts)
    end
    ct.name=repr(H;context=:TeX=>true)
    ct.group=H
    ct
  end
end

function Chars.representation(H::HeckeAlgebra,i::Int)
  dims=getchev(H.W,:NrConjugacyClasses)
  if isempty(dims) return Matrix{Int}[] end
  tt=refltype(H.W)
  rp=haskey(H,:rootpara) ? rootpara(H) : fill(nothing,length(H.para))
  mm=map((t,j)->getchev(t,:HeckeRepresentation,H.para,rp,j),tt,
                                                    lin2cart(dims,i))
  if any(==(false),mm) return nothing end
  if !(mm[1][1] isa Matrix) mm=map(x->toM.(x),mm) end
  mm=improve_type.(mm)
  n=length(tt)
  if n==1 return mm[1] end
  vcat(map(1:n) do i
     map(mm[i]) do m
       kron(map(j->j==i ? m : mm[j][1]^0,1:n)...)
    end
  end...)
end

Chars.representations(H::HeckeAlgebra)=representation.(Ref(H),1:nconjugacy_classes(H.W))

"""
`isrepresentation(H::HeckeAlgebra,r)`

returns `true` or `false`, according to whether a given set `r` of elements
corresponding  to  the  standard  generators  of the reflection group `H.W`
defines a representation of the Hecke algebra `H` or not.

```julia-repl
julia> H=hecke(coxgroup(:F,4))
hecke(F₄,1)

julia> isrepresentation(H,reflrep(H))
true

julia> isrepresentation(H,Tbasis(H).(1:4))
true
```
"""
function isrepresentation(H::HeckeAlgebra,t;verbose=false)
  W=H.W
  res=true
  for i in eachindex(gens(W))
    if !iszero(prod(q->(t[i]-q.*one(t[i])),H.para[i]))
      if !verbose return false end
      println("Error in ",ordinal(i)," parameter relation");
      res=false
    end
  end
  for (l,r) in braid_relations(W)
    if !iszero(prod(t[l])-prod(t[r]))
      if !verbose return false end
      println("Error in relation ",l,"=",r)
      res=false
    end
  end
  res
end

"""
`reflrep(H)`

returns  a list of matrices which give the reflection representation of the
Iwahori-Hecke algebra `H`.

```julia-repl
julia> W=coxgroup(:B,2);H=hecke(W,Pol(:q))
hecke(B₂,q)

julia> reflrep(H)
2-element Vector{Matrix{Pol{Int64}}}:
 [-1 0; -q q]
 [q -2; 0 -1]

julia> H=hecke(coxgroup(:H,3))
hecke(H₃,1)

julia> reflrep(H)
3-element Vector{Matrix{Cyc{Int64}}}:
 [-1 0 0; -1 1 0; 0 0 1]
 [1 (-3-√5)/2 0; 0 -1 0; 0 -1 1]
 [1 0 0; 0 1 -1; 0 0 -1]
```
"""
function PermRoot.reflrep(H::HeckeAlgebra)
  W=H.W
  if !equalpara(H) || !(W isa CoxeterGroup)
        error("Reflexion representation of Cyclotomic Hecke algebras or\n",
          "Hecke algebras with unequal parameters not implemented")
  end
  q=-1*H.para[1][1]//H.para[1][2]
  r=ngens(W)
  C=fill(q*E(1),r,r)
  CM=coxmat(W)
  for i  in eachindex(gens(W))
    for j  in 1:i-1
      m=CM[i,j]
      if m!=0 m=E(m)+E(m,-1) else m=2 end
      C[i,j]=2+m
      if m==-2 C[j,i]=0 else C[j,i]=q end
    end
    C[i,i]=q+1
  end
  improve_type(map(eachindex(gens(W)))do i
    a=fill(0*q*E(1),r,r)
    for j  in eachindex(gens(W))
      a[j,j]=q
      a[j,i]-=C[i,j]
    end
    -H.para[1][2]*a
  end)
end 

"""
`WGraphToRepresentation(H::HeckeAlgebra,gr::Vector)'
    
`H`  should be  a one-parameter  Hecke algebra  for a  finite Coxeter group
where  `rootpara`  is  defined.  The  function  returns the matrices of the
representation defined by `gr` of `H`.

```julia-repl
julia> W=coxgroup(:H,3)
H₃

julia> H=hecke(W,Pol(:x)^2)
hecke(H₃,x²)

julia> g=Wgraph(W,3)
2-element Vector{Vector{Vector{Any}}}:
 [[2], [1, 2], [1, 3], [1, 3], [2, 3]]
 [[-1, [[1, 3], [2, 4], [3, 5], [4, 5]]]]

julia> WGraphToRepresentation(H,g)
3-element Vector{Matrix{Pol{Int64}}}:
 [x² 0 … 0 0; 0 -1 … 0 0; … ; 0 0 … -1 x; 0 0 … 0 x²]
 [-1 0 … 0 0; 0 -1 … x 0; … ; 0 0 … x² 0; 0 0 … x -1]
 [x² 0 … 0 0; 0 x² … 0 0; … ; 0 x … -1 0; 0 0 … 0 -1]
```
"""
function Chars.WGraphToRepresentation(H::HeckeAlgebra,gr::Vector)
  if !equalpara(H)
    error("cell representations for unequal parameters not yet implemented")
  end
  S=toM.(-H.para[1][2]*WGraphToRepresentation(length(H.para),gr,
                                              rootpara(H)[1]//H.para[1][2]))
  if !isrepresentation(H,S;verbose=true) error() end
  improve_type(S)
end

"""
central_monomials(H)
  Let  `H` be an Hecke  algebra for the reflection  group `W`. The function
  returns  the  scalars  by  which  the  image  in  `H`  of  π  acts on the
  irreducible  representations of  the Iwahori-Hecke  algebra. When  `W` is
  irreducible, π is the generator of the center of the pure braid group. In
  general,  it  is  the  product  of  such  elements  for  each irreducible
  component. When `W` is an irreducible Coxeter group, π is the lift to the
  braid group of the square of the longest element of `W`.

```julia-repl
julia> H=hecke(coxgroup(:H,3),Pol(:q))
hecke(H₃,q)

julia> central_monomials(H)
10-element Vector{Pol{Cyc{Int64}}}:
 1  
 q³⁰
 q¹²
 q¹⁸
 q¹⁰
 q¹⁰
 q²⁰
 q²⁰
 q¹⁵
 q¹⁵
```
"""
function central_monomials(H::HeckeAlgebra)
# Cf. BrMi, 4.16 for the formula used
  W=H.W
  v=hyperplane_orbits(W)
  map(eachrow(CharTable(W).irr)) do irr
    dim=Int(irr[1])
    prod(v)do C
      q=H.para[restriction(W)[C.s]]
      m=Int.(map(0:C.order-1)do j
       (dim+sum(l->irr[C.cl_s[l]]*E(C.order,-j*l),1:C.order-1))//C.order
      end)
      E.(dim,-C.N_s*sum(m.*(0:C.order-1)))*
          prod(j->q[j]^Int(C.N_s*C.order*m[j]//irr[1]),1:C.order)
    end
  end
end

#--------------------------------------------------------------------------
abstract type HeckeElt{P,C} end # P=typeof(keys) [Perms] C typeof(coeffs)

Base.zero(h::HeckeElt)=clone(h,zero(h.d))
Base.iszero(h::HeckeElt)=iszero(h.d)
Base.:(==)(a::HeckeElt,b::HeckeElt)=a.H===b.H && a.d==b.d
Base.copy(h::HeckeElt)=clone(h,h.d)

# HeckeElts are scalars for broadcasting
Base.broadcastable(h::HeckeElt)=Ref(h)

function Base.show(io::IO, h::HeckeElt)
  function showbasis(io::IO,e)
    w=word(h.H.W,e)
    res=basename(h)
    if hasdecor(io) res*=isempty(w) ? "." : "_"*joindigits(w,"{}";always=true)
    else            res*="("*join(w,",")*")"
    end
    fromTeX(io,res)
  end
  show(IOContext(io,:showbasis=>showbasis),h.d)
end


Base.:+(a::HeckeElt, b::HeckeElt)=clone(a,a.d+b.d)
Base.:-(a::HeckeElt)=clone(a,-a.d)
Base.:-(a::HeckeElt, b::HeckeElt)=clone(a,a.d-b.d)

Base.:*(a::HeckeElt, b::Union{Number,Pol,Mvp})=clone(a,a.d*b)
Base.:*(b::Union{Number,Pol,Mvp}, a::HeckeElt)=a*b

Base.:^(a::HeckeElt, n::Integer)=n>=0 ? Base.power_by_squaring(a,n) :
                                        Base.power_by_squaring(inv(a),-n)
#--------------------------------------------------------------------------
const MM=ModuleElt # HModuleElt is 3 times slower

struct HeckeTElt{P,C1,TH}<:HeckeElt{P,C1}
  d::MM{P,C1} # has better merge performance than Dict
  H::TH
end

clone(h::HeckeTElt,d)=HeckeTElt(d,h.H) # d could be different type from h.d
basename(h::HeckeTElt)="T"
 
function Base.one(H::HeckeAlgebra)
  get!(H,:one)do
    HeckeTElt(MM(one(H.W)=>one(coefftype(H));check=false),H)
  end
end

Base.one(h::HeckeTElt)=one(h.H)

function Base.zero(H::HeckeAlgebra)
  HeckeTElt(zero(MM{typeof(one(H.W)),coefftype(H)}),H)
end

Tbasis(H::HeckeAlgebra)=(x...)->x==() ? one(H) : Tbasis(H,x...)
Tbasis(H::HeckeAlgebra,w::Vararg{Integer})=Tbasis(H,H.W(w...))
Tbasis(H::HeckeAlgebra,w::Vector{<:Integer})=Tbasis(H,H.W(w...))
Tbasis(H::HeckeAlgebra,h::HeckeTElt)=h
Tbasis(H::HeckeAlgebra,h::HeckeElt)=Tbasis(h)
Tbasis(H::HeckeAlgebra,w)=HeckeTElt(MM(w=>one(coefftype(H));check=false),H)

function polynomial_relations(H::HeckeAlgebra)
  get!(H,:polrel)do
    map(p->Pol([1],length(p))-prod(x->Pol([-x,1]),p),H.para)
  end
end
    
function innermul(W::CoxeterGroup,a,b)
  sum(a.d) do (ea,pa)
    h=b.d*pa
    for i in reverse(word(W,ea))
      s=W(i)
      up=empty(h.d)
      down=empty(h.d)
      for (e,p)  in h
        if isleftdescent(W,e,i) push!(down,e=>p) else push!(up,s*e=>p) end
      end
      h=MM(up)
      if isempty(down) continue end
      pp=a.H.para[i]
      ss,p=(sum(pp),-prod(pp))
      if !iszero(ss) h+=MM(down;check=false)*ss end
      if !iszero(p) h+=MM(s*e=>c*p for (e,c) in down) end
    end
    HeckeTElt(h,a.H)
  end
end

function innermul(W::PermRootGroup,a,b)
  if length(refltype(W))>1 || !iscyclic(W) error("not implemented") end
  sum(a.d) do (ea,pa)
    h=b.d*pa
    for i in reverse(word(W,ea))
      new=zero(h)
      for (eb,pb) in h
        lb=length(word(W,eb))
        if 1+lb<length(W) push!(new.d,W(1)*eb=>pb)
        else
          p=polynomial_relations(a.H)[1]
          append!(new.d,W(1)^(i+p.v+1)=>pb*c for (i,c) in pairs(p.c))
        end
      end
      h=new
    end
    HeckeTElt(MM(h.d),a.H)
  end
end

function Base.:*(a::HeckeTElt, b::HeckeTElt)
  if iszero(a) return a end
  if iszero(b) return b end
  W=a.H.W
  innermul(W,a,b)  # function barrier needed for performance
end

function Base.inv(a::HeckeTElt)
  if length(a.d)!=1 error("can only invert single T(w)") end
  w,coeff=first(a.d)
  H=a.H
  T=Tbasis(H)
  l=reverse(word(H.W,w))
  if isempty(l) return inv(coeff)*T() end
  inv(coeff)*prod(i->inv(prod(H.para[i]))*(T()*sum(H.para[i])-T(i)),l)
end

function Cosets.Frobenius(x::HeckeElt,phi)
  y=deepcopy(x)
  y.d.d .= [Frobenius(k,phi)=>v for (k,v) in y.d.d]
  y
end

"""
`alt(a::HeckeTElt)`

the  involution on the Hecke algebra defined by `x↦ bar(x)` on coefficients
and `Tₛ↦ uₛ,₀uₛ,₁Tₛ`. Essentially it corresponds to tensoring with the sign
representation.

```julia-repl
julia> W=coxgroup(:G,2);H=hecke(W,Pol(:q))
hecke(G₂,q)

julia> T=Tbasis(H);h=T(1,2)*T(2,1)
q²T.+(q²-q)T₁+(q-1)T₁₂₁

julia> alt(h)
q⁻²T.+(q⁻²-q⁻³)T₁+(q⁻³-q⁻⁴)T₁₂₁
```
"""
function alt(a::HeckeTElt)
  clone(a,MM(isone(w) ? w=>bar(c) : w=>prod(prod(inv.(a.H.para[i]))
                for i in word(a.H.W,w))* bar(c) for (w,c) in a.d;check=false))
end

"""
`α(a::HeckeTElt)`

the anti-involution on the Hecke algebra defined by `T_w↦T_inv(w)`.
"""
Garside.α(h::HeckeTElt)=HeckeTElt(MM(inv(p)=>c for (p,c) in h.d),h.H)

"""
`class_polynomials(h)`

returns the class polynomials of the Hecke element `h` of the Hecke algebra
`H=h.H`  with respect  to representatives  `reps` of  minimal length in the
conjugacy  classes  of  the  Coxeter  group  `W=H.W`.  Such  minimal length
representatives  are given by  the function `classinfo(W)[:classtext]`. The
vector  `p` of these polynomials has the property that if `X` is the matrix
of  the values of  the irreducible characters  of `H` on  `T_w` (for `w` in
`reps`),  then the product `X*p`  is the list of  values of the irreducible
characters on `h`.

```julia-repl
julia> W=CoxSym(4)
𝔖 ₄

julia> H=hecke(W,Pol(:q))
hecke(𝔖 ₄,q)

julia> h=Tbasis(H,longest(W))
T₁₂₁₃₂₁

julia> p=class_polynomials(h)
5-element Vector{Pol{Int64}}:
 0        
 0        
 q²       
 q³-2q²+q 
 q³-q²+q-1
```
The class polynomials were introduced in
[Geck-Pfeiffer1993](biblio.htm#GP93).
"""
function class_polynomials(h)
  H=h.H
  WF=H.W
  if H isa HeckeCoset  
    W=Group(WF)
    para=H.H.para
  else W=WF
    para=H.para
  end
  minl=length.(classinfo(WF)[:classtext])
  h=Tbasis(H,h)
# Since  vF is not of minimal length in its class there exists wF conjugate
# by   cyclic  shift  to  vF  and  a  generating  reflection  s  such  that
# l(swFs)=l(vF)-2. Return T_sws.T_s^2
  function orb(w)
    orbit=[w]
    for w in orbit
      for s in leftdescents(W,w)
        sw=W(s)*w
        sws=sw*W(s)
        if isleftdescent(W,inv(sw),s) 
          q1,q2=para[s]
          return (elm=[sws,sw],coeff=[-q1*q2,q1+q2])
        elseif !(sws in orbit) push!(orbit,sws)
        end
      end
    end
    error("Geck-Kim-Pfeiffer theory")
  end

  elm,coeff=first(h.d)
  min=fill(zero(coeff),length(minl))
  while length(h.d)>0
    elms=typeof(elm)[]
    coeffs=typeof(coeff)[]
    l=[length(W,elm) for (elm,coeff) in h.d]
    maxl=maximum(l)
    for (elm,coeff) in h.d
      if length(W,elm)<maxl 
        push!(elms,elm)
        push!(coeffs,coeff)
      else
        p=position_class(WF,elm)
        if minl[p]==maxl min[p]+=coeff
        else o=orb(elm)
          append!(elms,o.elm)
          append!(coeffs,o.coeff.*coeff)
        end
      end
    end
    h=clone(h,MM(Pair.(elms,coeffs)))
  end
  return min
end

"""
`char_values(h)`

`h`  is an  element of  an Iwahori-Hecke  algebra `H`  (in any  basis). The
function  returns the  values of  the irreducible  characters of `H` on `h`
(the   method  used  is  to  convert  to   the  `T`  basis,  and  then  use
`class_polynomials`).

```julia-repl
julia> W=coxgroup(:B,2)
B₂

julia> H=hecke(W,q^2;rootpara=q)
hecke(B₂,q²,rootpara=q)

julia> char_values(Cpbasis(H)(1,2,1))
5-element Vector{Pol{Int64}}:
 -q-q⁻¹        
 q+q⁻¹         
 0             
 q³+2q+2q⁻¹+q⁻³
 0             
```
"""
char_values(h::HeckeElt,ch=CharTable(h.H).irr)=ch*class_polynomials(h)

function char_values(H::HeckeAlgebra,w::Vector{<:Integer})
  W=H.W
  if W isa CoxeterGroup return char_values(Tbasis(H)(w)) end
  p=findfirst(==(w),classinfo(W)[:classtext])
  if !isnothing(p) return CharTable(H).irr[:,p] end
  improve_type(map(representations(H))do r
    first(traces_words_mats(r,[w]))
  end)
end

function schur_element(H::HeckeAlgebra,p)
  t=map((t,phi)->getchev(t,:SchurElement,phi,H.para[t.indices], 
      haskey(H,:rootpara) ?  H.rootpara[t.indices] : 
      fill(nothing,length(H.para))),
      refltype(H.W),p)
  if any(==(false),t) return nothing end
  prod(t)
end

"""
`schur_elements(H)`

returns the list of Schur elements for the (cyclotomic) Hecke algebra `H`

```julia-repl
julia> H=hecke(complex_reflection_group(4),Pol(:q))
hecke(G₄,q)

julia> s=schur_elements(H)
7-element Vector{Pol{Cyc{Rational{Int64}}}}:
 q⁸+2q⁷+3q⁶+4q⁵+4q⁴+4q³+3q²+2q+1              
 2√-3+(6+4√-3)q⁻¹+12q⁻²+(6-4√-3)q⁻³-2√-3q⁻⁴
 -2√-3+(6-4√-3)q⁻¹+12q⁻²+(6+4√-3)q⁻³+2√-3q⁻⁴
 2+2q⁻¹+4q⁻²+2q⁻³+2q⁻⁴
 ζ₃²√-3q³+(3-√-3)q²+3q+3+√-3-ζ₃√-3q⁻¹
 -ζ₃√-3q³+(3+√-3)q²+3q+3-√-3+ζ₃²√-3q⁻¹
 q²+2q+2+2q⁻¹+q⁻²

julia> CycPol.(s)
7-element Vector{CycPol{Cyc{Rational{Int64}}}}:
 Φ₂²Φ₃Φ₄Φ₆
 2√-3q⁻⁴Φ₂²Φ′₃Φ′₆
 -2√-3q⁻⁴Φ₂²Φ″₃Φ″₆
 2q⁻⁴Φ₃Φ₄
 ζ₃²√-3q⁻¹Φ₂²Φ′₃Φ″₆
 -ζ₃√-3q⁻¹Φ₂²Φ″₃Φ′₆
 q⁻²Φ₂²Φ₄
```
"""
schur_elements(H::HeckeAlgebra)=map(p->schur_element(H,p),
                                    charinfo(H.W).charparams)

#----------------------- Factorized Schur elements
struct FactSchur
  factor::Mvp{Cyc{Rational{Int}},Rational{Int}}
  vcyc::Vector{NamedTuple{(:pol,:monomial),
         Tuple{CycPol{Int},Mvp{Cyc{Rational{Int}},Rational{Int}}}}}
end

function Base.show(io::IO,x::FactSchur)
 v=map(x.vcyc) do l
    if get(io,:Maple,false)
      "("*repr(l.pol(l.monomial);context=io)*")"
    else
      repr(l.pol;context=io)*"("*repr(l.monomial;context=io)*")"
    end
  end
  if get(io,:GAP,false) || get(io,:Maple,false) v=join(v,"*")
  else v=join(v,"")
  end
  c=repr(x.factor;context=io)
  if length(v)>0 && degree(x.factor)==0 c=format_coefficient(c) end
  print(io,c,v)
end

expand(x::FactSchur)=x.factor*prod(v->v.pol(v.monomial),x.vcyc)

Base.:*(a::FactSchur, b::Number)=FactSchur(a.factor*b,copy(a.vcyc))
Base.:*(b::Number,a::FactSchur)=FactSchur(a.factor*b,copy(a.vcyc))

function Base.:*(a::FactSchur, b::FactSchur)
  vcyc=copy(a.vcyc)
  for t in b.vcyc
    p = findfirst(x->x.monomial == t.monomial,vcyc)
    if p===nothing push!(vcyc, t)
    else vcyc[p]=(pol=vcyc[p].pol*t.pol,monomial=vcyc[p].monomial)
    end
  end
  FactSchur(a.factor*b.factor,filter(x->degree(x.pol)>0,vcyc))
end

Base.://(a::FactSchur, b::Number)=FactSchur(a.factor//b,copy(a.vcyc))

function Base.://(a::Number, b::FactSchur)
  FactSchur(a//b.factor,map(t->(pol=1//t.pol,monomial=t.monomial),a.vcyc))
end

function Base.://(a::FactSchur,b::FactSchur)
  vcyc=copy(a.vcyc)
  for t in b.vcyc
    p=findfirst(x->x.monomial==t.monomial,vcyc)
    if p===nothing push!(vcyc,(pol=1//t.pol,monomial=t.monomial))
    else vcyc[p]=(pol=vcyc[p].pol//t.pol,monomial=vcyc[p].monomial)
    end
  end
  FactSchur(a.factor//b.factor,filter(x->degree(x.pol)>0,vcyc))
end

function (x::FactSchur)(y...;z...)
  simplify(FactSchur(x.factor(y...;z...),
        map(p->(pol=p.pol,monomial=p.monomial(y...;z...)) , x.vcyc)))
end

function simplify(res::FactSchur)
  R=Rational{Int}
  T=Cyc{R}
  evcyc=NamedTuple{(:pol,:monomial,:power),Tuple{CycPol{T},Mvp{T,R},R}}[]
  factor=res.factor
  for (pol,monomial) in res.vcyc
    k=scalar(monomial)
    if k!==nothing
      factor*=pol(k)
      continue
    end
    k=collect(values(first(monomial.d)[1].d))
    if k[1]<0
      pol=subs(pol,Pol()^-1)
      k=-k
      monomial=inv(monomial)
      factor*=pol.coeff*monomial^pol.valuation
      pol=CycPol(1,0,pol.v)
    end
    c=first(monomial.d)[2]
    n=c*conj(c)
    if isinteger(n)
      n=root(n)//c
      if n!=1
        monomial*=n
        pol=subs(pol,Pol([Root1(n)],1))
        factor*=pol.coeff
        if isone(pol.coeff^2) pol*=pol.coeff
        else pol//=pol.coeff
        end
      end
    end
    power=abs(gcd(numerator.(k)))//lcm(denominator.(k))
    monomial=monomial^(1//power)
    push!(evcyc,(pol=pol,monomial=monomial,power=power))
  end
  if isempty(evcyc) 
    FactSchur(factor,NamedTuple{(:pol,:monomial),Tuple{CycPol{T},Mvp{T,R}}}[])
  else
    vcyc=map(collectby(x->x.monomial,evcyc))do fil
      D=lcm(map(x->denominator(x.power), fil))
      P=prod(x->subs(x.pol,Pol()^(D*x.power)),fil)
      p=P(Pol())
      p=improve_type(p)
      f=filter(i->p.c[i]!=0,eachindex(p.c))-1
      f=gcd(gcd(f),D)
      if f>1
        p=Pol(p.c[1:f:length(p.c)],0)
        D//=f
      end
      (pol=CycPol(p), monomial=fil[1].monomial^(1//D))
    end
    FactSchur(factor,vcyc)
  end
end

function Base.lcm(l::FactSchur...)
  v=collectby(x->x.monomial,vcat(map(x->x.vcyc,l)...))
  FactSchur(1,map(x->(pol=lcm(map(y->y.pol,x)...),monomial=x[1].monomial),v))
end

function VFactorSchurElement(para,r,data=nothing,u=nothing)
  n=length(para)
  if data===nothing para=copy(para)
  else para=para[data[:order]]
  end
  function monomial(v)
    res=prod(i->(para[i]//1)^v[i],1:n)
    if length(v)==n+1 res*=(rt//1)^v[end] end
    res
  end
  factor=haskey(r,:coeff) ? r[:coeff] : 1
  if haskey(r, :factor) factor*= monomial(r[:factor]) end
  if haskey(r, :root)
    den=lcm(denominator.(r[:root]))
    rt=monomial(r[:root]*den)
    if haskey(r, :rootCoeff) rt*=r[:rootCoeff] end
    rt=root(rt,den)
    if !isnothing(data) rt*=data[:rootPower] end
  elseif haskey(r, :rootUnity)
    rt=r[:rootUnity]^data[:rootUnityPower]
  end
  vcyc=[(pol=CycPol([1,0,p]),monomial=Mvp(monomial(v))) for (v,p) in r[:vcyc]]
  if factor==0 || isempty(vcyc) return factor end
  return simplify(FactSchur(factor,vcyc))
end

"""
`FactorizedSchurElement(H,phi)`

returns  the factorized `schur_element`  (see `FactorizedSchurElements`) of
the  Hecke algebra  `H` for  the irreducible  character of `H` of parameter
`phi` (see `charinfo(W).charparams`)

```julia-repl
julia> W=complex_reflection_group(4)
G₄

julia> @Mvp x,y; H=hecke(W,[[1,x,y]])
hecke(G₄,Vector{Mvp{Int64, Int64}}[[1, x, y]])

julia> FactorizedSchurElement(H,[[2,5]])
-x⁻¹yΦ₂(xy)Φ₁(x)Φ₆(xy⁻¹)Φ₁(y)
```
"""
function FactorizedSchurElement(H::HeckeAlgebra,phi)
  t=map(refltype(H.W),phi)do t,psi
     getchev(t,:FactorizedSchurElement,psi,H.para[t.indices], 
    haskey(H,:rootpara) ?  H.rootpara[t.indices] : nothing)
  end
  if false in t return false
  else return prod(t)
  end
end

"""
`FactorizedSchurElements(H)`

Let  `H` be  a Hecke  algebra for  the complex  reflection group `W`, whose
parameters are all (Laurent) monomials in some variables `x₁,…,xₙ`, and let
K  be the field of definition of `W`. Then Maria Chlouveraki has shown that
the  Schur elements  of `H`  then take  the particular  form `M ∏_Φ Φ(M_Φ)`
where  `Φ` runs over a list of  K-cyclotomic polynomials, and `M` and `M_Φ`
are  (Laurent)  monomials  (in  possibly  some  fractional  powers)  of the
variables  `xᵢ`.  The  function  `FactorizedSchurElements`  returns  a data
structure which shows this factorization.

```julia-repl
julia> W=complex_reflection_group(4)
G₄

julia> @Mvp x,y; H=hecke(W,[[1,x,y]])
hecke(G₄,Vector{Mvp{Int64, Int64}}[[1, x, y]])

julia> FactorizedSchurElements(H)
7-element Vector{Gapjm.HeckeAlgebras.FactSchur}:
 x⁻⁴y⁻⁴Φ₂(xy)Φ₁Φ₆(x)Φ₁Φ₆(y)
 Φ₂(x²y⁻¹)Φ₁Φ₆(x)Φ₁Φ₆(xy⁻¹)
 -x⁻⁴y⁵Φ₁Φ₆(xy⁻¹)Φ₂(xy⁻²)Φ₁Φ₆(y)
 -x⁻¹yΦ₂(xy)Φ₁(x)Φ₆(xy⁻¹)Φ₁(y)
 -x⁻⁴yΦ₂(x²y⁻¹)Φ₁(x)Φ₁(xy⁻¹)Φ₆(y)
 x⁻¹y⁻¹Φ₆(x)Φ₁(xy⁻¹)Φ₂(xy⁻²)Φ₁(y)
 x⁻²yΦ₂(x²y⁻¹)Φ₂(xy)Φ₂(xy⁻²)
```
"""
FactorizedSchurElements(H::HeckeAlgebra)=
    map(p->FactorizedSchurElement(H,p),charinfo(H.W).charparams)
#---------------------- Hecke Cosets
@doc """
`HeckeCoset`s  are `Hϕ` where `H` is a  Hecke algebra of some Coxeter group
`W`  on  which  the  reduced  element  `ϕ`  acts by `ϕ(T_w)=T_{ϕ(w)}`. This
corresponds  to the action  of the Frobenius  automorphism on the commuting
algebra  of the  induced of  the trivial  representation from  the rational
points of some `F`-stable Borel subgroup to `𝐆 ^F`.

```julia-repl
julia> WF=rootdatum(:u,3)
u₃

julia> HF=hecke(WF,Pol(:v)^2;rootpara=Pol())
hecke(u₃,v²,rootpara=v)

julia> CharTable(HF)
CharTable(hecke(u₃,v²,rootpara=v))
   │ 111 21  3
───┼───────────
111│  -1  1 -1
21 │-2v³  .  v
3  │  v⁶  1 v²
```
Thanks  to the work of Xuhua  He and Sian Nie, 'HeckeClassPolynomials' also
make sense for these cosets. This is used to compute such character tables.
""" HeckeCoset
@GapObj struct HeckeCoset{TH<:HeckeAlgebra,TW<:Spets}
  H::TH
  W::TW
end

"""
`hecke(WF::Spets, H)`

`hecke(WF::Spets, params)`

Construct  a `HeckeCoset`  from a  Coxeter coset  `WF` and an Hecke algebra
associated  to the CoxeterGroup  of `WF`. The  second form is equivalent to
`Hecke(WF,Hecke(Group(WF),params))`. See the doc for `HeckeCoset`.
"""
hecke(WF::Spets,H::HeckeAlgebra)=HeckeCoset(H,WF,Dict{Symbol,Any}())
hecke(WF::Spets,a...;b...)=HeckeCoset(hecke(Group(WF),a...;b...),WF,Dict{Symbol,Any}())

function Base.show(io::IO, H::HeckeCoset)
  print(io,"hecke(",H.W,",")
  tr(p)= p[2]==-one(p[2]) ? p[1] : p
  if allequal(H.H.para) print(io,tr(H.H.para[1]))
  else print(io,map(tr,H.H.para))
  end
  if haskey(H.H,:rootpara)
    rp=rootpara(H.H)
    if allequal(rp) print(io,",rootpara=",rp[1])
    else print(io,",rootpara=",rp)
    end
  end
  print(io,")")
end

function Chars.CharTable(H::HeckeCoset)
  get!(H,:chartable)do
    W=H.W
    cts=map(refltype(W))do t
      inds=t.orbit[1].indices
      getchev(t,:HeckeCharTable,H.H.para[inds], haskey(H.H,:rootpara) ? 
               rootpara(H.H)[inds] : fill(nothing,length(H.H.para)))
    end
    cts=map(cts) do ct
      if haskey(ct,:irredinfo) names=getindex.(ct[:irredinfo],:charname)
      else                     names=charinfo(W).charnames
      end
      CharTable(improve_type(toM(ct[:irreducibles])),names,ct[:classnames],
                map(Int,ct[:centralizers]),length(W),
               Dict{Symbol,Any}(:name=>ct[:identifier]))
    end
    ct=prod(cts)
    ct.name=repr(H;context=:TeX=>true)
    ct.group=H
    ct
  end
end

function Chars.representation(H::HeckeCoset,i::Int)
  dims=getchev(H.W,:NrConjugacyClasses)
  if isempty(dims) return (gens=Matrix{Int}[],F=fill(0,0,0)) end
  tt=refltype(H.W)
  rp=haskey(H,:rootpara) ? rootpara(H) : fill(nothing,length(H.H.para))
  mm=map(tt,lin2cart(dims,i)) do t,j
    r=getchev(t,:HeckeRepresentation,H.H.para,rp,j)
    if r isa Vector 
       r=toM.(r)
       (gens=r,F=one(r[1]))
    else (gens=toM.(r[:gens]),F=toM(r[:F]))
    end
  end
  if any(==(false),mm) return false end
  ff=improve_type(getindex.(mm,:F))
  mm=improve_type(getindex.(mm,:gens))
  n=length(tt)
  if n==1 return (gens=mm[1],F=ff[1]) end
  (gens=vcat(map(1:n) do i
         map(mm[i]) do m
           kron(map(j->j==i ? m : mm[j][1]^0,1:n)...)
         end
        end...), F=kron(ff...))
end

Chars.representations(H::HeckeCoset)=representation.(Ref(H),1:nconjugacy_classes(H.W))

function isrepresentation(H::HeckeCoset,r)
  all(i->iszero(r.gens[i]*r.F-r.F*r.gens[action(Group(H.W),i,H.W.phi)]),
      eachindex(r.gens)) && isrepresentation(H.H,r.gens)
end

struct HeckeTCElt{P,C1}<:HeckeElt{P,C1}
  d::MM{P,C1} # has better merge performance than Dict
  H::HeckeCoset
end

basename(h::HeckeTCElt)="T"
clone(h::HeckeTCElt,d)=HeckeTCElt(d,h.H)

Tbasis(H::HeckeCoset)=(x...)->isempty(x) ? one(H) : Tbasis(H,x...)
Tbasis(H::HeckeCoset,w::Vararg{Integer})=Tbasis(H,H.W(w...))
Tbasis(H::HeckeCoset,w::Vector{<:Integer})=Tbasis(H,H.W(w...))
Tbasis(H::HeckeCoset,h::HeckeTCElt)=h
Tbasis(H::HeckeCoset,h::HeckeElt)=Tbasis(h)
Tbasis(H::HeckeCoset,w)=HeckeTCElt(MM(w=>one(coefftype(H.H))),H)

end
