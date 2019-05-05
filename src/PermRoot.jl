"""
Dictionary
ReflectionSubgroup -> reflection_subgroup
.orbitRepresentatives -> simple_representatives
.                     -> simple_conjugating_element
Reflections -> reflections
ReflectionType -> refltype
IndependentRoots -> independent_roots
HyperplaneOrbits -> hyperplane_orbits
ReflectionEigenvalues -> refleigen
ReflectionCharacter -> reflchar
PositionClass -> position_class
ReflectionLength->reflength
"""
module PermRoot

export AbstractPermRootGroup, PermRootGroup, PermRootSubGroup, 
 reflection_subgroup, simple_representatives, simple_conjugating_element, 
 reflections, reflection, Diagram, refltype, cartan, independent_roots, 
 inclusion, restriction, coroot, hyperplane_orbits, TypeIrred, refleigen,
 position_class, reflength, bipartite_decomposition

using Gapjm

# coroot for an orthogonal reflection and integral root
function coroot(root::Vector,eigen::Int=-1)
  d=sum(root.* conj.(root))
  coroot=conj.(root)
  if mod(2,d)!=0 return 2*coroot//d 
  else return coroot*div(2,d)
  end
end

# coroot for an orthogonal reflection
function coroot(root::Vector,eigen::Cyc)
  return ((1-eigen)*conj.(root))//sum(root.* conj.(root))
end

struct TypeIrred
  prop::Dict{Symbol,Any}
end

struct Diagram
  types::Vector{TypeIrred}
end

function Base.show(io::IO,d::Diagram)
  for t in d.types
    series=t[:series]::Symbol
    indices=t[:indices]::Vector{Int}
    ind=repr.(indices)
    l=length.(ind)
    bar(n)="\u2014"^n
    rdarrow(n)="\u21D0"^(n-1)*" "
    ldarrow(n)="\u21D2"^(n-1)*" "
    tarrow(n)="\u21DB"^(n-1)*" "
    vbar="\UFFE8" # "\u2503"
    node="O"
    if series==:A
      println(io,join(map(l->node*bar(l),l[1:end-1])),node)
      print(io,join(ind," "))
    elseif series==:B
      println(io,node,rdarrow(max(l[1],2)),join(map(l->node*bar(l),l[2:end-1])),
        node)
      print(io,ind[1]," "^max(3-l[1],1),join(ind[2:end]," "))
    elseif series==:C
      println(io,node,ldarrow(max(l[1],2)),join(map(l->node*bar(l),l[2:end-1])),
        node)
      print(io,ind[1]," "^max(3-l[1],1),join(ind[2:end]," "))
    elseif series==:D
      println(io," "^l[1]," O $(ind[2])\n"," "^l[1]," ",vbar)
      println(io,node,bar(l[1]),map(l->node*bar(l),l[3:end-1])...,node)
      print(io,ind[1]," ",join(ind[3:end]," "))
    elseif series==:E
      dec=2+l[1]+l[3]
      println(io," "^dec,"O $(ind[2])\n"," "^dec,vbar)
      println(io,node,bar(l[1]),node,bar(l[3]),
                join(map(l->node*bar(l),l[4:end-1])),node)
      print(io,join(ind[[1;3:end]]," "))
    elseif series==:F
      println(io,node,bar(l[1]),node,ldarrow(max(l[2],2)),node,bar(l[3]),node)
      print(io,ind[1]," ",ind[2]," "^max(3-l[2],1),ind[3]," ",ind[4])
    elseif series==:G
      println(io,node,tarrow(max(l[1],2)),node)
      print(io,ind[1]," "^max(3-l[1],1),ind[2])
    end
  end
end

#---------------------------------------------------------------------------
abstract type AbstractPermRootGroup{T,T1<:Integer}<:Group{Perm{T1}} end 

Diagram(W::AbstractPermRootGroup)=Diagram(refltype(W))
Gapjm.gens(W::AbstractPermRootGroup)=gens(W.G)
Gapjm.degree(W::AbstractPermRootGroup)=degree(W.G)
Base.length(W::AbstractPermRootGroup)=length(W.G)
Base.iterate(W::AbstractPermRootGroup,x...)=iterate(W.G,x...)
Base.eltype(W::AbstractPermRootGroup)=eltype(W.G)

"for each root index of simple representative"
function simple_representatives(W::AbstractPermRootGroup{T,T1})::Vector{T1} where {T,T1}
  getp(root_representatives,W,:rootreps)
end
  
"for each root element conjugative representative to root"
function simple_conjugating_element(W::AbstractPermRootGroup{T,T1},i)::Perm{T1} where{T,T1}
  getp(simple_conjugating_element,W.G,:repelms)[i]
end

function reflections(W::AbstractPermRootGroup{T,T1})::Vector{Perm{T1}} where{T,T1}
  getp(root_representatives,W,:reflections)
end

reflection(W::AbstractPermRootGroup,i)=reflections(W)[i]

function reflength(W::AbstractPermRootGroup,w::Perm)
  l=getp(refleigen,W,:reflengths)::Vector{Int}
  l[position_class(W,w)]
end

function cartan(W::AbstractPermRootGroup{T,T1})::Matrix{T} where {T,T1}
  gets(W,:cartan)do W
  [cartan_coeff(W,i,j) for i in eachindex(gens(W)), j in eachindex(gens(W))]
  end
end

"""
Let W be an irreducible CRG of rank r, generated by known distinguished
reflections. type_irred classifies W (returns a type record) using:
 r=rank
 s=Size(W)/Factorial(r)
 o=the maximum order of a reflection
 h=the Coxeter number=Sum(Degrees(W)+CoDegrees(W))/r=Sum_{s∈ D} o(s)
    where D is the set of distinguished reflections of W.

G(de,e,r) has s=(de)^r/e, o=max(2,d), h=ed(r-1)+d-δ_{d,1}

(r,s,o)  are  sufficient  to  determine  a G(de,e,r) excepted for ambiguity
G(2e,e,2)/G(4e,4e,2),  which is resolved  by h (excepted  for e=1, when the
two solutions are isomorphic.

The ambiguities on (r,s,o) involving primitive groups are:  
 G9/G(24,6,2)
 G12/G(12,6,2)/G(24,24,2)
 G13/G(24,12,2)/G(48,48,2)
 G22/G(60,30,2)/G(120,120,2)
 G7/G14/G(24,8,2)
 G8/G(12,3,2) 
 G15/G(48,16,2)
 G17/G(120,24,2)
 G21/G(120,40,2)
They are resolved by h.
"""
function type_irred(W::AbstractPermRootGroup)
prim = [
  (ST=4, r=2, s=12, o=3, h=6), 
  (ST=5, r=2, s=36, o=3, h=12), 
  (ST=6, r=2, s=24, o=3, h=12), 
  (ST=7, r=2, s=72, o=3, h=18), 
  (ST=8, r=2, s=48, o=4, h=12), 
  (ST=9, r=2, s=96, o=4, h=24), 
  (ST=10, r=2, s=144, o=4, h=24), 
  (ST=11, r=2, s=288, o=4, h=36), 
  (ST=12, r=2, s=24, o=2, h=12), 
  (ST=13, r=2, s=48, o=2, h=18), 
  (ST=14, r=2, s=72, o=3, h=24), 
  (ST=15, r=2, s=144, o=3, h=30), 
  (ST=16, r=2, s=300, o=5, h=30), 
  (ST=17, r=2, s=600, o=5, h=60), 
  (ST=18, r=2, s=900, o=5, h=60), 
  (ST=19, r=2, s=1800, o=5, h=90), 
  (ST=20, r=2, s=180, o=3, h=30), 
  (ST=21, r=2, s=360, o=3, h=60), 
  (ST=22, r=2, s=120, o=2, h=30), 
  (series="H", r=3, s=20, o=2, h=10), 
  (ST=24, r=3, s=56, o=2, h=14), 
  (ST=25, r=3, s=108, o=3, h=12), 
  (ST=26, r=3, s=216, o=3, h=18), 
  (ST=27, r=3, s=360, o=2, h=30), 
  (series="F", r=4, s=48, o=2, h=12), 
  (ST=29, r=4, s=320, o=2, h=20), 
  (series="H", r=4, s=600, o=2, h=30), 
  (ST=31, r=4, s=1920, o=2, h=30), 
  (ST=32, r=4, s=6480, o=3, h=30), 
  (ST=33, r=5, s=432, o=2, h=18), 
  (ST=34, r=6, s=54432, o=2, h=42), 
  (series="E", r=6, s=72, o=2, h=12), 
  (series="E", r=7, s=576, o=2, h=18), 
  (series="E", r=8, s=17280, o=2, h=30)]

  r=length(independent_roots(W)) # rank of W
  s=div(length(W),factorial(r))
  if s==r+1 return Dict(:series => :A, :rank => r)
  elseif r==1 return Dict(:series=>:ST,:p=>s,:q=>1,:rank=>1)
  else l=([p.^(a+m-a*r,a*r-m) for a in div(m+r-1,r):div(m,r-1)]
                       for (p,m) in factor(s))
    de=vec((x->(d=prod(first.(x)),e=prod(last.(x)))).(Iterators.product(l...)))
  end
  o = maximum(order.(gens(W)))
# println("de=$de, o=$o, h=$h")
  de = filter(x->o==max(2,x.d),de)
  ST = filter(f->r==f.r && s==f.s && o==f.o,prim)
  h=div(sum(order,Set(reflections(W))),r) # Coxeter number
  if length(de)>1
    if length(de)!=2 error("theory") end
    de=sort(de)
    if h==de[1].e de=[de[1]]
    elseif h==2*de[2].e+2 de = [de[2]]
    elseif length(ST) != 1 || h != ST[1].h error("theory")
    else return Dict(:series=>:ST, :ST=>ST[1].ST, :rank=> r)
    end
  end
  if length(de) > 0 && length(ST) > 0
    ST = filter(i->i.h==h,ST)
    if length(ST) > 1 error("theory")
    elseif length(ST) > 0
      if h == de[1].d*((r-1)*de[1].e+1) error("theory") end
      return Dict(:series => :ST, :ST =>ST[1].ST, :rank=>r)
    end
  end
  if length(de) == 0
    if length(ST) != 1 error("theory")
    elseif haskey(ST[1], :ST)
         return Dict(:series=>:ST, :ST =>ST[1].ST, :rank => r)
    else return Dict(:series=>ST[1].series, :rank => r)
    end
  end
  de = de[1]
  if de.d == 2 && de.e == 1 return Dict(:series=>:B, :rank=>r) end
  if de.d == 1
      if de.e == 2 return Dict(:series=>:D,:rank=>r)
      elseif r == 2
        if de.e == 4 return Dict(:series=>:B, :rank=>2)
        elseif de.e == 6 return Dict(:series=>:G, :rank=>2)
        else return Dict(:series=>:I, :rank=>2, :bond=>de[:e])
        end
      end
  end
  return Dict(:series=>:ST, :p=>de.d * de.e, :q=>de.e, :rank=>r)
end

function refltype(W::AbstractPermRootGroup)
  gets(W,:refltype)do W
    map(blocks(cartan(W))) do I
      d=type_irred(reflection_subgroup(W,I))
      d[:indices]=I
      TypeIrred(d)
    end
  end
end

Base.haskey(t::TypeIrred,k)=haskey(t.prop,k)
Base.getindex(t::TypeIrred,k)=t.prop[k]
indices(t::TypeIrred)=t[:indices]
series(t::TypeIrred)=t[:series]

function Base.show(io::IO, t::TypeIrred)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  s=series(t)
  if s==:ST 
    if haskey(t,:ST) 
      n=repl||TeX ? "G_{$(t[:ST])}" : "ComplexReflectionGroup($(t[:ST]))"
    else 
      n=repl||TeX ? "G_{$(t[:p]),$(t[:q]),$(t[:rank])}" : 
        "ComplexReflectionGroup($(t[:p]),$(t[:q]),$(t[:rank]))"
    end
  else 
    r=length(indices(t))
    if s==:B && haskey(t,:cartantype) && t[:cartantype]==1 
      s=:C
    end
    if haskey(t,:bond)
      b=t[:bond]
      n=repl||TeX ? "W($(s)_{$r}($b))" : "coxgroup(:$s,$r,$b)"
    else
      n=repl||TeX ? "W($(s)_{$r})" : "coxgroup(:$s,$r)"
    end
  end
  if repl n=TeXstrip(n) end
  print(io,n)
end

function hyperplane_orbits(W::AbstractPermRootGroup)
  orb=collect(Set(simple_representatives(W)))
  class=map(orb)do s
   findfirst(x->length(x)==1 && simple_representatives(W)[x[1]]==s,
             classinfo(W)[:classtext])
  end
  chars=chartable(W).irr
  map(zip(orb,class)) do (s,c)
    ord=order(W(s))
 #  classno=map(j->position_class(W,W(s)^j),1:ord-1)
    Ns=classinfo(W)[:classes][c]
    dets=map(1:ord-1) do j
      findfirst(i->chars[i,1]==1 && chars[i,c]==E(ord,j),axes(chars,1))
    end
    (s=s,cl_s=[c],order=ord,N_s=Ns,det_s=dets)
  end
end
  
"bipartite decomposition of eachindex(gens(W))"
function bipartite_decomposition(W)
  L=Int[]
  R=Int[]
  rest=collect(eachindex(gens(W)))
  function comm(x,y)
    p=gens(W)[x]
    q=gens(W)[y]
    return p*q==q*p
  end
  while length(rest)>0
    r=findfirst(x->any(y->!comm(x,y),L),rest)
    if r!=nothing 
      if any(y->!comm(rest[r],y),R) 
        error(W," has no bipartite decomposition")
      end
      push!(R,rest[r])
      deleteat!(rest,r)
    else r=findfirst(x->any(y->!comm(x,y),R),rest)
      if r!=nothing push!(L,rest[r]); deleteat!(rest,r)
      else push!(L,rest[1]); deleteat!(rest,1);
      end
    end
  end
  return L,R
end

#--------------------------------------------------------------------------
struct PermRootGroup{T,T1}<:AbstractPermRootGroup{T,T1}
  matgens::Vector{Matrix{T}}
  roots::Vector{Vector{T}}
  coroots::Vector{Vector{T}}
  G::PermGroup{T1}
  prop::Dict{Symbol,Any}
end

(W::PermRootGroup)(x...)=element(W.G,x...)
function PermRootGroup(r::Vector{Vector{T}},cr::Vector{Vector{T1}}) where{T,T1}
  matgens=map(reflection,r,cr)

  # the following section is quite subtle: it has the (essential -- this is
  # what  allows  to  construct  reflexion  subgroups  in a consistent way)
  # property  that the order of the  constructed roots (thus the generating
  # permutations) depends only on the Cartan matrix of g, not on the actual
  # root values.

# println("# roots: ")
  roots=map(x->convert.(eltype(matgens[1]),x),r)
  cr=map(x->convert.(eltype(matgens[1]),x),cr)
  refls=map(x->Int[],roots)
  newroots=true
  while newroots
    newroots=false
    for j in eachindex(matgens)
      lr=length(roots)
      for y in Ref(permutedims(matgens[j])).*roots[length(refls[j])+1:end]
        p=findfirst(isequal(y),roots[1:lr]) 
	if isnothing(p)
          push!(roots,y)
#         println("j=$j roots[$(length(refls[j])+1)...] ",length(roots),":",y)
          newroots=true
          push!(refls[j],length(roots))
        else push!(refls[j],p)
	end
      end
    end
#   println(" ",length(roots))
  end
# roots=map(x->convert.(eltype(matgens[1]),x),roots)
  PermRootGroup(matgens,roots,cr,PermGroup(map(Perm{Int16},refls)),
    Dict{Symbol,Any}())
end

function root_representatives(W::PermRootGroup)
  reps=fill(0,length(W.roots))
  repelts=fill(one(W),length(W.roots))
  for i in eachindex(gens(W))
    if iszero(reps[i])
      d=orbit_and_representative(W,i)
      for (n,e) in d 
        reps[n]=i
        repelts[n]=e
      end
    end
  end
  W.prop[:rootreps]=reps
  W.prop[:repelms]=repelts
  W.prop[:reflections]=map((i,p)->gens(W)[i]^p,reps,repelts)
end

" the matrix of the reflection of given root and coroot"
function reflection(root::AbstractVector,coroot::AbstractVector)
  root,coroot=promote(root,coroot)
  m=[i*j for i in coroot, j in root]
  one(m)-m
end

function independent_roots(W::PermRootGroup)::Vector{Int}
  gets(W,:indeproots) do W
    echelon(permutedims(hcat(W.roots...)))[2]
  end
end

function baseX(W::PermRootGroup{T})::Matrix{T} where T
  gets(W,:baseX) do W
    ir=independent_roots(W)
    res=permutedims(hcat(W.roots[ir]...))
    res=hcat(res,Util.nullspace(hcat(W.coroots[ir]...)))
  end
end

" as Chevie's MatXPerm"
function matX(W::PermRootGroup,w)
  X=baseX(W)
  ir=independent_roots(W)
  Xinv=Int.(inv(Rational.(X)))
  Xinv*vcat(permutedims(hcat(W.roots[ir.^w]...)),X[length(ir)+1:end,:]);
end

tr(m)=sum(i->m[i,i],axes(m,1))
reflchar(W::AbstractPermRootGroup,w)=tr(matX(W,w))
reflchar(W::AbstractPermRootGroup)=map(x->reflchar(W,W(x...)),classinfo(W)[:classtext])
  
function refleigen(W::AbstractPermRootGroup)::Vector{Vector{Rational{Int}}}
  gets(W,:refleigen) do W
    t=chartable(W).irr[charinfo(W)[:extRefl],:]
    v=map(i->Pol([-1],1)^i,size(t,1)-1:-1:0)
    l=CycPol.((permutedims(v)*t)[1,:])
    ll=map(c->vcat(map(p->fill(p[1].r,p[2]),c.v)...),l)
    W.prop[:reflengths]=map(x->count(y->!iszero(y),x),ll)
    ll
  end
end

function classinv(W::AbstractPermRootGroup)
  gets(W,:classinv)do W
    map(x->cycletype(W(x...),domain=simple_representatives(W)),
         classinfo(W)[:classtext])
  end
end

function position_class(W::AbstractPermRootGroup,w)
  i=cycletype(w,domain=simple_representatives(W))
  l=findall(isequal(i),classinv(W))
  if length(l)>1 error("ambiguity") end
  l
end

function Base.show(io::IO, W::AbstractPermRootGroup)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if isempty(refltype(W)) print(io,repl||TeX ? "W()" : coxgroup()) end
  n=join(map(refltype(W))do t
    n=sprint(show,t; context=io)
    inds=indices(t)
    if inds!=eachindex(inds)
      ind=any(i->i>10,inds) ? join(inds,",") : join(inds)
      n*="_{($ind)}"
    end
    n
  end,repl||TeX ? "\\times " : "*")
  if repl n=TeXstrip(n) end
  print(io,n)
end

function cartan_coeff(W::PermRootGroup,i,j)
  v=findfirst(x->!iszero(x),W.roots[i])
  r=W.roots[j]-W.roots[j^reflection(W,i)]
  return r[v]/W.roots[i][v];
end

#--------------------------------------------------------------------------
struct PermRootSubGroup{T,T1}<:AbstractPermRootGroup{T,T1}
  G::PermGroup{T1}
  inclusion::Vector{Int}
  restriction::Vector{Int}
  parent::PermRootGroup{T,T1}
  prop::Dict{Symbol,Any}
end

(W::PermRootSubGroup)(x...)=element(W.G,x...)
inclusion(W::PermRootSubGroup)=W.inclusion
restriction(W::PermRootSubGroup)=W.restriction

function reflection_subgroup(W::PermRootGroup,I::AbstractVector{Int})
  G=PermRootGroup(W.roots[I],W.coroots[I])
  inclusion=map(x->findfirst(isequal(x),W.roots),G.roots)
  restriction=zeros(Int,length(W.roots))
  restriction[inclusion]=1:length(inclusion)
  G=PermGroup(reflections(W)[I])
  PermRootSubGroup(G,inclusion,restriction,W,Dict{Symbol,Any}())
end

cartan_coeff(W::PermRootSubGroup,i,j)=
   cartan_coeff(W.parent,W.inclusion[i],W.inclusion[j])

reflection_subgroup(W::PermRootSubGroup,I::AbstractVector{Int})=
  reflection_subgroup(W.parent,W.inclusion[I])

function root_representatives(W::PermRootSubGroup)
  reps=fill(0,length(W.inclusion))
  repelts=fill(one(W),length(W.inclusion))
  for i in eachindex(gens(W))
    if iszero(reps[i])
      d=orbit_and_representative(W.G,W.inclusion[i])
      for (n,e) in d 
        reps[W.restriction[n]]=i
        repelts[W.restriction[n]]=e
      end
    end
  end
  W.prop[:rootreps]=reps
  W.prop[:repelms]=repelts
  W.prop[:reflections]=map((i,p)->gens(W)[i]^p,reps,repelts)
end

function independent_roots(W::PermRootSubGroup)::Vector{Int}
  gets(W,:indeproots) do W
    echelon(permutedims(hcat(W.parent.roots[W.inclusion]...)))[2]
  end
end
end
