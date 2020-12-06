"""
A  suitable  reference  for  the  general  theory of Coxeter groups is, for
example, Bourbaki "Lie Groups and Lie Algebras" chapter 4.

A *Coxeter group* is a group which has the presentation
``W=⟨S|(st)^{m(s,t)}=1\\hbox{  for  }s,t∈  S⟩``  for some symmetric integer
matrix `m(s,t)` called the *Coxeter matrix*, where `m(s,t)>1` for `s≠t` and
`m(s,s)=1`.  It is true (but a non-trivial theorem) that in a Coxeter group
the  order of `st` is exactly `m(s,t)`, thus a Coxeter group is the same as
a  *Coxeter system*, that is a pair `(W,S)`  of a group `W` and a set `S⊂W`
of  involutions, such  that the  group is  presented by  generators `S` and
relations  describing the order  of the product  of two elements  of `S`. A
Coxeter group has a natural representation, its *reflection
representation*, on a real vector space `V` of dimension `length(S)` (which
is  the  *Coxeter  rank*  of  W),  where  each  element  of  `S`  acts as a
reflection; the faithfulness of this representation in the main argument to
prove  that the order of `st` is  exactly `m(s,t)`. Thus Coxeter groups are
real  reflection  groups.  The  converse  need  not  be  true if the set of
reflecting  hyperplanes has  bad topological  properties, but  it turns out
that  finite Coxeter groups are the  same as finite real reflection groups.
The   possible  Coxeter  matrices  for  finite  Coxeter  groups  have  been
completely  classified,  see  the  `Weyl`  module; the corresponding finite
groups play a deep role in several areas of mathematics.

Coxeter  groups  have  a  nice  solution  to the word problem. The *length*
`l(w)`  of an element  `w∈ W` is  the minimum number  of elements of `S` of
which it is a product (since the elements of `S` are involutions, we do not
need inverses). An expression of `w` of minimal length is called a *reduced
word*  for `w`. The main property of  reduced words is the *exchange lemma*
which  states that if `s₁…sₖ` is a  reduced word for `w` (thus`k=l(w)`) and
`s∈  S` is such that `l(sw)≤l(w)` then one  of the `sᵢ` in the word for `w`
can be deleted to obtain a reduced word for `sw`. Thus given `s∈ S` and `w∈
W`,  either `l(sw)=l(w)+1` or  `l(sw)=l(w)-1` and we  say in this last case
that  `s` belongs to  the *left descent  set* of `w`.  The computation of a
reduced  word for an element, and other  word problems, are easy if we know
how  to multiply elements  and the left  descent sets. In  each case of the
Coxeter  groups that we implement, the left  descent set is easy to compute
(see  e.g.  'CoxSym'  below),  so  this  suggests  how to deal with Coxeter
groups generically:

The  type  `CoxeterGroup`  is  an  abstract  type;  an  actual struct which
implements it must define a function

`isleftdescent(W,w,i)` which tells whether the
      `i`-th element of `S` is in the left descending set of `w`.

the other functions needed in an instance of a Coxeter group are
- `gens(W)` which returns the set `S` (the list of *Coxeter generators*)
- `nref(W)` which  returns the  number of  reflections of  `W`, if  `W` is
   finite or `nothing` if `W` is infinite

It  should  be  noted  that  a  Coxeter  group  can  be *any* kind of group
implementing the above functions.

Because  of the  easy solution  of the  word problem  in Coxeter  groups, a
convenient  way  to  represent  their  elements  is as words in the Coxeter
generators. They are represented as lists of integers in `1:length(S)`. The
functions  'word' and 'W(...)' will do the conversion between Coxeter words
and elements of the group.

# Examples
```julia-repl
julia> W=CoxSym(4)
𝔖 ₄

julia> p=W(1,3,2,1,3)
Perm{UInt8}: (1,4)

julia> word(W,p)
5-element Array{Int64,1}:
 1
 2
 3
 2
 1
```
We  notice that the word we started with and the one that we ended up with,
are not the same, though they represent the same element of `W`. The reason
is  there are  several reduced  words for  an element  of `W`. The function
'word'  computes a lexicographically smallest word  for `w`. Below are some
other possible computations with the same Coxeter group:

```julia-repl
julia> word(W,longest(W))  # the (unique) longest element in W
6-element Array{Int64,1}:
 1
 2
 1
 3
 2
 1

julia> w0=longest(W)
Perm{UInt8}: (1,4)(2,3)
julia> length(W,w0)
6
julia> map(i->word(W,reflection(W,i)),1:nref(W))
6-element Array{Array{Int64,1},1}:
 [1]
 [2]
 [3]
 [1, 2, 1]
 [2, 3, 2]
 [1, 2, 3, 2, 1]
julia> [length(elements(W,i)) for i in 0:nref(W)]
7-element Array{Int64,1}:
 1
 3
 5
 6
 5
 3
 1
```

The above line tells us that there is 1 element of length 0, there are 6 of
length 3, …

For  most basic functions the convention is that the input is an element of
the  group, rather than  a Coxeter word.  The reason is  that for a Coxeter
group  which  is  a  permutation  group,  using the low level functions for
permutations  is usually  much faster  than manipulating lists representing
reduced expressions.

This module contains mostly a port of the basic functions on Coxeter groups
in  Chevie. The only Coxeter group  constructor implemented here is CoxSym.
The  module `Weyl` defines `coxgroup`, a function building a finite Coxeter
groups given its type.
"""
module CoxGroups

export bruhatless, CoxeterGroup, coxrank, firstleftdescent, leftdescents,
  longest, braid_relations, coxmat, CoxSym, standard_parabolic_class, GenCox

export isleftdescent, nref # 'virtual' methods (exist only for concrete types)

using Gapjm
#-------------------------- Coxeter groups
abstract type CoxeterGroup{T}<:Group{T} end

"""
`firstleftdescent(W,w)`

returns the index in `gens(W)` of the first element of the left descent set
of `w` --- that is, the first `i` such that if `s=W(i)` then `l(sw)<l(w).

```julia-repl
julia> W=CoxSym(3)
𝔖 ₃

julia> firstleftdescent(W,Perm(2,3))
2
```
"""
function firstleftdescent(W::CoxeterGroup,w)
  findfirst(i->isleftdescent(W,w,i),eachindex(gens(W)))
end

"""
`leftdescents(W,w)`

The  left descents of the element `w` of the Coxeter group `W`, that is the
set of `i` such that `length(W,W(i)*w)<length(W,w)`.

```julia-repl
julia> W=CoxSym(3)
𝔖 ₃

julia> leftdescents(W,Perm(1,3))
2-element Array{Int64,1}:
 1
 2
```
"""
function leftdescents(W::CoxeterGroup,w)
  filter(i->isleftdescent(W,w,i),eachindex(gens(W)))
end

isrightdescent(W::CoxeterGroup,w,i)=isleftdescent(W,inv(w),i)

"""
`word(W::CoxeterGroup,w)`

returns  a reduced word in the standard generators of the Coxeter group `W`
for  the  element  `w`  (represented  as  the  vector  of the corresponding
generator indices).

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> w=perm"(1,11)(3,10)(4,9)(5,7)(6,12)"
(1,11)(3,10)(4,9)(5,7)(6,12)

julia> w in W
true

julia> word(W,w)
5-element Array{Int64,1}:
 1
 2
 3
 2
 1
```
The  result  of   `word`  is  the  lexicographically  smallest reduced word
for~`w` (for the ordering of the Coxeter generators given by `gens(W)`).
"""
function Groups.word(W::CoxeterGroup,w)
  ww=Int[]
  while true
    i=firstleftdescent(W,w)
    if i===nothing return ww end
    push!(ww,i)
    w=W(i)*w
  end
end

"""
`length(W::CoxeterGroup ,w)`

returns the length of a reduced expression in the Coxeter generators of the
element `w` of `W`.

```julia-repl
julia> W=CoxSym(4)
𝔖 ₄

julia> p=W(1,2,3,1,2,3)
Perm{UInt8}: (1,3)(2,4)

julia> length(W,p)
4

julia> word(W,p)
4-element Array{Int64,1}:
 2
 1
 3
 2
```
"""
Base.length(W::CoxeterGroup,w)=length(word(W,w))
Base.eltype(W::CoxeterGroup{T}) where T=T
coxrank(W::CoxeterGroup)=ngens(W)
PermRoot.semisimplerank(W::CoxeterGroup)=coxrank(W)
function nref end

"""
`longest(W)`

If  `W` is  finite, returns  the unique  element of  maximal length  of the
Coxeter group `W`. May loop infinitely otherwise.

```julia-repl
julia> longest(CoxSym(4))
Perm{UInt8}: (1,4)(2,3)
```

`longest(W,I)`

returns  the longest element of the  parabolic subgroup of `W` generated by
the generating reflections of indices in `I`.

```julia-repl
julia> longest(CoxSym(4))
Perm{UInt8}: (1,4)(2,3)
```
"""
function longest(W::CoxeterGroup,I::AbstractVector{<:Integer}=eachindex(gens(W)))
  w=one(W)
  i=1
  while i<=length(I)
    if isleftdescent(W,w,I[i]) i+=1
    else w=W(I[i])*w
      i=1
    end
  end
  w
end

"""
`reduced(W,w)`

The unique element of minimal length in the coset W.w
```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> H=reflection_subgroup(W,[2,6])
G₂₍₂₆₎=Ã₁×A₁

julia> word.(Ref(W),unique(reduced.(Ref(H),elements(W))))
3-element Array{Array{Int64,1},1}:
 []
 [1]
 [1, 2]
```
"""
function PermGroups.reduced(W::CoxeterGroup,w)
  while true
    i=firstleftdescent(W,w)
    if i===nothing return w end
    w=W(i)*w
  end
end

"""
`reduced(H,W,i=nref(W))`

The  elements `w∈ W` which are `H`-reduced  (of minimal length in the coset
`Hw`), and of length `≤i` (by default all of them), grouped by length.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> H=reflection_subgroup(W,[2,6])
G₂₍₂₆₎=Ã₁×A₁

julia> [word(W,w) for S in reduced(H,W) for w in S]
3-element Array{Array{Int64,1},1}:
 []
 [1]
 [1, 2]
```
"""
function PermGroups.reduced(H::CoxeterGroup,W::CoxeterGroup,i::Integer=nref(W))
  res=[[one(W)]]
  while length(res)<=i
    new=reducedfrom(H,W,res[end])
    if isempty(new) break
    else push!(res,new)
    end
  end
  vcat(res)
end

#reduced(H,W,S)
#  The elements in `W` which are `H`-reduced of length `i` given the set `S`
#  of those of length `i-1`
function reducedfrom(H::CoxeterGroup,W::CoxeterGroup,S)
  res=empty(S)
  for w in S
    for i in eachindex(gens(W))
      if !isrightdescent(W,w,i)
        w1=w*W(i)
        if w1==reduced(H,w1) push!(res,w1) end
      end
    end
  end
  unique(res)
end

"""
`elements(W::CoxeterGroup[,l])`

With  one argument this works only if  `W` is finite; the returned elements
are  sorted  by  increasing  Coxeter  length.  If the second argument is an
integer  `l`, the elements  of Coxeter length  `l` are returned.

```julia_repl
julia> W=coxgroup(:G,2)
G₂

julia> e=elements(W,6)
1-element Array{Perm{Int16},1}:
 (1,7)(2,8)(3,9)(4,10)(5,11)(6,12)

julia> e[1]==longest(W)
true
```
"""
function Groups.elements(W::CoxeterGroup{T}, l::Int)::Vector{T} where T
  elts=gets(()->Dict(0=>[one(W)]),W,:elements)#::Dict{Int,Vector{T}}
  if haskey(elts,l) return elts[l] end
  if coxrank(W)==1 return l>1 ? T[] : gens(W) end
  H=gets(()->reflection_subgroup(W,1:coxrank(W)-1),W,:maxpara)#::CoxeterGroup{T}
  rc=gets(()->[[one(W)]],W,:rc)#::Vector{Vector{T}}
  while length(rc)<=l
    new=reducedfrom(H,W,rc[end])
    if isempty(new) break
    else push!(rc,new)
    end
  end
# println("l=$l W=$W H=$H rc=$rc")
  elts[l]=T[]
  for i in max(0,l+1-length(rc)):l
    for x in rc[1+l-i] append!(elts[l],elements(H,i).*Ref(x)) end
  end
# N=nref(W)
# if N!==nothing && N-l>l elts[N-l]=elts[l].*longest(W) end
  elts[l]
end

function Groups.elements(W::CoxeterGroup)
  reduce(vcat,map(i->elements(W,i),0:nref(W)))
end

const Wtype=Vector{Int8}
#CoxeterWords
function Gapjm.words(W::CoxeterGroup{T}, l::Int)where T
 ww=gets(()->Dict(0=>[Wtype([])]),W,:words)::Dict{Int,Vector{Wtype}}
  if haskey(ww,l) return ww[l] end
  if coxrank(W)==1
    if l!=1 return Vector{Int}[]
    else return [[1]]
    end
  end
  H=gets(()->reflection_subgroup(W,1:coxrank(W)-1),W,:maxpara)::CoxeterGroup{T}
  rc=gets(()->[[Wtype([])]],W,:rcwords)::Vector{Vector{Wtype}}
  while length(rc)<=l
    new=reducedfrom(H,W,(x->W(x...)).(rc[end]))
    if isempty(new) break
    else push!(rc,Wtype.(word.(Ref(W),new)))
    end
  end
  ww[l]=Wtype([])
  for i in max(0,l+1-length(rc)):l
    e=words(H,i)
    for x in rc[1+l-i], w in e push!(ww[l],vcat(w,x)) end
#   somewhat slower variant
#   for x in rc[1+l-i] append!(ww[l],vcat.(e,Ref(x))) end
  end
  ww[l]
end

"""
`words(W::CoxeterGroup[,l])`

With  one argument this works only if `W` is finite; it returns the reduced
Coxeter  words  of  elements  of  `W`  by  increasing length. If the second
argument  is an integer `l`, only the  elements of length `l` are returned;
this works for infinite Coxeter groups.

```julia_repl
julia> W=coxgroup(:G,2)
G₂

julia> e=elements(W,6)
1-element Array{Perm{Int16},1}:
 (1,7)(2,8)(3,9)(4,10)(5,11)(6,12)

julia> e[1]==longest(W)
true
```
"""
function Gapjm.words(W::CoxeterGroup)
  reduce(vcat,map(i->words(W,i),0:nref(W)))
end

"""
`bruhatless(W, x, y)`

whether `x≤y` in the Bruhat order, for `x,y∈ W`. We have `x≤y` if a reduced
expression  for `x`  can be  extracted from  one for  `w`). See  [(5.9) and
(5.10) Humphreys1990](biblio.htm#Hum90) for properties of the Bruhat order.

```julia-repl
julia> W=coxgroup(:H,3)
H₃

julia> w=W(1,2,1,3);

julia> b=filter(x->bruhatless(W,x,w),elements(W));

julia> word.(Ref(W),b)
12-element Array{Array{Int64,1},1}:
 []
 [3]
 [2]
 [1]
 [2, 3]
 [1, 3]
 [2, 1]
 [1, 2]
 [2, 1, 3]
 [1, 2, 3]
 [1, 2, 1]
 [1, 2, 1, 3]
```
"""
function bruhatless(W::CoxeterGroup,x,y)
  if x==one(W) return true end
  d=length(W,y)-length(W,x)
  while d>0
    i=firstleftdescent(W,y)
    s=W(i)
    if isleftdescent(W,x,i)
      if x==s return true end
      x=s*x
    else d-=1
    end
    y=s*y
  end
  return x==y
end

"""
`bruhatless(W, y)`

returns  a vector  whose `i`-th  element is  the vector  of elements of `W`
smaller for the Bruhat order than `w` and of Coxeter length `i-1`. Thus the
first  element  of  the  returned  list  contains  only  `one(W)`  and  the
`length(W,w)`-th element contains only `w`.

```julia-repl
julia> W=CoxSym(3)
𝔖 ₃

julia> bruhatless(W,Perm(1,3))
4-element Array{Array{Perm{Int16},1},1}:
 [()]
 [(1,2), (2,3)]
 [(1,2,3), (1,3,2)]
 [(1,3)]
```

see also the method `Poset` for Coxeter groups.
"""
function bruhatless(W::CoxeterGroup,w)
  if w==one(W) return [[w]] end
  i=firstleftdescent(W,w)
  s=W(i)
  res=bruhatless(W,s*w)
  for j in 1:length(res)-1
    res[j+1]=union(res[j+1],s.*filter(x->!isleftdescent(W,x,i),res[j]))
  end
  push!(res,s.*filter(x->!isleftdescent(W,x,i),res[end]))
end

"""
`Poset(W::CoxeterGroup,w=longest(W))`

returns  as a poset the Bruhat interval `[1,w]`of `W`. If `w` is not given,
the whole Bruhat Poset of `W` is returned (`W` must then be finite).

```julia-repl
julia> W=coxgroup(:A,2)
A₂

julia> Poset(W)
<1,2<21,12<121

julia> W=coxgroup(:A,3)
A₃

julia> Poset(W,W(1,3))
<3,1<13
```
"""
function Posets.Poset(W::CoxeterGroup,w=longest(W))
 if w==one(W) return Poset(Dict(:elts=>[w],:labels=>["."],:hasse=>[Int[]],
    :action=>map(x->[0],gens(W)),:size=>1,
    :W=>W))
  end
  s=firstleftdescent(W,w)
  p=Poset(W,W(s)*w)
  l=length(p)
  new=filter(k->iszero(p.prop[:action][s][k]),1:l)
  append!(p.prop[:elts],W(s).*(p.prop[:elts][new]))
  append!(hasse(p),map(x->Int[],new))
  p.prop[:action][s][new]=l.+(1:length(new))
  for i in eachindex(gens(W)) 
    append!(p.prop[:action][i],i==s ? new : zeros(Int,length(new)))
  end
  for i in 1:length(new) push!(hasse(p)[new[i]],l+i) end
  for i in 1:l 
    j=p.prop[:action][s][i]
    if j>i
      for h in p.prop[:action][s][hasse(p)[i]]
        if h>l push!(hasse(p)[j],h)
          k=findfirst(isequal(p.prop[:elts][h]/p.prop[:elts][j]),gens(W))
          if k!==nothing p.prop[:action][k][j]=h;p.prop[:action][k][h]=j end
        end
      end
    end
  end
  p.prop[:size]=length(hasse(p))
  p.prop[:labels]=map(x->joindigits(word(W,x)),p.prop[:elts])
  p
end

"""
`words(W,w)`

returns  the list  of all  reduced expressions  of the  element `w`  of the
Coxeter group `W`.

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> words(W,longest(W))
16-element Array{Array{Int64,1},1}:
 [1, 2, 1, 3, 2, 1]
 [1, 2, 3, 1, 2, 1]
 [1, 2, 3, 2, 1, 2]
 [1, 3, 2, 1, 3, 2]
 [1, 3, 2, 3, 1, 2]
 [2, 1, 2, 3, 2, 1]
 [2, 1, 3, 2, 1, 3]
 [2, 1, 3, 2, 3, 1]
 [2, 3, 1, 2, 1, 3]
 [2, 3, 1, 2, 3, 1]
 [2, 3, 2, 1, 2, 3]
 [3, 1, 2, 1, 3, 2]
 [3, 1, 2, 3, 1, 2]
 [3, 2, 1, 2, 3, 2]
 [3, 2, 1, 3, 2, 3]
 [3, 2, 3, 1, 2, 3]
```
"""
function Gapjm.words(W::CoxeterGroup,w)
  l=leftdescents(W,w)
  if isempty(l) return [Int[]] end
  reduce(vcat,map(x->vcat.(Ref([x]),words(W,W(x)*w)),l))
end

"diagram of finite Coxeter group"
PermRoot.Diagram(W::CoxeterGroup)=Diagram(refltype(W))

function parabolic_category(W,I::AbstractVector{<:Integer})
   Category(collect(sort(I));action=(J,e)->sort(action.(Ref(W),J,e)))do J
    map(setdiff(1:coxrank(W),J)) do i
      longest(W,J)*longest(W,push!(copy(J),i))
    end
  end
end

# all subsets of S which are W-conjugate to I
"""
`standard_parabolic_class(W,I)`
    
`I`  should be a  subset of `eachindex(gens(W))`.  The function returns the
list of such subsets conjugate to the given subset.

```julia-repl
julia> CoxGroups.standard_parabolic_class(coxgroup(:E,8),[7,8])
7-element Array{Array{Int64,1},1}:
 [7, 8]
 [6, 7]
 [5, 6]
 [4, 5]
 [2, 4]
 [3, 4]
 [1, 3]
```
"""
standard_parabolic_class(W,I::Vector{Int})=parabolic_category(W,I).obj

# representatives of parabolic classes
function PermRoot.parabolic_representatives(W::CoxeterGroup,s)
  l=collect(combinations(1:coxrank(W),s))
  orbits=[]
  while !isempty(l)
    o=standard_parabolic_class(W,l[1])
    push!(orbits,o)
    l=setdiff(l,o)
  end
  first.(orbits)
end

"""
coxmat(m::AbstractMatrix)

returns  the  Coxeter  matrix  of  the  Coxeter group defined by the cartan
matrix `m`

```julia-repl
julia> C=cartan(:H,3)
3×3 Array{Cyc{Int64},2}:
       2  ζ₅²+ζ₅³   0
 ζ₅²+ζ₅³        2  -1
       0       -1   2

julia> coxmat(C)
3×3 Array{Int64,2}:
 1  5  2
 5  1  3
 2  3  1
```
"""
function coxmat(m::AbstractMatrix)
  function find(c)
    if c in 0:4 return [2,3,4,6,0][Int(c)+1] end
    x=conductor(c)
    if c==2+E(x)+E(x,-1) return x
    elseif c==2+E(2x)+E(2x,-1) return 2x
    else error("not a Cartan matrix of a Coxeter group")
    end
  end
  res=Int.([i==j for i in axes(m,1), j in axes(m,2)])
  for i in 2:size(m,1), j in 1:i-1
    res[i,j]=res[j,i]=find(m[i,j]*m[j,i])
  end
  res
end

"""
`coxmat(W)`

returns the Coxeter matrix of the Coxeter group `W`, that is the matrix `m`
whose  entry `m[i,j]` contains the order of `W(i)*W(j)` where `W(i)` is the
`i`-th  Coxeter generator of  `W`. An infinite  order is represented by the
entry `0`.

```julia-repl
julia> W=CoxSym(4)
𝔖 ₄

julia> coxmat(W)
3×3 Array{Int64,2}:
 1  3  2
 3  1  3
 2  3  1
```
"""
coxmat(W::CoxeterGroup)=coxmat(cartan(W))

"""
`braid_relations(W)`

this  function returns the  relations which present  the braid group of the
reflection group `W`. These are homogeneous (both sides of the same length)
relations  between generators in bijection  with the generating reflections
of  `W`. A presentation  of `W` is  obtained by adding relations specifying
the order of the generators.

```julia-repl
julia> W=ComplexReflectionGroup(29)
G₂₉

julia> braid_relations(W)
7-element Array{Array{Array{Int64,1},1},1}:
 [[1, 2, 1], [2, 1, 2]]
 [[2, 4, 2], [4, 2, 4]]
 [[3, 4, 3], [4, 3, 4]]
 [[2, 3, 2, 3], [3, 2, 3, 2]]
 [[1, 3], [3, 1]]
 [[1, 4], [4, 1]]
 [[4, 3, 2, 4, 3, 2], [3, 2, 4, 3, 2, 4]]
```

each  relation  is  represented  as  a  pair  of lists, specifying that the
product  of the  generators according  to the  indices on  the left side is
equal  to the product according to the  indices on the right side. See also
`Diagram`.
"""
function braid_relations(t::TypeIrred)
  r=if t.series==:ST getchev(t,:BraidRelations)
  else
    m=coxmat(cartan(t))
    p(i,j)=map(k->iszero(k%2) ? j : i,1:m[i,j])
    vcat(map(i->map(j->[p(i,j),p(j,i)],1:i-1),axes(m,1))...)
  end
  haskey(t,:indices) ? map(x->map(y->t.indices[y],x),r) : r
end

braid_relations(W::Group)=vcat(braid_relations.(refltype(W))...)

#--------------------- CoxSymmetricGroup ---------------------------------
struct CoxSym{T} <: CoxeterGroup{Perm{T}}
  G::PermGroup{T}
  n::Int
  prop::Dict{Symbol,Any}
end

Base.iterate(W::CoxSym,r...)=iterate(W.G,r...)
Base.one(W::CoxSym{T}) where T=one(Perm{T})
Groups.gens(W::CoxSym)=gens(W.G)

"""
  `Coxsym(n)` The symmetric group on `n` letters as a Coxeter group
```julia-repl
julia> W=CoxSym(3)
𝔖 ₃

julia> e=elements(W)
6-element Array{Perm{UInt8},1}:
 ()     
 (2,3)  
 (1,2)  
 (1,2,3)
 (1,3,2)
 (1,3)  

julia> length.(Ref(W),e)
6-element Array{Int64,1}:
 0
 1
 1
 2
 2
 3
```
"""
function CoxSym(n::Int)
  CoxSym{UInt8}(Group([Perm{UInt8}(i,i+1) for i in 1:n-1]),n,Dict{Symbol,Any}())
end

function Base.show(io::IO, W::CoxSym)
  if get(io,:TeX,false) || get(io,:limit,false)
    printTeX(io,"\\frakS _{$(W.n)}")
  else print(io,"CoxSym($(W.n))")
  end
end

PermRoot.refltype(W::CoxSym)=[TypeIrred(Dict(:series=>:A,
                                        :indices=>collect(1:W.n-1)))]

# the following two methods shoud be derived from a trait "HasType" of CoxSym 
Groups.conjugacy_classes(W::CoxSym)=gets(()->map(x->orbit(W,x),classreps(W)),
                                      W,:classes)

Groups.classreps(W::CoxSym)=gets(()->map(x->W(x...),classinfo(W)[:classtext]),
                                      W,:classreps)

Perms.reflength(W::CoxSym,a)=reflength(a)

nref(W::CoxSym)=div(W.n*(W.n-1),2)
PermRoot.rank(W::CoxSym)=W.n-1

"""
`isleftdescent(W,w,i)`

returns  `true`  if  and  only  if  the `i`-th generating reflection of the
Coxeter  group `W` is  in the left  descent set of  the element `w` of `W`,
that is iff `length(W,W(i)*w)<length(W,w)`.

```julia-repl
julia> W=CoxSym(3)
𝔖 ₃

julia> isleftdescent(W,Perm(1,2),1)
true
```
"""
isleftdescent(W::CoxSym,w,i::Int)=i^w>(i+1)^w

Gapjm.degrees(W::CoxSym)=2:ngens(W)+1

Base.length(W::CoxSym)=prod(degrees(W))

Base.length(W::CoxSym,w)=count(i^w>(i+k)^w for k in 1:W.n-1 for i in 1:W.n-k)

PermRoot.cartan(W::CoxSym)=cartan(:A,W.n-1)

# for reflection_subgroups note the difference with Chevie:
# leftdescents, rightdescents, classinfo.classtext, word
# use indices in W and not in parent(W)
"""
`reflection_subgroup(W::CoxSym,I)`

Only parabolics defined are `I=1:m` for `m≤n`
"""
function PermRoot.reflection_subgroup(W::CoxSym,I::AbstractVector{Int})
  if length(I)>0 n=maximum(I)
    if I!=1:n error(I," should be 1:n for some n") end
  else n=0 end
  CoxSym(Group(gens(W)[I]),n+1,Dict{Symbol,Any}())
end

PermRoot.simple_representatives(W::CoxSym)=fill(1,nref(W))

function PermRoot.reflection(W::CoxSym{T},i::Int)where T
  ref=gets(W,:reflections)do
    [Perm{T}(i,i+k) for k in 1:W.n-1 for i in 1:W.n-k]
  end::Vector{Perm{T}}
  ref[i]
end

PermRoot.reflections(W::CoxSym)=reflection.(Ref(W),1:nref(W))
#------------------------ GenCox ------------------------------

struct GenCox{T}<:CoxeterGroup{Matrix{T}}
  gens::Vector{Matrix{T}}
  prop::Dict{Symbol,Any}
end

Groups.gens(W::GenCox)=W.gens
Base.one(W::GenCox)=one(W(1))

isleftdescent(W::GenCox,w,i::Int)=real(sum(w[i,:]))<0
  
"""
`GenCox(m)`

`m`  should be a square  matrix of real cyclotomic  numbers. It returns the
Coxeter  group  whose  Cartan  matrix  is  `m`.  This  is  a  matrix  group
constructed  as  follows.  Let  `V`  be  a  real  vector space of dimension
`size(m,1)`,  and  let  `⟨,⟩`  be  the  bilinear  form defined by `⟨eᵢ,eⱼ⟩=
m[i,j]`  where `eᵢ` is the  canonical basis of `V`.  Then the result is the
matrix group generated by the reflections `sᵢ(x)=x-2⟨x,eᵢ⟩eᵢ`.

```julia-repl
julia> W=CoxGroups.GenCox([2 -2;-2 2])
GenCox{Int64}([[-1 0; 2 1], [1 2; 0 -1]], Dict{Symbol,Any}())
```

Above is a way to construct the affine Weyl group  ` ̃A₁`.
"""
function GenCox(C::Matrix{T})where T
  I=one(C)
  GenCox(reflection.(eachrow(I),eachrow(C)),Dict{Symbol,Any}())
end

function PermRoot.reflection_subgroup(W::GenCox,I::AbstractVector{Int})
  if length(I)>0 n=maximum(I)
    if I!=1:n error(I," should be 1:n for some n") end
  else n=0 end
  GenCox(gens(W)[I],Dict{Symbol,Any}())
end

end
