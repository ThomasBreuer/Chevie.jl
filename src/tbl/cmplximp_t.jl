# Hand-translated part of chevie/tbl/cmplximp.g 
# (C) 1998 - 2011  Gunter Malle and  Jean Michel
# data about imprimitive complex reflection groups

chevieset(:imp, :EigenvaluesGeneratingReflections, function (p, q, r)
  res=fill(1//2,r)
  if q == 1
    res[1]=1//p
    res
  elseif q!=p pushfirst!(res,q//p)
  else res
  end
end)

chevieset(:imp,:PowerMaps,function(p,q,r)
  if q!=1
    InfoChevie("# power maps not implemented for G($p,$q,$r)\n")
    return [[1],[1],[1]]
  end
  function pow(p,n)
    e=length(p)
    rr=map(x->[],1:e)
    for k in 1:e
      for l in p[k]
        g=gcd(n,l)
        for j in 1:g push!(rr[1+mod(div(n*(k-1),g),e)], div(l,g)) end
      end
    end
    for k in 1:e rr[k]=sort(rr[k],rev=true) end
    return rr
  end
  pp = chevieget(:imp, :ClassInfo)(p,q,r)[:classparams]
  l=keys(factor(factorial(r)*p))
  res=fill(Int[],maximum(l))
  for pw in l res[pw]=map(x->findfirst(==(pow(x,pw)),pp),pp) end
  res
end)

chevieset(:imp,:GeneratingRoots,function(p,q,r)
  if q==1 
    roots=[vcat([1],fill(0,r-1))]
  else
    if q!=p roots=[vcat([Cyc(1)],fill(0,r-1))] end
    v=vcat([-E(p),1],fill(0,r-2))
    if r==2 && q>1 && q%2==1 v*=E(p) end
    if q==p roots=[v] else push!(roots, v) end
  end
  append!(roots,map(i->vcat(fill(0,i-2),[-1;1],fill(0,r-i)),2:r))
end)

# see page 172 of Halverson and Ram,
# Murnaghan-Nakayama rules for characters of Iwahori-Hecke algebras of the 
# complex reflection groups G(r,p,n) Canad. J. Math. 50 (1998) 167--192
struct Hook
  area::Int       # area of the hook
  startpos::Int   # the position of the decreased βnumber in the βlist
  endpos::Int     # the position it will occupy after being decreased
  DC::Vector{Int} # axial positions of dull corners
  SC::Vector{Int} # axial positions of sharp corners
end

function Base.show(io::IO,h::Hook)
  print(io,"<",h.startpos,"=>",h.endpos,",area:",h.area,",DC=",h.DC,",SC=",h.SC,">")
end

"""
hooksβ(S,s)  the list of all hooks  of area less than or  equal to s in the
Young diagram of the partition with βlist S.
"""
function hooksβ(S,s)
  res=Hook[]
  e=length(S)
  if e==0 return res end
  j=e
  for i in S[e]-1:-1:0
    while j>0 && S[j]>i j-=1 end
    if j>0 && S[j]==i continue end
    for k in j+1:e
      if S[k]>i+s break end
      z=pushfirst!(S[j+1:k-1],i)
      zi=filter(i->z[i]-z[i-1]>1,2:length(z))
      push!(res,Hook(S[k]-i,k,j+1,view(z,zi).-e,
                 view(z,push!(zi.-1,length(z))).+(1-e)))
    end
  end
  res
end

"""
stripsβ(S,s)  returns as a list of lists  of Hooks all broken border strips
(union  of disjoint  hooks) of  area less  than or  equal to s in the Young
diagram of the partition with βlist S.
"""
function stripsβ(S,s)
  res=[Hook[]]
  for hook in hooksβ(S,s)
    if s==hook.area push!(res,[hook])
    else
      j=hook.endpos-1-length(S)
      for hs in stripsβ(S[1:hook.endpos-1], s-hook.area)
        for h in hs
          h.SC.+=j
          h.DC.+=j
        end
        push!(hs, hook)
        push!(res, hs)
      end
    end
  end
  res
end

"the elementary symmetric function of degree t in the variables v"
function elementary_symmetric_function(t,v)
  if t==0 return 1 end
  sum(x->isempty(x) ? 1 : prod(v[x]),combinations(1:length(v),t);init=0)
end

"the homogeneous symmetric function of degree t in the variables v"
function homogeneous_symmetric_function(t,v)
  if t==0 return 1 end
  sum(x->prod(v[x]),combinations(repeat(1:length(v),t), t);init=0)
end

chevieset(:imp, :HeckeCharTable, function (p, q, r, para, rootpara)
  res=Dict{Symbol, Any}(:name=>string("H(G(", p, ",", q, ",", r, "))"),
  :degrees=> chevieget(:imp, :ReflectionDegrees)(p, q, r), :dim=>r)
  res[:identifier] = res[:name]
  res[:size] = prod(res[:degrees])
  res[:order] = res[:size]
  res[:powermap]=chevieget(:imp,:PowerMaps)(p,q,r)
  cl=chevieget(:imp, :ClassInfo)(p, q, r)
  if r==1
    res[:classes]=cl[:classes]
    res[:orders]=cl[:orders]
    res[:irreducibles]=map(i->map(j->para[1][i]^j,0:p-1),1:p)
  elseif q==1
# character table of the Hecke algebra of G(p,1,r) parameters v and [q,-1]
# according to [Halverson-Ram]
    merge!(res,cl)
    T=NamedTuple{(:area,:cc,:hooklength,:DC,:SC,:stripped),
       Tuple{Int,Int,Int,Vector{Pair{Int,Int}},Vector{Pair{Int,Int}},
       Vector{Vector{Int}}}}
    StripsCache=Dict{Pair{Vector{Vector{Int}},Int},Any}()
"""
Strips(S,s)  returns the list  of collections of  broken border strips of
total  area equal to  s coming from  the various βlists  in the symbol S.
Each  collection is represented by named tuple containing the statistical
information   about  it  necessary  to  compute  the  function  Delta  in
[Halverson-Ram] 2.17. These tuples have the following fields:
   area       total area
   cc         number of connected components (hooks)
   hooklength Sum of hooklengths of individual hooks (the # of rows -1 of the
                  hook, equal to startpos-endpos)
   DC         the list of all dull corners, represented by a pair:
                which βlist they come from, axial position
   SC         the list of all sharp corners, represented by a pair:
                which βlist they come from, axial position
   stripped   the symbol left after removing the strip collection
"""
    function Strips(S,s)local e, res, hs, ss, a
      get!(StripsCache,S=>s) do
      function strip(S,hs) # strip hooks hs from βlist S
        S=copy(S)
        for h in hs 
          beta=S[h.startpos]
          for i in h.startpos:-1:h.endpos+1 S[i]=S[i-1] end
          S[h.endpos]=beta-h.area
        end
        i=1
        while i<=length(S) && iszero(S[i]) i+=1 end
        if i>1 S=S[i:end].-(i-1) end
        return S
      end 
      e=length(S)
      if e==0
        if s==0 return [(area=0,cc=0,hooklength=0,DC=Pair{Int,Int}[],
                         SC=Pair{Int,Int}[],stripped=Vector{Int}[])]
        else return T[]
        end
      end
      res=T[]
      for h in stripsβ(S[e], s)
        hs=(area=reduce(+,map(x->x.area,h),init=0), 
          cc=length(h),
          hooklength=reduce(+,map(x->x.startpos-x.endpos,h),init=0),
          DC=[e=>y for x in h for y in x.DC],
          SC=[e=>y for x in h for y in x.SC],
          stripped=[strip(S[e],h)])
        for a in Strips(S[1:e-1],s-hs.area)
          push!(res,(area=a.area+hs.area,cc=a.cc+hs.cc,
            hooklength=a.hooklength+hs.hooklength,
            DC=vcat(a.DC,hs.DC), SC=vcat(a.SC,hs.SC),
            stripped=vcat(a.stripped,hs.stripped)))
        end
      end
      res
      end
    end
# the function Delta of Halverson-Ram 2.17, modified to take in account that
# our eigenvalues for T_2..T_r are (Q1,Q2) instead of (q,-q^-1)
    function Delta(k,hs,(Q1,Q2),v)local q
      delta=1
      if hs.cc>1
        if k==1 || iszero(Q1+Q2) return 0
        else delta*=(Q1+Q2)^(hs.cc-1)
        end
      end
      q=-Q1//Q2//1
      delta*=Q1^(hs.area-hs.cc)*(-q)^-hs.hooklength
      if k==0 return delta end
      ctSC=[v[x]*q^y for (x,y) in hs.SC]
      ctDC=[v[x]*q^y for (x,y) in hs.DC]
      delta*=reduce(*,ctSC;init=1)//reduce(*,ctDC;init=1)
      if k==1 return delta end
      delta*(-1)^(hs.cc-1)*sum(map(
          t->(-1)^t*elementary_symmetric_function(t,ctDC)* 
                    homogeneous_symmetric_function(k-t-hs.cc,ctSC), 
               0:min(length(ctDC),k-hs.cc));init=0)
    end
    chiCache=Dict{Pair{Vector{Vector{Int}},Vector{Vector{Int}}}, Any}()
    function entry(lambda,mu)
      get!(chiCache,lambda=>mu) do
        n=sum(sum,lambda)
        if iszero(n) return 1 end
        bp=maximum(x for S in lambda for x in S)
        i=findfirst(x->bp in x,lambda)
        # choice of bp and i corresponds to choice (Sort) in classtext
        strips=Strips(mu, bp)
        if isempty(strips) return 0 end
        rest=copy(lambda)
        rest[i]=rest[i][2:end]
        f1=(-prod(para[2]))^((i-1)*(n-bp))
        f2=sum(strips) do x
          d=Delta(i-1,x,para[2],para[1])
          iszero(d) ? d : d*entry(rest, x.stripped)
        end
        f1*f2
      end
    end
    res[:irreducibles]=map(x->map(y->entry(y,x),partition_tuples(r,p)),
                           map(x->βset.(x),partition_tuples(r,p)))
  elseif r==2 && p!=q && iseven(q)
    res[:classes]=cl[:classes]
    res[:orders]=cl[:orders]
    Z,X,Y=para
    e1=div(q,2)
    Z=root.(Z,e1)
    Z=vcat(map(i->Z.*E(e1,i),0:e1-1)...)
    ci=chevieget(:imp, :CharInfo)(p, q, r)
    function entry2(char, class)
      char=ci[:malle][findfirst(==(char),ci[:charparams])]
      if char[1] == 1
        w=[Z[char[4]],X[char[2]],Y[char[3]]]
        return prod(i->iszero(i) ? prod(w) : w[i],class;init=1)
      else
        w=char[2]*root(X[1]*X[2]*Y[1]*Y[2]*Z[char[3]]*Z[char[4]]*
          E(div(p,2),2-char[3]-char[4]))*E(p,char[3]+char[4]-2)
        class=map(i->count(==(i),class), 0:3)
        if class[2]>0 char=sum(x->x^class[2],Z[char[[3,4]]])
        elseif class[3]>0 char=sum(X)
        elseif class[4]>0 char=sum(Y)
        else char = 2
        end
        return w^class[1]*char
      end
    end
    res[:irreducibles]=[entry2.(Ref(char),cl[:classparams]) for
                          char in ci[:charparams]]
  else
    res[:classnames]=cl[:classnames]
    res[:orders]=cl[:orders]
    res[:centralizers]=cl[:centralizers]
    res[:classes] = map(x->div(res[:size],x),res[:centralizers])
    res[:irreducibles] = map(i->traces_words_mats(
     improve_type(toM.(chevieget(:imp,:HeckeRepresentation)(p,q,r,para,[],i))),
             cl[:classtext]),1:length(res[:classes]))
  end
  res[:centralizers]=map(x->div(res[:size],x), res[:classes])
  res[:parameter]=para
  c=one(prod(prod,para))
  res[:irreducibles]=map(x->map(y->y*c,x),res[:irreducibles])
  res
end)

const impchartableDict=Dict{Tuple{Int,Int,Int},Any}()

chevieset(:imp, :CharTable, function (p, q, r)
  get!(impchartableDict,(p,q,r))do
  oo=denominator.(chevieget(:imp,:EigenvaluesGeneratingReflections)(p,q,r))
  chevieget(:imp, :HeckeCharTable)(p,q,r,
     map(o->o==2 ? [1,-1] : E.(o,0:o-1),oo),[])
  end
end)

chevieset(:imp, :ReflectionCoDegrees, function (p, q, r)
  res=collect(p*(0:r-1))
  if p==q && p>=2 && r>2 res[r]-=r end
  res
end)

# JM 30/11/2000 we have to decide how to represent cuspidals of imprimitive
# groups -- the function below is an ad-hoc solution for now
# ImprimitiveCuspidalName(symbol) returns the TeX name
function ImprimitiveCuspidalName(S)
  S=convert(Vector{Vector{Int}},S)
  r=ranksymbol(S)
  d=length(S)
  s=joindigits(length.(S))
  if r==0 return "" end
  if sum(length,S)%d==1 # G(d,1,r)
    if r==1 d==3 ? "Z_3" : "Z_{$d}^{$s}"
    else "G_{$d,1,$r}^{$s}"
    end
  else # G(d,d,r)
    if r==2
      if d==4 "B_2"
      elseif d==6 
        p=Dict("212010"=>"-1","221001"=>"1",
               "211200"=>"\\zeta^2","220110"=>"\\zeta_3")
        "G_2[$(p[s])]"
      else "I_2($d)["*join(chevieget(:I,:SymbolToParameter)(S),",")*"]"
      end
    elseif r==3 && d==3 "G_{3,3,3}[\\zeta_3"* (s=="300" ? "" : "^2")*"]"
    elseif r==3 && d==4 "G_{4,4,3}["*"\\zeta_4"*(s=="3010" ? "" : "^3")*"]"
    else "G_{$d,$d,$r}^{$s}"
    end
  end
end
export ImprimitiveCuspidalName

function MakeFamilyImprimitive(S, uc)
  symbn0=x->findfirst(==(x),uc[:charSymbols])
  if length(S)==1 return Family("C1", symbn0.(S)) end
  r=family_imprimitive(fullsymbol(S[1]))
  r.charNumbers=symbn0.(r.symbols)
  r.special= findfirst(x->uc[:a][x]==uc[:b][x],r.charNumbers)
  r.cospecial= findfirst(x->uc[:A][x]==uc[:B][x],r.charNumbers)
  # if length(diagblocks(fourier(r)))>1 error() end
  r
end
export MakeFamilyImprimitive

chevieset(:imp, :Invariants, function (p, q, r)
  map(1:r)do i
    if i==r function(arg...)prod(arg)^div(p,q) end
    else
      function(arg...) sum(a->prod(collect(arg[a]))^p,arrangements(1:r,i)) end
    end
  end
end)

chevieset(:imp, :CharInfo, function (de, e, r)
  res=Dict{Symbol,Any}(:charparams=>chevieget(:imp, :CharParams)(de, e, r))
  d = div(de, e)
  if e==1
    s = fill(0,d)
    s[1] = 1
    res[:charSymbols]=map(x->symbol_partition_tuple(x,s),res[:charparams])
  else
    if d==1
      res[:charSymbols]=map(x->symbol_partition_tuple(x,0),res[:charparams])
    end
    if d>1 && iseven(e) && r==2
      res[:malle]=map(res[:charparams])do t
        local pos, de
        if t[length(t)] isa Number
          if t[length(t)]==0 return [1, 2, 1, findfirst(==([1]),t)]
          else return [1, 1, 2, findfirst(==([1]),t)]
          end
        else
          de=div(length(t),2)
          pos=filter(i->length(t[i])>0,1:length(t))
          if length(pos) == 1
            if t[pos[1]] == [2] return [1, 1, 1, pos[1] - de]
            else return [1, 2, 2, pos[1] - de]
            end
          elseif pos[1] <= de return [2, -1, pos[1], pos[2] - de]
          else return [2, 1, pos[2] - de, pos[1] - de]
          end
        end
      end
    elseif [de, e, r] == [3, 3, 3]
      res[:malle]=[[2,3,2],[2,3,3],[2,3,1],[3,4],[3,5],[1,9],[3,2],[3,1],[2,3,4],[1,0]]
    elseif [de, e, r] == [3, 3, 4]
      res[:malle]=[[12,6],[4,10],[6,8],[4,11],[1,18],[12,3],[6,5,2],[8,4],[8,5],[6,5,1],[3,9],[6,2],[2,6],[4,2],[4,1],[3,3],[1,0]]
    elseif [de, e, r] == [3, 3, 5]
      res[:malle]=[[30,10],[20,12],[5,19],[10,14],[10,15],[5,20],[1,30],[30,7,1],[40,6],[30,7,2],[10,11],[15,10],[20,9],[20,8],[15,11],[10,12],[4,18],[30,4],[20,5],[10,8],[10,7],[20,6],[5,12],[20,3],[10,6],[15,4],[15,5],[10,5],[6,9],[10,3],[10,2],[5,6],[5,2],[5,1],[4,3],[1,0]]
    elseif [de, e, r] == [4, 4, 3]
      res[:malle]=[[6,3],[3,6,1],[3,5],[3,6,2],[1,12],[3,2,1],[3,2,2],[3,1],[2,4],[1,0]]
    end
  end
  t=map(r:-1:0)do i
    v=map(x->Int[],1:max(de,2))
    if i>0 v[1]=[i] end
    v[2]=fill(1,r-i)
    v
  end
  if e>1
    t=map(v->minimum(map(i->circshift(v,i*d),1:e)),t)
  end
  res[:extRefl]=map(v->findfirst(==(v),res[:charparams]),t)
  if e==1 || d==1
    res[:A]=degree_gendeg_symbol.(res[:charSymbols])
    res[:a]=valuation_gendeg_symbol.(res[:charSymbols])
    res[:B]=degree_fegsymbol.(res[:charSymbols])
    res[:b]=valuation_fegsymbol.(res[:charSymbols])
  end
  if e>1 && d>1
    res[:hgal]=GAPENV.PermListList(res[:charparams], map(res[:charparams])do s
      s=copy(s)
      if !(s[end] isa Vector)
        t=div(length(s)-2,d)
        s[1:d:d*t-d+1]=circshift(s[1:d:d*t-d+1],1)
        s[1:end-2]=minimum(map(i->circshift(s[1:end-2],i*d),1:t))
        return s
      end
      s[1:d:d*e-d+1]=circshift(s[1:d:d*e-d+1],1)
      minimum(map(i->circshift(s,i*d),1:e))
    end)
  end
  res[:charnames]=map(res[:charparams])do s
      if (s[end] isa Vector) && sum(sum,s)==1
        xrepr(E(length(s), findfirst(==([1]),s)-1),TeX=true)
      else
        string_partition_tuple(s;TeX=true)
      end
    end
  res
end)
