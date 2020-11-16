"""
# Algebraic groups and semi-simple elements

Let  us fix an  algebraically closed field  `K` and let  `𝐆` be a connected
reductive  algebraic group over `K`. Let `𝐓` be a maximal torus of `𝐆`, let
`X(𝐓)`  be the  character group  of `𝐓`  (resp. `Y(𝐓)`  the dual lattice of
one-parameter  subgroups  of  `𝐓`)  and  `Φ`  (resp  `Φ^`) the roots (resp.
coroots) of `𝐆` with respect to `𝐓`.

Then  `𝐆` is  determined up  to isomorphism  by the  *root datum* `(X(𝐓),Φ,
Y(𝐓),Φ^)`.  In algebraic terms, this consists  in giving a free `ℤ`-lattice
`X=X(𝐓)` of dimension the *rank* of `𝐓` (which is also called the *rank* of
`𝐆`),  and a root system `Φ ⊂ X`,  and giving similarly the dual roots `Φ^⊂
Y=Y(𝐓)`.

This  is obtained  by a  slight generalization  of our  setup for a Coxeter
group  `W`. This time we assume the canonical basis of the vector space `V`
on  which `W` acts is a `ℤ`-basis of  `X`, and `Φ` is specified by a matrix
'simpleroots(W)'  whose lines are the simple  roots expressed in this basis
of  `X`. Similarly `Φ^`  is described by  a matrix 'simplecoroots(W)' whose
lines  are the simple coroots in the basis  of `Y` dual to the chosen basis
of  `X`. The duality pairing between `X` and `Y` is the canonical one, that
is  the pairing between vectors `x∈ X`  and `y∈ Y` is given by `sum(x.*y)`.
Thus, we must have the relation
`simpleroots(W)*permutedims(simplecoroots(W))=cartan(W)`.

We  get that  by a  the function  `rootdatum`, whose  arguments are the two
matrices `simpleroots(W)` and `simplecoroots(W)` described above. The roots
need  not generate `V`, so  the matrices need not  be square. For instance,
the root datum of the linear group of rank 3 can be specified as:

```julia-repl
julia> W=rootdatum([-1 1 0;0 -1 1],[-1 1 0;0 -1 1])
A₂Φ₁

julia> reflrep(W,W(1))
3×3 Array{Int64,2}:
 0  1  0
 1  0  0
 0  0  1
```

here  the symmetric group on 3 letters  acts by permutation of the basis of
`X`.  The dimension of `X` (the  length of the vectors in `simpleroots(W)`)
is the *rank* and the dimension of the subspace generated by the roots (the
length  of  `simpleroots(W)`)  is  called  the  *semi-simple  rank*. In the
example the rank is 3 and the semisimple rank is 2.

The  default form  'W=coxgroup(:A,2)' defines  the adjoint  algebraic group
(the  group with a trivial center). In that  case `Φ` is a basis of `X`, so
'simpleroots(W)'  is  the  identity  matrix  and  'simplecoroots(W)' is the
Cartan  matrix 'cartan(W)' of the root system. 

|The  form 'coxgroup(:A,2,sc)'  constructs the  semisimple simply connected
|algebraic  group, where 'simpleroots(W)' is  the transposed of 'cartan(W)'
|and 'simplecoroots(W)' is the identity matrix.

There  is an extreme form  of root data which  requires another function to
specify:  when `W` is the trivial `coxgroup()`  and there are thus no roots
(in  this case `𝐆 ` is a torus), the root datum cannot be determined by the
roots,  but is entirely determined by the rank `r`. The function `torus(r)`
constructs such a root datum.

Finally,  the function `rootdatum` also understands some familiar names for
the algebraic groups and gives the results that could be obtained by giving
the appropriate matrices 'simpleroots(W)' and 'simplecoroots(W)':

```julia-repl
julia> rootdatum(:gl,3)   # same as the previous example
A₂Φ₁
```

##{Semisimple elements}

It  is also possible  to compute with  semi-simple elements. The first type
are  finite order elements of `𝐓`, which over an algebraically closed field
`K`  are in bijection with elements of `Y⊗ ℚ /ℤ` whose denominator is prime
to  the  characteristic  of  `K`.  These  are  represented  as  a vector of
`Rational`s `r` such that `0≤r<1`, or, more to the point, a `Vector{Root1}`.
The  function  `SS`  constructs  a  semisimple  element  from  a  vector of
`Rational`,  while  the  more  general  function  can  construct semisimple
elements from arbitrary ring elements (like elements of `K`, `Mvps`,…

```julia-repl
julia> G=rootdatum(:sl,4)
A₃

julia> L=reflection_subgroup(G,[1,3])
A₃₍₁₃₎=A₁×A₁Φ₁

julia> C=algebraic_centre(L)
Dict{Symbol,Any} with 3 entries:
  :descAZ => [[1, 2]]
  :AZ     => SSGroup(SemisimpleElement{Root1}[<1,1,-1>])
  :Z0     => SubTorus(A₃₍₁₃₎=A₁×A₁Φ₁,[[1, 2, 1]])

julia> T=torsion_subgroup(C[:Z0],3)
SSGroup(SemisimpleElement{Root1}[<ζ₃,ζ₃²,ζ₃>])

julia> e=elements(T)
3-element Array{SemisimpleElement{Root1},1}:
 <1,1,1>
 <ζ₃,ζ₃²,ζ₃>
 <ζ₃²,ζ₃,ζ₃²>
```

First,  the  group  `𝐆  =SL₄`  is  constructed,  then the Levi subgroup `L`
consisting   of  block-diagonal  matrices  of  shape  `2×2`.  The  function
`algebraic_centre` returns a record with : the neutral component `Z⁰` of the
centre `Z` of `L`, represented by a basis of `Y(Z⁰)`, a complement subtorus
`S`  of  `𝐓`  to  `Z⁰`  represented  similarly  by  a  basis of `Y(S)`, and
semi-simple  elements representing the classes of  `Z` modulo `Z⁰` , chosen
in `S`. The classes `Z/Z⁰` also biject to the fundamental group as given by
the  field '.descAZ', see "AlgebraicCentre" for an explanation. Finally the
semi-simple elements of order 3 in `Z⁰` are computed.

```julia-repl
julia> e[3]^G(2)
SemisimpleElement{Root1}: <ζ₃²,1,ζ₃²>

julia> orbit(G,e[3])
6-element Array{SemisimpleElement{Root1},1}:
 <ζ₃²,ζ₃,ζ₃²>
 <ζ₃²,1,ζ₃²>
 <ζ₃,1,ζ₃²>
 <ζ₃²,1,ζ₃>
 <ζ₃,1,ζ₃>
 <ζ₃,ζ₃²,ζ₃>
```

Here  is the same  computation as above  performed with semisimple elements
whose coefficients are in the finite field `FF(4)`:

```julia-repl
julia> G=rootdatum(:sl,4)
A₃

julia> s=SemisimpleElement(G,Z(4).^[1,2,1])
SemisimpleElement{FFE{2}}: <Z₄,Z₄²,Z₄>

julia> s^G(2)
SemisimpleElement{FFE{2}}: <Z₄,1₂,Z₄>

julia> orbit(G,s)
6-element Array{SemisimpleElement{FFE{2}},1}:
 <Z₄,Z₄²,Z₄>
 <Z₄,1₂,Z₄>
 <Z₄²,1₂,Z₄>
 <Z₄,1₂,Z₄²>
 <Z₄²,1₂,Z₄²>
 <Z₄²,Z₄,Z₄²>
```

We  can  compute  the  centralizer  `C_𝐆 (s)`  of  a semisimple element in
`𝐆 `:

```julia-repl
julia> G=coxgroup(:A,3)
A₃

julia> s=SS(G,[0,1//2,0])
SemisimpleElement{Root1}: <1,-1,1>

julia> centralizer(G,s)
A₃₍₁₃₎=(A₁A₁)Φ₂
```

The  result is an  extended reflection group;  the reflection group part is
the  Weyl group of `C_𝐆 ⁰(s)` and  the extended part are representatives of
`C_𝐆 (s)` modulo `C_𝐆⁰(s)` taken as diagram automorphisms of the reflection
part. Here it is printed as a coset `C_𝐆 ⁰(s)ϕ` which generates `C_𝐆 (s)`.
"""
module Semisimple
using Gapjm
export algebraic_centre, SubTorus, weightinfo, fundamental_group, is_isolated, 
SemisimpleElement, SS, torsion_subgroup, QuasiIsolatedRepresentatives,
StructureRationalPointsConnectedCentre, SScentralizer_representatives
export ExtendedCox, ExtendedReflectionGroup 
#----------------- Extended Coxeter groups-------------------------------
struct ExtendedCox{T<:FiniteCoxeterGroup}
  group::T
  F0s::Vector{Matrix{Int}}
  phis::Vector{<:Perm}
end

function ExtendedCox(W::FiniteCoxeterGroup,F0s::Vector{Matrix{Int}})
  ExtendedCox(W,F0s,isempty(F0s) ? Perm{Int}[] : map(F->PermX(W.G,F),F0s))
end

function Base.:*(a::ExtendedCox,b::ExtendedCox)
# if isempty(gens(a.group)) return b
# elseif isempty(gens(b.group)) return a
# end
  id(r)=one(fill(0,r,r))
  ExtendedCox(a.group*b.group,vcat(
                   map(m->cat(m,id(rank(b.group)),dims=(1,2)),a.F0s),
                   map(m->cat(id(rank(a.group)),m,dims=(1,2)),b.F0s)))
end

function Base.show(io::IO,W::ExtendedCox)
  if isempty(W.phis) print(io,"Extended(",W.group,")")
  elseif length(W.phis)==1 print(io,spets(W.group,W.phis[1]))
  elseif all(x->isone(x^2),W.phis) && length(Group(W.phis))==6
                  print(io,W.group,"⋊ S3")
  else
    ff=map(x->restricted(x,inclusiongens(W.group)),W.phis)
    if all(!isone,ff) || rank(W.group)==0 
         print(io,"Extended(",W.group,",");join(io,ff,",");print(io,")")
    else print(io,"<");join(io,spets.(Ref(W.group),W.phis),",");print(io,">")
    end
  end
end

function ComplexR.reflection_name(io::IO,W::ExtendedCox)
  sprint(show,W;context=io)
end

ExtendedReflectionGroup(W,mats::AbstractVector{Matrix{Int}})=ExtendedCox(W,mats)
ExtendedReflectionGroup(W,mats::Matrix{Int})=ExtendedCox(W,[mats])
ExtendedReflectionGroup(W,mats::AbstractVector{<:AbstractVector{Int}})=ExtendedCox(W,[toM(mats)])
ExtendedReflectionGroup(W)=ExtendedReflectionGroup(W,Matrix{Int}[])

function ExtendedReflectionGroup(W,mats::Vector{Vector{Vector{Int}}})
  if isempty(mats)  ExtendedCox(W,empty([fill(0,0,0)]))
  elseif isempty(mats[1]) ExtendedCox(W,fill(fill(0,0,0),length(mats)))
  else ExtendedCox(W,toM.(mats))
  end
end

ExtendedReflectionGroup(W,p::Vector{<:Perm})=ExtendedCox(W,
       isempty(p) ? Matrix{Int}[] : reflrep.(Ref(W),p))
ExtendedReflectionGroup(W,p::Perm)=ExtendedCox(W,[reflrep(W,p)])

function ExtendedReflectionGroup(W,mats::Vector{Any})
  if isempty(mats) ExtendedCox(W,empty([fill(0,0,0)]))
  else error("not empty")
  end
end

reflection_name(io::IO,W::ExtendedCox)=reflection_name(io,W.group)

#----------------------------------------------------------------------------

struct SemisimpleElement{T}
  W::FiniteCoxeterGroup
  v::Vector{T}
end

Base.:*(a::SemisimpleElement,b::SemisimpleElement)=SemisimpleElement(a.W,
                                                                a.v .* b.v)

Base.inv(a::SemisimpleElement)=SemisimpleElement(a.W,inv.(a.v))
Base.:/(a::SemisimpleElement,b::SemisimpleElement)=a*inv(b)
Base.one(a::SemisimpleElement)=SemisimpleElement(a.W,one.(a.v))
Base.isone(a::SemisimpleElement)=all(isone,a.v)
Base.cmp(a::SemisimpleElement,b::SemisimpleElement)=cmp(a.v,b.v)
Base.isless(a::SemisimpleElement,b::SemisimpleElement)=cmp(a,b)==-1

SS(W::FiniteCoxeterGroup,v::AbstractVector{<:Rational{<:Integer}})=
  SemisimpleElement(W,map(x->Root1(;r=x),v))

SS(W::FiniteCoxeterGroup)=SemisimpleElement(W,fill(Root1(1),rank(W)))

Base.:^(a::SemisimpleElement,n::Integer)=SemisimpleElement(a.W,a.v .^n)

Base.:^(a::SemisimpleElement,m::AbstractMatrix)=SemisimpleElement(a.W,
                                 map(v->prod(a.v .^v),eachcol(m)))
  
Base.:^(a::SemisimpleElement,p::Perm)=a^matY(parent(a.W.G),inv(p))

# scalar product with a root
Base.:^(a::SemisimpleElement,alpha::Vector{<:Integer})=prod(a.v .^ alpha)

function Base.show(io::IO, ::MIME"text/plain", r::SemisimpleElement)
  if !haskey(io,:typeinfo) print(io,typeof(r),": ") end
  show(io,r)
end

function Base.show(io::IO,a::SemisimpleElement)
  if get(io,:limit,false) || get(io,:TeX,false)
    print(io,"<")
    join(io,a.v,",")
    print(io,">")
  else
    print(io,"SemisimpleElement(",a.W,",[")
    join(io,a.v,",")
    print(io,"])")
  end
end

# hash is needed for using SemisimpleElement in Sets/Dicts
Base.hash(a::SemisimpleElement, h::UInt)=hash(a.v, h)
Base.:(==)(a::SemisimpleElement, b::SemisimpleElement)=a.v==b.v

Gapjm.order(a::SemisimpleElement{Root1})=conductor(a.v)

# we need "one" since we cannot define one(SemisimpleElement{T})
struct SSGroup{T}<:Group{SemisimpleElement{T}}
  gens::Vector{SemisimpleElement{T}}
  one::SemisimpleElement{T}
  prop::Dict{Symbol,Any}
end

Base.show(io::IO,G::SSGroup)=print(io,"SSGroup(",gens(G),")")

# the optional argument is necessary when a is empty
function Groups.Group(a::AbstractVector{<:SemisimpleElement},o=one(a[1]))
  SSGroup(filter(!isone,a),o,Dict{Symbol,Any}())
end

Base.one(G::SSGroup)=G.one

struct SubTorus
  generators::Vector{Vector{Int}}
  complement::Vector{Vector{Int}}
  group
end

"""
`SubTorus(W,Y::Matrix)`

The  function  returns  the  subtorus  𝐒  of  the  maximal torus `𝐓` of the
reductive  group represented by the Weyl group  `W` such that `Y(𝐒)` is the
(pure)  sublattice of  `Y(𝐓)` generated  by the  (integral) vectors  `Y`. A
basis  of `Y(𝐒)`  adapted to  `Y(𝐓)` is  computed and  stored in  the field
'S.generators'  of the returned  SubTorus struct. Here,  adapted means that
there  is a  set of  integral vectors,  stored in 'S.complement', such that
'M=vcat(S.generators,S.complement)'  is  a  basis  of  `Y(𝐓)` (equivalently
`M∈GL(Z^{rank(W)})`.  An  error  is  raised  if  `Y` does not define a pure
sublattice.

```julia-repl
julia> W=coxgroup(:A,4)
A₄

julia> SubTorus(W,[1 2 3 4;2 3 4 1;3 4 1 1])
SubTorus(A₄,[[1, 0, 3, -13], [0, 1, 2, 7], [0, 0, 4, -3]])

julia> SubTorus(W,[1 2 3 4;2 3 4 1;3 4 1 2])
ERROR: not a pure sublattice
Stacktrace:
 [1] error(::String) at ./error.jl:33
 [2] Gapjm.Weyl.SubTorus(::FiniteCoxeterGroup{Perm{Int16},Int64}, ::Array{Int64,2}) at /home/jmichel/julia/Gapjm.jl/src/Weyl.jl:1082
 [3] top-level scope at REPL[25]:1
```
"""
function SubTorus(W,V=reflrep(W,one(W)))
  V=ComplementIntMat(toL(reflrep(W,one(W))),toL(V))
  if any(x->x!=1,V[:moduli])
    error("not a pure sublattice")
    return false
  end
  SubTorus(V[:sub],V[:complement],W)
end

Base.show(io::IO,T::SubTorus)=print(io,"SubTorus(",T.group,",",T.generators,")")

Gapjm.rank(T::SubTorus)=length(T.generators)

function Base.:in(s::SemisimpleElement{Root1},T::SubTorus)
  n=order(s)
  s=map(x->Int(n*x.r),s.v)
  V=map(x->mod.(x,n),T.generators)
  i=1
  for v in filter(!iszero,V)
    while v[i]==0 
      if s[i]!=0 return false
      else i+=1
      end
    end
    r=gcdx(n,v[i])
    v=mod.(r[3].*v,n)
    if mod(s[i],v[i])!=0 return false
    else s-=div(s[i],v[i]).*v
      s=mod.(s,n)
    end
  end
  iszero(s)
end

"""
`torsion_subgroup(S::SubTorus,n)'

This  function  returns  the  subgroup  of  semi-simple  elements  of order
dividing `n` in the subtorus `S`.

```julia-repl
julia> G=rootdatum(:sl,4)
A₃

julia> L=reflection_subgroup(G,[1,3])
A₃₍₁₃₎=A₁×A₁Φ₁

julia> C=algebraic_centre(L)
Dict{Symbol,Any} with 3 entries:
  :descAZ => [[1, 2]]
  :AZ     => SSGroup(SemisimpleElement{Root1}[<1,1,-1>])
  :Z0     => SubTorus(A₃₍₁₃₎=A₁×A₁Φ₁,[[1, 2, 1]])

julia> T=torsion_subgroup(C[:Z0],3)
SSGroup(SemisimpleElement{Root1}[<ζ₃,ζ₃²,ζ₃>])

julia> elements(T)
3-element Array{SemisimpleElement{Root1},1}:
 <1,1,1>
 <ζ₃,ζ₃²,ζ₃>
 <ζ₃²,ζ₃,ζ₃²>
```
"""
torsion_subgroup(T::SubTorus,n)=Group(map(x->SS(T.group,x//n),T.generators))
  
#F  algebraic_centre(W)  . . . centre of algebraic group W
##  
##  <W>  should be a Weyl group record  (or an extended Weyl group record).
##  The  function returns information  about the centre  Z of the algebraic
##  group defined by <W> as a record with fields:
##   Z0:         subtorus Z⁰
##   complement: S=complement torus of Z⁰in T
##   AZ:         representatives of Z/Z⁰ given as a group of ss elts
##   [implemented only for connected groups 18/1/2010]
##   [I added something hopefully correct in general. JM 22/3/2010]
##   [introduced subtori JM 2017 and corrected AZ computation]
##   descAZ:  describes AZ as a quotient  of the fundamental group Pi (seen
##   as  the centre of  the simply connected  goup with same isogeny type).
##   Returns words in the generators of Pi which generate the kernel of the
##   map Pi->AZ
##
"""
`algebraic_centre(W)`

`W` should be a Weyl group,  or an extended Weyl group. This
function  returns a description of the centre  ZbG   of the algebraic group
bG    defined by <W> as a Dict with the following fields:

:Z0:  the neutral component  Z^0   of  ZbG   as a subtorus of   bT.

:AZ:  representatives in  ZbG   of  A(Z):=ZbG/(ZbG)^0     given as a group
of semisimple elements.

:ZD:  center  of  the  derived  subgroup  of    bG   given  as  a group of
semisimple elements.

:descAZ:  if `W`  is not  an extended  Weyl group,  describes  A(Z)   as a
quotient  of the center 'pi' of  the simply connected covering of   bG.
It  contains a list of elements given as words in the generators of 'pi'
which generate the kernel of the quotient map.

```julia_repl
julia> G=rootdatum(:sl,4)
A₃

julia> L=reflection_subgroup(G,[1,3])
A₃₍₁₃₎=A₁×A₁

julia> algebraic_centre(L)
Dict{Symbol,Any} with 3 entries:
  :descAZ => [[1, 2]]
  :AZ     => SSGroup(SemisimpleElement{Root1}[<1,1,-1>])
  :Z0     => SubTorus(A₃₍₁₃₎=A₁×A₁,[[1, 2, 1]])

julia> G=coxgroup(:A,3)
A₃

julia> s=SS(G,[0,1//2,0])
SemisimpleElement{Root1}: <1,-1,1>

julia> C=centralizer(G,s)
A₃₍₁₃₎=(A₁A₁)Φ₂

julia> algebraic_centre(C)
Dict{Symbol,Any} with 3 entries:
  :descAZ => [[1], [2]]
  :AZ     => SSGroup(SemisimpleElement{Root1}[])
  :Z0     => SubTorus(A₃₍₁₃₎=A₁×A₁,[[0, 1, 0]])
```
gap> AlgebraicCentre(C);
rec(
Z0 := SubTorus(ReflectionSubgroup(CoxeterGroup("A",3), [ 1, 3 ]),),
AZ := Group( <0,1/2,0> ) )
"""
function algebraic_centre(W)
  if W isa HasType.ExtendedCox
    F0s=map(permutedims,W.F0s)
    W=W.group
  end
  if iszero(semisimplerank(W))
    Z0=toL(reflrep(W,one(W)))
  else
    Z0=NullspaceIntMat(collect.(collect(zip(simpleroots(W)...))))
  end
  Z0=SubTorus(W,toM(Z0))
  if isempty(Z0.complement) AZ=Vector{Rational{Int}}[]
  else
    AZ=toL(inv(Rational.(toM(Z0.complement)*hcat(simpleroots(W)...)))*
           toM(Z0.complement))
  end
  AZ=SS.(Ref(W),AZ)
  if W isa HasType.ExtendedCox # compute fixed space of F0s in Y(T)
    for m in F0s
      AZ=Filtered(AZ,s->(s/SS(W,s.v*m)) in Z0)
      if Rank(Z0)>0 Z0=FixedPoints(Z0,m)
        Append(AZ,Z0[2])
        Z0=Z0[1]
      end
    end
  end
  res=Dict(:Z0=>Z0,:AZ=>Group(abelian_generators(AZ),SS(W)))
  if W isa HasType.ExtendedCox && length(F0s)>0 return res end
  AZ=SS.(Ref(W),weightinfo(W)[:CenterSimplyConnected])
  if isempty(AZ) res[:descAZ]=AZ
    return res
  end
  AZ=Group(AZ)
  toAZ=function(s)
    s=vec(permutedims(map(x->x.r,s.v))*toM(simplecoroots(W)))
    s=permutedims(s)*
       inv(Rational.(toM(vcat(res[:Z0].complement,res[:Z0].generators))))
       return SS(W,vec(permutedims(vec(s)[1:semisimplerank(W)])*
                                      toM(res[:Z0].complement)))
  end
  ss=map(toAZ,gens(AZ))
  #println("AZ=$AZ")
  #println("res=",res)
  #println("gens(AZ)=",gens(AZ))
  #println("ss=$ss")
  res[:descAZ]=if isempty(gens(res[:AZ])) map(x->[x],eachindex(gens(AZ)))
               elseif gens(AZ)==ss Vector{Int}[]
               else # map of root data Y(Wsc)->Y(W)
                  h=Hom(AZ,res[:AZ],ss)
#                 println("h=$h")
                  map(x->word(AZ,x),gens(kernel(h)))
               end
  res
end

function WeightToAdjointFundamentalGroupElement(W,l::Vector)
  if isempty(l) return Perm();end
  prod(x->WeightToAdjointFundamentalGroupElement(W,x),l)
end

function WeightToAdjointFundamentalGroupElement(W,i)
  t=refltype(W)[findfirst(t->i in t.indices,refltype(W))]
  l=copy(t.indices)
  b=longest(W,l)*longest(W,setdiff(l,[i]))
  push!(l,maximum(findall(
    i->all(j->j in t.indices || W.rootdec[i][j]==0,1:semisimplerank(W)),
  eachindex(W.rootdec))))
  restricted(b,inclusion.(Ref(W),l))
end

Base.mod1(a)=mod(numerator(a),denominator(a))//denominator(a)
# returns a record containing minuscule coweights, decompositions
# (in terms of generators of the fundamental group)
function weightinfo(W)
  if isempty(refltype(W)) return Dict(:minusculeWeights=>Vector{Int}[],
         :minusculeCoweights=>Vector{Int}[],
         :decompositions=>Vector{Vector{Int}}[],
         :moduli=>Int[],
         :CenterSimplyConnected=>Vector{Rational{Int}}[],
         :AdjointFundamentalGroup=>eltype(W)[]
        )
  end
  l=map(refltype(W)) do t
    r=getchev(t,:WeightInfo)
    if isnothing(r)
      r=Dict{Symbol,Any}(:moduli=>Int[],:decompositions=>Vector{Vector{Int}}[],
           :minusculeWeights=>Vector{Int}[])
    end
    if !haskey(r,:minusculeCoweights)
      r[:minusculeCoweights]=r[:minusculeWeights]
    end
    if isempty(r[:moduli]) g=Int[]
      r[:ww]=Perm{Int}[]
    else g=filter(i->sum(r[:decompositions][i])==1,
          eachindex(r[:minusculeCoweights])) # generators of fundamental group
      r[:ww]=map(x->WeightToAdjointFundamentalGroupElement(W,x),
               t.indices[r[:minusculeCoweights][g]])
    end
    r[:csi]=zeros(Rational{Int},length(g),semisimplerank(W))
    if !isempty(r[:moduli]) 
      C=mod1.(inv(Rational.(cartan(t))))
      r[:csi][:,t.indices]=C[r[:minusculeCoweights][g],:]
      r[:minusculeWeights]=t.indices[r[:minusculeWeights]]
      r[:minusculeCoweights]=t.indices[r[:minusculeCoweights]]
    end
    r[:csi]=toL(r[:csi])
    r
  end
  res=Dict(:minusculeWeights=>cartesian(map(
                                        x->vcat(x[:minusculeWeights],[0]),l)...),
    :minusculeCoweights=>cartesian(map(
                                     x->vcat(x[:minusculeCoweights],[0]),l)...),
    :decompositions=>map(vcat,cartesian(map(x->vcat(x[:decompositions],
                                 [0 .*x[:moduli]]),l)...)),
    :moduli=>reduce(vcat,map(x->x[:moduli],l)))
# centre of simply connected group: the generating minuscule coweights
# mod the root lattice
  res[:CenterSimplyConnected]=reduce(vcat,getindex.(l,:csi))
  res[:AdjointFundamentalGroup]=reduce(vcat,getindex.(l,:ww))
  n=length(res[:decompositions])-1
  res[:minusculeWeights]=map(x->filter(y->y!=0,x),res[:minusculeWeights][1:n])
  res[:minusculeCoweights]=map(x->filter(y->y!=0,x),res[:minusculeCoweights][1:n])
  res[:decompositions]=res[:decompositions][1:n]
  res
end

"""
`fundamental_group(W)`

This  function returns the fundamental group of the algebraic group defined
by  the Coxeter  group struct  `W`. This  group is  returned as  a group of
diagram  automorphisms of the corresponding affine Weyl group, that is as a
group  of permutations of  the set of  simple roots enriched  by the lowest
root  of  each  irreducible  component.  The  definition  we  take  of  the
fundamental  group of a (not necessarily semisimple) reductive group is (P∩
Y(𝐓))/Q where P is the coweight lattice (the dual lattice in Y(𝐓)⊗ ℚ of the
root lattice) and Q is the coroot latice. The bijection between elements of
P/Q   and   diagram   automorphisms   is   explained   in  the  context  of
non-irreducible groups for example in [§3.B Bonnafé2005](biblio.htm#Bon05).

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> fundamental_group(W)
Group([(1,2,3,12)])

julia> W=rootdatum(:sl,4)
A₃

julia> fundamental_group(W)
Group([])
```
"""
function fundamental_group(W)
  if iszero(semisimplerank(W)) return Group([Perm()]) end
  omega=inv(Rational.(cartan(W)))*toM(simplecoroots(W))
                                       # simple coweights in basis of Y(T)
  e=weightinfo(W)[:minusculeCoweights]
  e=filter(x->all(isinteger,sum(omega[x,:];dims=1)),e) # minusc. coweights in Y
  if isempty(e) return Group(Perm()) end
  e=map(x->WeightToAdjointFundamentalGroupElement(W,x),e)
  Group(abelian_generators(e))
end

function affine(W)
  ex=vcat(1:semisimplerank(W),2*nref(W))
  C=Int.([PermRoot.cartan_coeff(W.G,i,j) for i in ex, j in ex])
  CoxGroups.GenCox(C)
end

"""
`Centralizer(W,s)`

`W`  should  be  a  Weyl  group  or  an extended reflection group and `s` a
semisimple  element of the  algebraic group `G`  corresponding to `W`. This
function  returns  the  Weyl  group  of  `C_G(s)`,  which describes it. The
stabilizer  is an extended reflection group, with the reflection group part
equal  to the Weyl group of `C_{G⁰}(s)`, and the diagram automorphism part
being those induced by `C_G(s)`.

```julia-repl
julia> G=coxgroup(:A,3)
A₃
julia> s=SS(G,[0,1//2,0])
SemisimpleElement{Root1}: <1,-1,1>
julia> centralizer(G,s)
A₃₍₁₃₎=(A₁A₁)Φ₂
```
"""
function Groups.centralizer(W::FiniteCoxeterGroup,s::SemisimpleElement)
# if IsExtendedGroup(W) then 
#   totalW:=Subgroup(Parent(W.group),Concatenation(W.group.generators,W.phis));
#   W:=W.group;
# else totalW:=W;
# fi;
  p=filter(i->isone(s^roots(W,i)),1:nref(W))
  W0s=reflection_subgroup(W,p)
  N=normalizer(W.G,W0s.G)
  l=filter(w->s==s^w,map(x->x.phi,elements(N/W0s)))
  N=Group(abelian_generators(l))
  if rank(W)!=semisimplerank(W)
    if length(gens(N))==0 N=Group([W.matgens[1]^0])
    else N=Group(reflrep.(Ref(W),gens(N)))
    end
  end
  ExtendedReflectionGroup(W0s,gens(N))
end

"""
`QuasiIsolatedRepresentatives(W,p=0)`

`W`  should be a Weyl group corresponding  to an algebraic group bG over an
algebraically  closed field  of characteristic  0. This  function returns a
list  of  semisimple  elements  for  bG,  which  are representatives of the
bG-orbits  of quasi-isolated semisimple elements.  It follows the algorithm
given in

    C.Bonnafe, ``Quasi-Isolated Elements in Reductive Groups''
    Comm. in Algebra 33 (2005), 2315--2337

If  a  second  argument  `p`  is  given,  it gives representatives of those
quasi-isolated elements which exist in characteristic `p`.

```julia-repl
julia> W=coxgroup(:E,6);l=Semisimple.QuasiIsolatedRepresentatives(W)
5-element Array{SemisimpleElement{Root1},1}:
 <1,1,1,1,1,1>
 <1,1,1,ζ₃,1,1>
 <1,-1,1,1,1,1>
 <1,ζ₆,ζ₆,1,ζ₆,1>
 <ζ₃,1,1,1,1,ζ₃>

julia> map(s->is_isolated(W,s),l)
5-element Array{Bool,1}:
 1
 1
 1
 0
 0

julia> W=rootdatum(:E6sc);l=Semisimple.QuasiIsolatedRepresentatives(W)
7-element Array{SemisimpleElement{Root1},1}:
 <1,1,1,1,1,1>
 <-1,1,1,-1,1,-1>
 <ζ₃,1,ζ₃²,1,ζ₃,ζ₃²>
 <ζ₃²,1,ζ₃,1,ζ₃,ζ₃²>
 <ζ₃²,1,ζ₃,1,ζ₃²,ζ₃>
 <ζ₃²,1,ζ₃,1,ζ₃²,ζ₆⁵>
 <ζ₆⁵,1,ζ₃²,1,ζ₃,ζ₃²>

julia> map(s->is_isolated(W,s),l)
7-element Array{Bool,1}:
 1
 1
 1
 1
 1
 1
 1

julia> Semisimple.QuasiIsolatedRepresentatives(W,3)
2-element Array{SemisimpleElement{Root1},1}:
 <1,1,1,1,1,1>
 <-1,1,1,-1,1,-1>
```
"""
function QuasiIsolatedRepresentatives(W::FiniteCoxeterGroup,p=0)
##  This function follows Theorem 4.6 in 
##  C.Bonnafe, ``Quasi-Isolated Elements in Reductive Groups''
##  Comm. in Algebra 33 (2005), 2315--2337
##  after one fixes the following bug: at the beginning of section 4.B
##  ``the stabilizer of `Ω ∩ Δ̃ᵢ` in `𝓐 _G` acts transitively on `Ω ∩ Δ̃ᵢ`''
##  should be
##  ``the stabilizer of `Ω` in `𝓐 _G` acts transitively on `Ω ∩ Δ̃ᵢ`''
  if semisimplerank(W)==0 return [SS(W,fill(0,W.rank))] end
  H=fundamental_group(W)
  iso=inv(Rational.(cartan(W)))*simplecoroots(W) # coweights
  w=Vector{Vector{Rational{Int}}}[]
  ind=Vector{Int}[]
  l=map(refltype(W))do t
    n=t.indices; # n is Δₜ
    # next line  uses that negative roots are listed by decreasing height!
    r=findlast(rr->sum(rr[n])!=0,W.rootdec)
    d=inclusion(W,vcat(n,[r])) # d is Δ̃ₜ
    push!(ind,d)
    push!(w,vcat(iso[n].//(-W.rootdec[r][n]),[0*iso[1]]))
    pp=vcat(map(i->combinations(d,i),1:length(H))...)
    filter(P->length(orbits(stabilizer(H,P),P))==1,pp) #possible sets Ωₜ
  end
  res=map(x->vcat(x...),cartesian(l...))
  res=filter(res)do P
    S=stabilizer(H,P)
    all(I->length(orbits(S,intersect(P,I)))==1,ind)
  end
  res=map(x->x[1],orbits(H,map(x->unique!(sort(x)),res),
          action=(s,g)->unique!(sort(s.^g)))) # possible sets Ω
  if p!=0
    res=filter(res)do P
      all(map(ind,w)do I,W
        J=intersect(P,I) 
        length(J)%p!=0 && all(v->lcm(denominator.(v))%p!=0,
                              W[map(x->findfirst(==(x),I),J)])
      end)
    end
  end
  res=map(res)do P
      sum(map(ind,w)do I,p
      J=intersect(P,I) 
      sum(p[map(x->findfirst(==(x),I),J)])//length(J)
     end)
  end
  res=unique!(sort(map(s->SS(W,s),res)))
  Z=algebraic_centre(W)[:Z0]
  if rank(Z)>0
    res=res[filter(i->!any(j->res[i]/res[j] in Z,1:i-1),eachindex(res))]
  end
  res
end

is_isolated(W,s)=rank(algebraic_centre(centralizer(W,s).group)[:Z0])==
    rank(W)-semisimplerank(W)

"""    
`StructureRationalPointsConnectedCentre(W,q)`
    
`W`  should be  a Coxeter  group or  a Coxeter  coset representing a finite
reductive group `𝐆 ^F`, and `q` should be the prime power associated to the
isogeny  `F`. The  function returns  the abelian  invariants of  the finite
abelian group `Z⁰𝐆 ^F` where `Z⁰𝐆 ` is the connected center of `𝐆 `.

In  the following example one determines the structure of `𝐓(𝔽₃)` where `𝐓`
runs over all the maximal tori of `SL`₄.

```julia-repl
julia> l=twistings(rootdatum(:sl,4),Int[])
5-element Array{Gapjm.Cosets.FCC{Int16,FiniteCoxeterSubGroup{Perm{Int16},Int64}},1}:
 A₃₍₎=Φ₁³
 A₃₍₎=Φ₁²Φ₂
 A₃₍₎=Φ₁Φ₂²
 A₃₍₎=Φ₁Φ₃
 A₃₍₎=Φ₂Φ₄

julia> StructureRationalPointsConnectedCentre.(l,3)
5-element Array{Array{Int64,1},1}:
 [2, 2, 2]
 [2, 8]
 [4, 8]
 [26]
 [40]
```julia-repl
"""    
function StructureRationalPointsConnectedCentre(MF,q)
  if MF isa Spets M=Group(MF)
  else M=MF;MF=Spets(M)
  end
  W=parent(M)
  Z0=algebraic_centre(M)[:Z0]
  Phi=matY(W.G,MF.phi)
  Z0F=toM(Z0.generators)*(Phi*q-one(Phi))
  Z0F=map(x->SolutionIntMat(Z0.generators,x),eachrow(Z0F))
  Z0F=DiagonalizeIntMat(Z0F)[:normal]
  filter(!isone,map(i->Z0F[i][i],1:length(Z0F)))
end

"""
`SScentralizer_representatives(W [,p])`

`W`  should be a Weyl group corresponding  to an algebraic group `𝐆 `. This
function  returns a list describing representatives  `𝐇 ` of `𝐆 `-orbits of
reductive  subgroups  of  `𝐆  `  which  are  the  identity component of the
centralizer of a semisimple element. Each group `𝐇 ` is specified by a list
`h`   of  reflection  indices  in  `W`   such  that  `𝐇  `  corresponds  to
`reflection_subgroup(W,h)`.  If a  second argument  `p` is  given, only the
list of the centralizers which occur in characteristic `p` is returned.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> SScentralizer_representatives(W)
6-element Array{Array{Int64,1},1}:
 []
 [1]
 [2]
 [1, 2]
 [1, 5]
 [2, 6]

julia> reflection_subgroup.(Ref(W),SScentralizer_representatives(W))
6-element Array{FiniteCoxeterSubGroup{Perm{Int16},Int64},1}:
 G₂₍₎=Φ₁²
 G₂₍₁₎=A₁Φ₁
 G₂₍₂₎=Ã₁Φ₁
 G₂
 G₂₍₁₅₎=A₂
 G₂₍₂₆₎=Ã₁×A₁

julia> SScentralizer_representatives(W,2)
5-element Array{Array{Int64,1},1}:
 []
 [1]
 [2]
 [1, 2]
 [1, 5]
```
"""
function SScentralizer_representatives(W,p=0)
# W-orbits of subsets of Π∪ {-α₀}
  l=map(refltype(W))do t
    cent=parabolic_representatives(reflection_subgroup(W,t.indices))
    cent=map(x->reflection_subgroup(W,t.indices[x]),cent)
    npara=length(cent)
    r=filter(i->sum(W.rootdec[i])==sum(W.rootdec[i][t.indices]),1:nref(W))
    (m,h)=findmax(sum.(W.rootdec[r]))
    ED=vcat(t.indices,[r[h]])
    for J in combinations(ED)
      if length(J)==length(ED) continue end
      R=reflection_subgroup(W,J)
      if !isnothing(standard_parabolic(W,R)) continue end
      u=findall(G->IsomorphismType(R)==IsomorphismType(G),cent[npara+1:end])
      if length(u)>0 println(u,R) end
      if all(G->isnothing(transporting_elt(W,sort(inclusiongens(R)),
                 sort(inclusiongens(G)),action=(s,g)->sort!(s.^g))),cent[npara+u])
        push!(cent,R)
      end
    end
    cent=inclusiongens.(cent)
    if p==0 return cent end
    filter(I->all(x->x==0 || x%p!=0,
                    toM(MatInt.SmithNormalFormIntegerMat(W.rootdec[I]))),cent)
  end
  map(x->vcat(x...),cartesian(l...))
end

function IsomorphismType(W;torus=false)
  t=reverse(tally(map(x->sprint(show,x;context=:limit=>true),refltype(W))))
  t=join(map(x-> x[2]==1 ? x[1] : string(x[2],x[1]),t),"+")
  d=rank(W)-semisimplerank(W)
  if d>0 && torus
    if t!="" t*="+" end
    t*="T"*string(d)
  end
  t
end

include("sscoset.jl")
end
