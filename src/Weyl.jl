"""
Let  `V` be a  real vector space.  Finite Coxeter groups  coincide with the
finite  subgroups of  `GL(V)` which  can be  generated y reflections. *Weyl
groups*  are  the  finite  Coxeter  groups  which  can  be defined over the
rational   numbers.  We  implement  finite   Coxter  groups  as  groups  of
permutations  of  a  root  system.  Root  systems play an important role in
mathematics as they classify semi-simple Lie algebras and algebraic groups.

Let  us give precise definitions. Let `V`  be a real vector space, `Vⱽ` its
dual  and let `(,)`  be the natural  pairing between `Vⱽ`  and `V`. A *root
system*  is a finite set  of vectors `R` which  generate `V` (the *roots*),
together  with  a  map  `r↦  rⱽ`  from  `R`  to  a subset `Rⱽ` of `Vⱽ` (the
*coroots*) such that:

-  For any `r∈  R`, we have  `(rⱽ,r)=2` so that  the formula `x↦ x-(rⱽ,x)r`
defines a reflection `s_r:V→ V` with root `r` and coroot `rⱽ`.
- The reflection `s_r` stabilizes `R`.

We  will only  consider *reduced*  root systems,  i.e., such  that the only
elements  of `R` colinear with `r∈ R` are `r` and `-r`; for Weyl groups, we
also ask that the root system be *crystallographic*, that is `(rⱽ,s)` is an
integer, for any `s∈ R,rⱽ∈ Rⱽ`.

The  subgroup `W=W(R)` of  `GL(V)` generated by  the reflections `s_r` is a
finite  Coxeter group; when `R` is crystallographic, the representation `V`
of  `W`  is  defined  over  the  rational  numbers.  All finite-dimensional
(complex)  representations of a  finite Coxeter group  can be realized over
the  same field  as `V`.  Weyl groups  can be  characterized amongst finite
Coxeter  groups by the fact that all numbers `m(s,t)` in the Coxeter matrix
are in `{2,3,4,6}`.

If  we identify  `V` with  `Vⱽ` by  choosing a  `W`-invariant bilinear form
`(.;.)`;  then we have `rⱽ=2r/(r;r)`. A root system `R` is *irreducible* if
it is not the union of two orthogonal subsets. If `R` is reducible then the
corresponding  Coxeter group  is the  direct product  of the Coxeter groups
associated with the irreducible components of `R`.

The  irreducible  crystallographic  root  systems  are  classified  by  the
following  list of  *Dynkin diagrams*,  which, in  addition to  the Coxeter
matrix,  encode also the relative length of the roots. We show the labeling
of the nodes given by the function 'Diagram' described below.

```
A_n O—O—O—…—O   B_n O⇐O—O—…—O  C_n O⇒ O—O—…—O  D_n  O 2
    1 2 3 … n       1 2 3 … n      1  2 3 … n       ￨
                                                  O—O—…—O
                                                  1 3 … n

G₂ O⇛ O  F₄ O—O⇒ O—O  E₆   O 2   E₇   O 2     E₈    O 2
   1  2     1 2  3 4       ￨          ￨             ￨
                       O—O—O—O—O  O—O—O—O—O—O   O—O—O—O—O—O—O
                       1 3 4 5 6  1 3 4 5 6 7   1 3 4 5 6 7 8
```

These diagrams encode the presentation of the Coxeter group `W` as follows:
the vertices represent the generating reflections; an edge is drawn between
`s`  and `t` if the order `m(s,t)` of `st` is greater than `2`; the edge is
single  if  `m(s,t)=3`,  double  if  `m(s,t)=4`,  triple if `m(s,t)=6`. The
arrows  indicate the relative root lengths when `W` has more than one orbit
on  `R`, as explained below; we  get the *Coxeter Diagram*, which describes
the  underlying Weyl group, if  we ignore the arrows:  we see that the root
systems `B_n` and `C_n` correspond to the same Coxeter group.

Here  are  the  diagrams  for  the  finite  Coxeter  groups which  are  not
crystallographic:

```
       e        5         5
I₂(e) O—O   H₃ O—O—O  H₄ O—O—O—O
      1 2      1 2 3     1 2 3 4 
```

Let us now describe how the root systems are encoded in these diagrams. Let
`R`  be a root system in `V`. Then we can choose a linear form on `V` which
vanishes  on no element of `R`. According to  the sign of the value of this
linear  form on a root  `r ∈ R` we  call `r` *positive* or *negative*. Then
there  exists a unique subset `Π` of  the positive roots, called the set of
*simple  roots*, such that  any positive root  is a linear combination with
non-negative  coefficients of  roots in  `Π`. Any  two sets of simple roots
(corresponding  to  different  choices  of  linear  forms  as above) can be
transformed into each other by a unique element of `W(R)`. Hence, since the
pairing  between `V` and `Vⱽ`  is `W`-invariant, if `Π`  is a set of simple
roots  and if  we define  the *Cartan  matrix* as  being the  `n` times `n`
matrix   `C={rⱽ(s)}_{rs}`,  for  `r,s∈Π`  this   matrix  is  unique  up  to
simultaneous  permutation of rows and columns.  It is precisely this matrix
which is encoded in a Dynkin diagram, as follows.

The  indices for the rows of `C` label the nodes of the diagram. The edges,
for  `r ≠ s`, are  given as follows. If  `C_{rs}` and `C_{sr}` are integers
such  that `|C_{rs}|≥|C_{sr}|=1`  the vertices  are connected by `|C_{rs}|`
lines,  and if `|C_{rs}|>1`  then we put  an additional arrow  on the lines
pointing  towards the node with label `s`.  In other cases, we simply put a
single   line  equipped  with  the  unique  integer  `p_{rs}≥1`  such  that
`C_{rs}C_{sr}=cos^2 (π/p_{sr})`.

Conversely,  the whole root  system can be  recovered from the simple roots
and  the corresponding coroots. The  reflections in `W(R)` corresponding to
the  simple roots are called  *simple* reflections or *Coxeter generators*.
They are precisely the generators for which the Coxeter diagram encodes the
defining  relations of `W(R)`. Each root is  in the orbit of a simple root,
so  that `R` is obtained  as the orbit of  the simple roots under the group
generated  by  the  simple  reflections.  The  restriction  of  the  simple
reflections  to the span of `R` is  determined by the Cartan matrix, so `R`
is determined by the Cartan matrix and the set of simple roots.

The  Cartan  matrix  corresponding  to  one  of  the above irreducible root
systems  (with the specified labeling) is  returned by the command 'cartan'
which  takes as input  a `Symbol` giving  the type (that  is ':A', ':B', …,
':I')  and a positive `Int` giving the  rank (plus an `Int` giving the bond
for  type `:I`).  This function  returns a  matrix with  entries in `ℤ` for
crystallographic  types, and a  matrix of `Cyc`  for the other types. Given
two  Cartan matrices `c1` and `c2`,  their matrix direct sum (corresponding
to  the  orthogonal  direct  sum  of  the  root systems) can be produced by
`cat(c1,c2,dims=[1,2])`.

The  function 'rootdatum' takes as input a  list of simple roots and a list
of the corresponding coroots and produces a `struct` containing information
about  the root system `R` and about `W(R)`. If we label the positive roots
by  '1:N', and the negative roots  by 'N+1:2N', then each simple reflection
is  represented by the permutation of '1:2N' which it induces on the roots.
If  only one argument is given, the Cartan matrix of the root system, it is
taken  as the list  of coroots and  the list of  roots is assumed to be the
canonical basis of `V`.

If one only wants to work with Cartan matrices with a labeling as specified
by  the  above  list,  the  function  call  can  be  simplified. Instead of
'rootdatum(cartan(:D,4))' the following is also possible.

```julia-repl
julia> W=coxgroup(:D,4)
D₄

julia> cartan(W)
4×4 Array{Int64,2}:
  2   0  -1   0
  0   2  -1   0
 -1  -1   2  -1
  0   0  -1   2
```

Also,  the Weyl group struct associated to a direct sum of irreducible root
systems can be obtained as a product

```julia-repl
julia> W=coxgroup(:A,2)*coxgroup(:B,2)
A₂× B₂₍₃₄₎

julia> cartan(W)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2   0   0
  0   0   2  -2
  0   0  -1   2
```
The  same `struct`  is constructed  by applying  'coxgroup' to  the matrix
'cat(cartan(:A,2), cartan(:B,2),dims=[1,2])'.

The elements of a Weyl group are permutations of the roots:
```julia-repl
julia> W=coxgroup(:D,4)
D₄

julia> p=W(1,3,2,1,3)
Int16(1,14,13,2)(3,17,8,18)(4,12)(5,20,6,15)(7,10,11,9)(16,24)(19,22,23,21)

julia> word(W,p)
5-element Array{Int64,1}:
 1
 3
 1
 2
 3

```
This module is mostly a port of the basic functions on Weyl groups in CHEVIE.
The dictionary from CHEVIE is as follows:
```
     CartanMat("A",5)                       →  cartan(:A,5) 
     CoxeterGroup("A",5)                    →  coxgroup(:A,5) 
     Size(W)                                →  length(W) 
     ForEachElement(W,f)                    →  for w in W f(w) end 
     ReflectionDegrees(W)                   →  degrees(W) 
     IsLeftDescending(W,w,i)                →  isleftdescent(W,w,i) 
     ReflectionSubgroup                     →  reflection_subgroup
     TwoTree(m)                             →  twotree(m) 
     FiniteCoxeterTypeFromCartanMat(m)      →  type_cartan(m) 
     RootsCartan(m)                         →  roots(m) 
     PrintDiagram(W)                        →  Diagram(W) 
     Inversions                             →  inversions 
     Reflection                             →  reflection 
     W.orbitRepresentative[i]               →  simple_representative(W,i) 
     ElementWithInversions                  →  with_inversions
```
finally, a benchmark on julia 1.0.2
```benchmark
julia> @btime length(elements(coxgroup(:E,7)))
  531.385 ms (5945569 allocations: 1.08 GiB)
```
GAP3 for the same computation takes 2.2s
"""
module Weyl

export coxgroup, FiniteCoxeterGroup, inversions, two_tree, rootdatum, torus,
 dimension, with_inversions, AlgebraicCentre

using Gapjm, LinearAlgebra
#------------------------ Cartan matrices ----------------------------------
"""
    `cartan(type, rank)`

Cartan matrix for a Weyl group:

```julia-repl
julia> cartan(:A,4)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2  -1   0
  0  -1   2  -1
  0   0  -1   2
```
"""
function PermRoot.cartan(t::Symbol,r::Int,b::Int=0)
  if t==:A return Matrix(SymTridiagonal(fill(2,r),fill(-1,r-1))) end
  m=cartan(:A,r) 
  if r==1 return m end
  if t==:B m[1,2]=-2 
  elseif t==:C m[2,1]=-2 
  elseif t==:Bsym m=Cyc{Int}.(m) 
    m[1,2]=m[2,1]=ER(2)
  elseif t==:D if r>2 m[1:3,1:3]=[2 0 -1; 0 2 -1;-1 -1 2] else m=[2 0;0 2] end
  elseif t==:E m[1:4,1:4]=[2 0 -1 0; 0 2 0 -1;-1 0 2 -1;0 -1 -1 2]
  elseif t==:F m[3,2]=-2 
  elseif t==:Fsym m=Cyc{Int}.(m) 
    m[3,2]=m[2,3]=ER(2)
  elseif t==:G m[2,1]=-3
  elseif t==:Gsym m=Cyc{Int}.(m) 
    m[1,2]=m[2,1]=ER(3)
  elseif t==:H m=Cyc{Int}.(m) 
    m[1,2]=m[2,1]=E(5,2)+E(5,3)
  elseif t==:I 
    if b%2==0 return [2 -1;-2-E(b)-E(b,-1) 2]
    else return [2 -E(2*b)-E(2*b,-1);-E(2*b)-E(2*b,-1) 2]
    end
  else error("unknown type")
  end
  m
end

function PermRoot.cartan(t::Dict{Symbol,Any})
  if haskey(t,:cartantype) && t[:series]==:B &&t[:cartantype]==1
       cartan(:C,length(t[:indices]))
  elseif haskey(t,:bond) cartan(:I,2,t[:bond])
  else cartan(t[:series],length(t[:indices]))
  end
end

"""
    two_tree(m)

 Given  a square  matrix m  with zeroes  (or falses,  for a boolean matrix)
 symmetric  with respect to the diagonal, let  G be the graph with vertices
 axes(m)[1] and an edge between i and j iff !iszero(m[i,j]).
 If G  is a line this function returns it as a Vector{Int}. 
 If  G  is  a  tree  with  one  vertex  c of valence 3 the function returns
 (c,b1,b2,b3)  where b1,b2,b3 are  the branches from  this vertex sorted by
 increasing length.
 Otherwise the function returns `nothing`
```julia-repl
julia> Weyl.two_tree(cartan(:A,4))
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> Weyl.two_tree(cartan(:E,8))
(4, [2], [3, 1], [5, 6, 7, 8])
```
"""
two_tree=function(m::AbstractMatrix)
  function branch(x)
    while true
      x=findfirst(i->m[x,i]!=0 && !(i in line),axes(m,2))
      if !isnothing(x) push!(line,x) else break end
    end
  end
  line=[1]
  branch(1)
  l=length(line)
  branch(1)
  line=vcat(line[end:-1:l+1],line[1:l])
  l=length(line)
  if any(i->any(j->m[line[j],line[i]]!=0,1:i-2),1:l) return nothing end
  r=size(m,1)
  if l==r return line end
  p = findfirst(x->any(i->!(i in line)&&(m[x,i]!=0),1:r),line)
  branch(line[p])
  if length(line)!=r return nothing end
  (line[p],sort([line[p-1:-1:1],line[p+1:l],line[l+1:r]], by=length)...)
end

" (series,rank) for an irreducible Cartan matrix"
function type_irred_cartan(m::AbstractMatrix)
  rank=size(m,1)
  s=two_tree(m)
  if isnothing(s) return nothing end
  t=Dict{Symbol,Any}()
  if s isa Tuple # types D,E
    (vertex,b1,b2,b3)=s
    if length(b2)==1 t[:series]=:D 
      t[:indices]=[b1;b2;vertex;b3]::Vector{Int}
    else t[:series]=:E 
      t[:indices]=[b2[2];b1[1];b2[1];vertex;b3]::Vector{Int}
    end 
  else  # types A,B,C,F,G,H,I
    l=i->m[s[i],s[i+1]]
    r=i->m[s[i+1],s[i]] 
    function rev() s=s[end:-1:1] end
    if rank==1 t[:series]=:A 
    elseif rank==2 
      if l(1)*r(1)==1 t[:series]=:A 
      elseif l(1)*r(1)==2 t[:series]=:B  
        if l(1)==-1 rev() end # B2 preferred to C2
        t[:cartantype]=-l(1)
      elseif l(1)*r(1)==3 t[:series]=:G  
        if l(1)!=-1 rev() end 
        t[:cartantype]=1
      else n=conductor(l(1)*r(1))
        if r(1)==-1 || (r(1)==-1 && r(1)>l(1)) rev() end
        if l(1)*r(1)==2+E(n)+E(n,-1) bond=n else bond=2n end
        t[:series]=:I
        if bond%2==0 t[:cartantype]=-l(1) end
        t[:bond]=bond
      end
    else
      if l(rank-1)*r(rank-1)!=1 rev() end 
      if l(1)*r(1)==1
        if l(2)*r(2)==1 t[:series]=:A 
        else t[:series]=:F
          if l(2)!=-1 rev() end 
          t[:cartantype]=1
        end
      else n=conductor(l(1)*r(1))
        if n==5 t[:series]=:H
        else t[:series]=:B
          t[:cartantype]=-l(1)
        end  
      end  
    end 
    t[:indices]=s::Vector{Int}
  end 
# println("t=$t")
  if cartan(t)!=m[t[:indices],t[:indices]] return nothing end  # countercheck
  t
end

"""
    type_cartan(C)

 return a list of (series=s,indices=[i1,..,in]) for a Cartan matrix
"""
function type_cartan(m::AbstractMatrix)
  map(blocks(m)) do I
    t=type_irred_cartan(m[I,I])
    if isnothing(t) error("unknown Cartan matrix ",m[I,I]) end
    t[:indices]=I[t[:indices]]
    TypeIrred(t)
  end
end

"""
    roots(C)

 return the set of positive roots defined by the Cartan matrix C
 works for any finite Coxeter group
"""
function PermRoot.roots(C::Matrix)
  o=one(C)
  R=[o[i,:] for i in axes(C,1)] # fast way to get rows of one(C)
  j=1
  while j<=length(R)
    a=R[j]
    c=C*a
    for i in axes(C,1)
      if j!=i 
        v=copy(a)
        v[i]-=c[i]
        if !(v in R) push!(R,v) end
      end
    end
    j+=1
  end 
  R
end 


function coxeter_from_cartan(m)
  function find(c)
    if c in 0:4 return [2,3,4,6,0][c+1] end
    x=conductor(c)
    if c==2+E(x)+E(x,-1) return x 
    elseif c==2+E(2x)+E(2x,-1) return 2x
    else error("not a Cartan matrix of a Coxeter group")
    end
  end
  res=one(m)
  for i in 2:size(m,1), j in 1:i-1
    res[i,j]=res[j,i]=find(m[i,j]*m[j,i])
  end
  res
end

#-------Finite Coxeter groups --- T=type of elements----T1=type of roots------
abstract type FiniteCoxeterGroup{T,T1} <: CoxeterGroup{T} end

CoxGroups.coxetermat(W::FiniteCoxeterGroup)=
     coxeter_from_cartan(cartan(W))

# finite Coxeter groups have functions nref and fields rootdec
inversions(W::FiniteCoxeterGroup,w)=
     [i for i in 1:nref(W) if isleftdescent(W,w,i)]

#  with_inversions(<W>,<N>)
#
# given the set N of positive roots of W negated by an element w, find w.
# N is a subset of [1..W.N] (not W.parentN!)
function with_inversions(W,N)
  w=one(W)
  n=N
  while !isempty(n)
    p=intersect(n,eachindex(gens(W)))
    if isempty(p) return nothing end
    r=reflection(W,p[1])
    n=restriction.(Ref(W),inclusion.(Ref(W),setdiff(n,[p[1]])).^r)
    w=r*w
  end
  w^-1
end

Base.length(W::FiniteCoxeterGroup,w)=count(i->isleftdescent(W,w,i),1:nref(W))

PermRoot.refltype(W::FiniteCoxeterGroup)::Vector{TypeIrred}=
   gets(W->type_cartan(cartan(W)),W,:refltype)

"""
  The reflection degrees of W
"""
function Gapjm.degrees(W::FiniteCoxeterGroup)
  if iszero(W.N) return Int[] end
  l=sort(map(length,values(groupby(sum,W.rootdec[1:W.N]))),rev=true)
  reverse(1 .+conjugate_partition(l))
end

dimension(W::FiniteCoxeterGroup)=2*nref(W)+Gapjm.rank(W)
Base.length(W::FiniteCoxeterGroup)=prod(degrees(W))

#forwarded methods to PermRoot/W.G
@inline PermRoot.cartan(W::FiniteCoxeterGroup)=cartan(W.G)
Gapjm.degree(W::FiniteCoxeterGroup)=degree(W.G)
PermRoot.reflections(W::FiniteCoxeterGroup)=reflections(W.G)
Base.iterate(W::FiniteCoxeterGroup,a...)=iterate(W.G,a...)
Base.eltype(W::FiniteCoxeterGroup)=eltype(W.G)
Base.parent(W::FiniteCoxeterGroup)=W
PermRoot.reflength(W::FiniteCoxeterGroup,w)=reflength(W.G,w)
PermRoot.hyperplane_orbits(W::FiniteCoxeterGroup)=hyperplane_orbits(W.G)
PermRoot.refleigen(W::FiniteCoxeterGroup)=refleigen(W.G)
PermRoot.torus_order(W::FiniteCoxeterGroup,q,i)=refleigen(W.G,q,i)
PermRoot.rank(W::FiniteCoxeterGroup)=PermRoot.rank(W.G)
PermRoot.matX(W::FiniteCoxeterGroup,w)=PermRoot.matX(W.G,w)
PermRoot.inclusion(W::FiniteCoxeterGroup,x...)=inclusion(W.G,x...)
PermRoot.independent_roots(W::FiniteCoxeterGroup)=independent_roots(W.G)
PermRoot.semisimplerank(W::FiniteCoxeterGroup)=semisimplerank(W.G)
PermRoot.restriction(W::FiniteCoxeterGroup,a...)=restriction(W.G,a...)
PermGroups.position_class(W::FiniteCoxeterGroup,a...)=position_class(W.G,a...)
Gapjm.root(W::FiniteCoxeterGroup,i)=roots(W.G)[i]
#--------------- FCG -----------------------------------------
struct FCG{T,T1,TW<:PermRootGroup{T1,T}} <: FiniteCoxeterGroup{Perm{T},T1}
  G::TW
  rootdec::Vector{Vector{T1}}
  N::Int
  prop::Dict{Symbol,Any}
end

(W::FCG)(x...)=element(W.G,x...)
"number of reflections of W"
@inline CoxGroups.nref(W::FCG)=W.N
CoxGroups.isleftdescent(W::FCG,w,i::Int)=i^w>W.N

"Coxeter group from type"
coxgroup(t::Symbol,r::Int=0,b::Int=0)=iszero(r) ? coxgroup() : rootdatum(cartan(t,r,b))

" Adjoint root datum from cartan mat"
rootdatum(C::Matrix)=rootdatum(one(C),C)

" root datum"
function rootdatum(rr::Matrix,cr::Matrix)
  C=cr*permutedims(rr)
  rootdec=roots(C)
  N=length(rootdec)
  r=Ref(permutedims(rr)).*rootdec
  r=vcat(r,-r)
  rootdec=vcat(rootdec,-rootdec)
  # the reflections defined by Cartan matrix C
  matgens=[reflection(rr[i,:],cr[i,:]) for i in axes(C,1)]
# matgens=map(reflection,eachrow(rr),eachrow(cr))
  """
    the permutations of the roots r effected by the matrices matgens
  """
  gens=Perm{Int16}.(matgens,Ref(r),action=(v,m)->permutedims(m)*v)
  rank=size(C,1)
  G=PRG(matgens,r,map(i->cr[i,:],1:rank),Group(gens),
    Dict{Symbol,Any}(:cartan=>C))
  FCG(G,rootdec,N,Dict{Symbol,Any}())
end

function rootdatum(t::Symbol,r::Int)
  id(r)=one(fill(0,r,r))
  data=Dict{Symbol,Function}(
   :gl=>function(r)
     if r==1 return torus(1) end
     R=id(r)
     R=R[1:end-1,:]-R[2:end,:]
     rootdatum(R,R)
     end,
   :sl=>r->rootdatum(cartan(:A,r-1),id(r-1)),
   :pgl=>r->coxgroup(:A,r-1),
   :sp=>function(r)
     R=id(div(r,2))
     for i in 2:div(r,2) R[i,i-1]=-1 end
     R1=copy(R)
     R1[1,:].*=2
     rootdatum(R1,R)
     end,
   :csp=>function(r)
     r=div(r,2)
     R=id(r+1)
     R=R[1:r,:]-R[2:end,:] 
     cR=copy(R) 
     R[1,1:2]=[0,-1] 
     cR[1,1:2]=[1,-2]
     rootdatum(cR,R)
     end,
  :psp=>r->coxgroup(:C,div(r,2)),
  :so=>function(r)
    R=id(div(r,2)) 
    for i in 2:div(r,2) R[i,i-1]=-1 end
    if isodd(r) R1=copy(R)
      R1[1,1]=2
      rootdatum(R,R1)
    else R[1,2]=1 
      rootdatum(R,R)
    end
  end,
  :pso=>function(r)
    r1=div(r,2)
    isodd(r) ? coxgroup(:B,r1) : coxgroup(:D,r1)
    end,
  :spin=>function(r)
    r1=div(r,2)
    isodd(r) ? rootdatum(cartan(:B,r1),id(r1)) : rootdatum(cartan(:D,r1),id(r1))
    end,
  :halfspin=>function(r)
    if !iszero(r%4) error("halfspin groups only exist in dimension 4r") end
    r=div(r,2)
    R=id(r)
    R[r,:]=vcat([-div(r,2),1-div(r,2)],2-r:1:-2,[2])
    rootdatum(R,Int.(cartan(:D,r)*permutedims(inv(Rational.(R)))))
    end,
  :gpin=>function(r)
    d=div(r,2)
    R=id(d+1)
    R=R[1:d,:]-R[2:end,:]
    cR=copy(R)
    if isodd(r)
      R[1,1]=0
      cR[1,2]=-2
    else
      R[1,3]=-1
      cR[1,1:3]=[0,-1,-1]
      R=hcat(fill(0,d),R)
      cR=hcat(fill(0,d),cR)
      cR[1,1]=1
    end
    rootdatum(R,cR)
   end,
   :E=>r->coxgroup(:E,r),
   :Esc=>r->rootdatum(cartan(:E,r),id(r))
   )
   if haskey(data,t) return data[t](r) end
   error("Unknown root datum $(repr(t)). Known types are:\n",
              join(sort(collect(keys(data))),", "))
end

function torus(i)
  G=PRG(Matrix{Int}[],Vector{Int}[],Vector{Int}[],
   Group(Perm{Int16}[]),Dict{Symbol,Any}(:rank=>i))
  FCG(G,Vector{Int}[],0,Dict{Symbol,Any}())
end

coxgroup()=torus(0)

function Base.show(io::IO, W::FCG)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if isempty(refltype(W)) 
    print(io,"coxgroup()") 
    return
  end
  n=join(map(refltype(W))do t
    indices=t[:indices]
    n=sprint(show,t; context=io)
    if indices!=eachindex(indices) && (repl|| TeX)
      ind=any(i->i>10,indices) ? join(indices,",") : join(indices)
      n*="_{($ind)}"
    end
    n
  end,repl||TeX ? "\\times " : "*")
  if repl n=TeXstrip(n) end
  print(io,n)
end
  
#function matX(W::FCG,w)
#  vcat(permutedims(hcat(root.(Ref(W),(1:coxrank(W)).^w)...)))
#end

function cartancoeff(W::FCG,i,j)
  v=findfirst(x->!iszero(x),root(W,i))
  r=root(W,j)-root(W,j^reflection(W,i))
  div(r[v],root(W,i)[v])
end

function Base.:*(W1::FiniteCoxeterGroup,W2::FiniteCoxeterGroup)
  mroots(W)=toM(roots(W.G)[1:semisimplerank(W)])
  mcoroots(W)=toM(coroots(W.G)[1:semisimplerank(W)])
  r=roots(W1.G)
  cr=roots(W2.G)
  if isempty(r)
    if isempty(cr) return torus(Gapjm.rank(W1)+Gapjm.rank(W2)) end
    r=mroots(W2)
    r=hcat(r,zeros(eltype(r),size(r,1),Gapjm.rank(W1)))
    cr=mcoroots(W2)
    cr=hcat(cr,zeros(eltype(cr),size(cr,1),Gapjm.rank(W1)))
  elseif isempty(cr)
    r=mroots(W1)
    r=hcat(r,zeros(eltype(r),size(r,1),Gapjm.rank(W2)))
    cr=mcoroots(W1)
    cr=hcat(cr,zeros(eltype(cr),size(cr,1),Gapjm.rank(W2)))
  else
    r=cat(mroots(W1),mroots(W2),dims=[1,2])
    cr=cat(mcoroots(W1),mcoroots(W2),dims=[1,2])
  end
  return rootdatum(r,cr)
end

"for each root index of simple representative"
CoxGroups.simple_representatives(W::FCG)=simple_representatives(W.G)
  
"for each root element conjugative representative to root"
simple_conjugating_element(W::FCG,i)=
   simple_conjugating_element(W.G,i)

PermRoot.reflection(W::FCG,i::Integer)=reflection(W.G,i)
#--------------- FCSG -----------------------------------------
struct FCSG{T,T1,TW<:PermRootGroup{T1,T}} <: FiniteCoxeterGroup{Perm{T},T1}
  G::TW
  rootdec::Vector{Vector{T1}}
  N::Int
  parent::FCG{T,T1}
  prop::Dict{Symbol,Any}
end

(W::FCSG)(x...)=element(W.G,x...)
CoxGroups.nref(W::FCSG)=W.N

Base.parent(W::FCSG)=W.parent
PermRoot.matX(W::FCSG,w)=matX(parent(W),w)

"""
reflection_subgroup(W,I)
The subgroup of W generated by reflections(W)[I]

A   theorem  discovered  by  Deodhar  cite{Deo89}  and  Dyer  cite{Dye90}
independently  is that a subgroup `H` of a Coxeter system `(W,S)` generated
by  reflections has  a canonical  Coxeter generating  set, formed of the `t
∈Ref(H)`  such `l(tt')>l(t)` for any `t'∈  Ref(H)` different from `t`. This
is used by 'reflection_subgroup' to determine the Coxeter system of `H`.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> Diagram(W)
O⇛ O
1  2

julia> H=reflection_subgroup(W,[2,6])
G₂₍₂₄₎

julia> Diagram(H)
O—O
1 2
```

The  notation `G₂₍₂₃₎` means  that 'W.roots[2:3]' form  a system of simple
roots for `H`.

A  reflection subgroup has specific properties  the most important of which
is  'inclusion' which gives the positions of the roots of H in the roots of
W. The inverse (partial) map is 'restriction'.

```julia-repl
julia> inclusion(H)
6-element Array{Int64,1}:
  2
  4
  6
  8
 10
 12

julia> restriction(H)
12-element Array{Int64,1}:
 0
 1
 0
 2
 0
 3
 0
 4
 0
 5
 0
 6

```


If H is a standard parabolic subgroup  of a Coxeter group W then the
length function  on H (with respect  to its set of  generators) is the
restriction of  the length function on  W. This need not  no longer be
true for arbitrary reflection subgroups of W:

```julia-repl
julia> word(W,H(2))
3-element Array{Int64,1}:
 1
 2
 1
```

In  this package, finite  reflection groups are  represented as permutation
groups  on a set of roots. Consequently,  a reflection subgroup `H⊆ W` is a
permutation  subgroup, thus its elements are represented as permutations of
the roots of the parent group.

```julia-repl
julia> elH=word.(Ref(H),elements(H))
6-element Array{Array{Int64,1},1}:
 []       
 [2]      
 [1]      
 [2, 1]   
 [1, 2]   
 [1, 2, 1]

julia> elW=word.(Ref(W),elements(H))
6-element Array{Array{Int64,1},1}:
 []             
 [1, 2, 1]      
 [2]            
 [1, 2, 1, 2]   
 [2, 1, 2, 1]   
 [2, 1, 2, 1, 2]

julia> map(w->H(w...),elH)==map(w->W(w...),elW)
true

```
Another  basic result about reflection subgroups  of Coxeter groups is that
each  coset of  H in  W contains  a unique  element of  minimal length, see
`reduced`.
"""
function PermRoot.reflection_subgroup(W::FCG{T,T1},I::AbstractVector{Int})where {T,T1}
  G=Group(reflection.(Ref(W),I))
  inclusion=sort!(vcat(orbits(G,I)...))
  N=div(length(inclusion),2)
  if all(i->i in 1:coxrank(W),I)
    C=cartan(W)[I,I]
  else
    let N=N
    I=filter(inclusion[1:N]) do i
      cnt=0
      r=reflection(W,i)
      for j in inclusion[1:N]
        if j!=i && j^r>W.N return false end
      end
      return true
    end
    end
    G=Group(reflection.(Ref(W),I))
    C=T1[cartancoeff(W,i,j) for i in I, j in I]
  end
  rootdec=roots(C)
  rootdec=vcat(rootdec,-rootdec)
  if isempty(rootdec) inclusion=Int[]
  else inclusion=map(rootdec)do r
    findfirst(isequal(sum(r.*W.rootdec[I])),W.rootdec)
    end
  end
  restriction=zeros(Int,2*W.N)
  restriction[inclusion]=1:length(inclusion)
  prop=Dict{Symbol,Any}(:cartan=>C)
  if isempty(inclusion) prop[:rank]=PermRoot.rank(W) end
  G=PRSG(G,inclusion,restriction,W.G,prop)
  FCSG(G,rootdec,N,W,Dict{Symbol,Any}())
end

function Base.show(io::IO, W::FCSG)
  I=inclusion(W)[1:coxrank(W)]
  n=any(i->i>=10,I) ? join(I,",") : join(I)
  repl=get(io,:limit,false)
  if !repl print(io,"reflection_subgroup(") end
  print(io,sprint(show,W.parent; context=io))
  if repl print(io,TeXstrip("_{($n)}"))
  else print(io,",$I)")
  end
end
  
PermRoot.reflection_subgroup(W::FCSG,I::AbstractVector{Int})=
  reflection_subgroup(W.parent,inclusion(W)[I])

@inbounds CoxGroups.isleftdescent(W::FCSG,w,i::Int)=inclusion(W,i)^w>W.parent.N

#----------------------------------------------------------------------------

Base.mod1(a::Rational{Int})=mod(numerator(a),denominator(a))//denominator(a)

abstract type SemisimpleElement end

struct AdditiveSE<:SemisimpleElement
  v::Vector{Rational{Int}}
  W::FiniteCoxeterGroup
end

AdditiveSE(W::FiniteCoxeterGroup,v::Vector{Rational{Int}})=AdditiveSE(mod1.(v),W)

Base.show(io::IO,a::SemisimpleElement)=print(io,"<",join(a.v,","),">")

Base.one(a::AdditiveSE)=AdditiveSE(a.W,0 .*a.v)
Base.isone(a::AdditiveSE)=all(iszero,a.v)

" hash is needed for using Perms in Sets/Dicts"
Base.hash(a::AdditiveSE, h::UInt)=hash(a.v, h)
Base.:(==)(a::AdditiveSE, b::AdditiveSE)=a.v==b.v

Perms.order(a::AdditiveSE)=lcm(denominator.(a.v))

Base.:*(a::AdditiveSE,b::AdditiveSE)=AdditiveSE(a.W,mod1.(a.v .+ b.v))

struct SEGroup<:Group{AdditiveSE}
  gens::Vector{AdditiveSE}
  prop::Dict{Symbol,Any}
end

Base.show(io::IO,G::SEGroup)=print(io,"SEGroup(",gens(G),")")

function Group(a::AbstractVector{AdditiveSE})
  a=filter(x->!isone(x),a)
  SEGroup(a,Dict{Symbol,Any}())
end

struct SubTorus
  generators::Vector{Vector{Int}}
  complement::Vector{Vector{Int}}
  group
end

function SubTorus(W,V=matX(W,one(W)))
  V=ComplementIntMat(toL(matX(W,one(W))),toL(V))
  if any(x->x!=1,V[:moduli])
    error("not a pure sublattice")
    return false
  end
  SubTorus(V[:sub],V[:complement],W)
end

Base.show(io::IO,T::SubTorus)=print(io,"SubTorus(",T.group,",",T.generators,")")

Gapjm.rank(T::SubTorus)=length(T.generators)

# element in subtorus
function Base.:in(s,T::SubTorus)
  n=Lcm(List(s.v,Denominator))
  s=s.v*n
  V=List(T.generators,x->mod.(x,n))
  i=1
  for v in Filtered(V,x->!iszero(x))
    while v[i]==0 
      if s[i]!=0 return false
      else i+=1
      end
    end
    r=Gcdex(n,v[i])
    v=mod.(r.coeff2.*v,n)
    if mod(s[i],v[i])!=0 return false
    else s-=div(s[i],v[i]).*v
      s=mod.(s,n)
    end
  end
  iszero(s)
end

function AbelianGenerators(l)
  res=empty(l)
  l=filter(x->!isone(x),l)
  while !isempty(l)
    o=order.(l)
    push!(res,l[findfirst(isequal(maximum(o)),o)])
    l=setdiff(l,elements(Group(res)))
  end
  res
end

#F  AlgebraicCentre(W)  . . . centre of algebraic group W
##  
##  <W>  should be a Weyl group record  (or an extended Weyl group record).
##  The  function returns information  about the centre  Z of the algebraic
##  group defined by <W> as a record with fields:
##   Z0:         subtorus Z^0
##   complement: S=complement torus of Z0 in T
##   AZ:         representatives of Z/Z^0 given as a group of ss elts
##   [implemented only for connected groups 18/1/2010]
##   [I added something hopefully correct in general. JM 22/3/2010]
##   [introduced subtori JM 2017 and corrected AZ computation]
##   descAZ:  describes AZ as a quotient  of the fundamental group Pi (seen
##   as  the centre of  the simply connected  goup with same isogeny type).
##   Returns words in the generators of Pi which generate the kernel of the
##   map Pi->AZ
##
function AlgebraicCentre(W)
  if W isa HasType.ExtendedCox
    F0s=map(permutedims,W.F0s)
    W=W.group
  end
  if iszero(semisimplerank(W))
    Z0=toL(matX(W,one(W)))
  else
    Z0=NullspaceIntMat(collect.(collect(zip(
                                W.G.roots[1:semisimplerank(W)]...))))
  end
  Z0=SubTorus(W,toM(Z0))
  if isempty(Z0.complement) AZ=Vector{Rational{Int}}[]
  else
    AZ=toL(inv(Rational.(toM(Z0.complement)*
             hcat(W.G.roots[1:semisimplerank(W)]...)))*toM(Z0.complement))
  end
  AZ=AdditiveSE.(Ref(W),AZ)
  if W isa HasType.ExtendedCox # compute fixed space of F0s in Y(T)
    for m in F0s
      AZ=Filtered(AZ,s->(s/SemisimpleElement(W,s.v*m)) in Z0)
      if Rank(Z0)>0 Z0=FixedPoints(Z0,m)
        Append(AZ,Z0[2])
        Z0=Z0[1]
      end
    end
  end
  res=Dict(:Z0=>Z0,:AZ=>Group(AbelianGenerators(AZ)))
  if W isa HasType.ExtendedCox && length(F0s)>0 return res end
  AZ=AdditiveSE.(Ref(W),weightinfo(W)[:CenterSimplyConnected])
  if isempty(AZ) res[:descAZ]=AZ
    return res
  end
  AZ=Group(AZ)
  toAZ=function(s)
    s=vec(permutedims(s.v)*toM(W.G.coroots[1:semisimplerank(W)]))
    s=permutedims(s)*
       inv(Rational.(toM(vcat(res[:Z0].complement,res[:Z0].generators))))
       return AdditiveSE(W,vec(permutedims(vec(s)[1:semisimplerank(W)])*
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
                  println("h=$h")
                  map(x->word(AZ,x),gens(kernel(h)))
               end
  res
end

end
