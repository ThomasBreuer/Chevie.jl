#A  good example to see how long  the programs will take for computations in
#big Coxeter groups is the following:
#
#   julia> W=coxgroup(:B,5);
#   julia> LeftCells(W);
#
#which  takes `1` second cpu time on  3Ghz computer. The computation of all
#Kazhdan-Lusztig  polynomials  for  type  `F₄`  takes  a  bit more than~`5`
#seconds.   Computing  the   Bruhat  order   is  a   bottleneck  for  these
#computations; they can be speeded up by a factor of two if one does:
#
#|    gap> ReadChv("contr/brbase");
#    gap> BaseBruhat(W);;|
#
#after  which the computation  of the Bruhat  order will be  speeded up by a
#large factor.
#
#However,  Alvis'  computation  of  the  Kazhdan--Lusztig polynomials of the
#Coxeter  group of type  `H_4` in a  computer algebra system  like GAP would
#still take many hours. For such applications, it is probably more efficient
#to use a special purpose program like the one provided by F. DuCloux DuC91.
"""
This  module ports Chevie functionality for Kazhdan-Lusztig polynomials and
bases.

Let  `ℋ ` be  the Iwahori-Hecke algebra  of a Coxeter  system `(W,S)`, with
quadratic  relations `(Tₛ-uₛ₀)(Tₛ-uₛ₁)=0`  for `s∈  S`. If  `-uₛ₀uₛ₁` has a
square  root  `wₛ`,  we  can  scale  the  basis  `Tₛ`  to  get  a new basis
`tₛ=-Tₛ/wₛ`    with   quadratic    relations   `(tₛ-vₛ)(tₛ+vₛ⁻¹)=0`   where
`vₛ=wₛ/uₛ₁`.   The  most  general  case   when  Kazhdan-Lusztig  bases  and
polynomials  can be defined is when the parameters `vₛ` belong to a totally
ordered abelian group `Γ` for multiplication, see
[Lusztig1983](biblio.htm#Lus83).  We set  `Γ⁺= {γ∈  Γ∣γ>0}` and `Γ⁻={γ⁻¹∣γ∈
Γ⁺}={γ∈ Γ∣γ<0}`.

Thus  we assume `ℋ ` defined over the ring `ℤ[Γ]`, the group algebra of `Γ`
over  `ℤ`, and the quadratic  relations of `ℋ `  associate to each `s∈ S` a
`vₛ∈  Γ⁺` such that  `(tₛ-vₛ)(tₛ+vₛ⁻¹)=0`. We also  set `qₛ=vₛ²` and define
the  basis `Tₛ=vₛtₛ` with quadratic relations `(Tₛ-qₛ)(Tₛ+1)=0`; for `w∈ W`
with reduced expression `w=s₁…sₙ` we define ``q_w∈ Γ⁺`` by
``q_w^½=v_{s₁}…v_{sₙ}`` and let ``q_w=(q_w^½)²``.

We  define the bar involution on `ℋ `  by linearity: on `ℤ[Γ]` we define it
by  ``\\overline{∑_{γ∈ Γ}a_γγ}= ∑_{γ∈ Γ} a_γ γ⁻¹`` and we extend it to `ℋ `
by  ``\\overline  Tₛ=Tₛ⁻¹  ``.  Then  the Kazhdan-Lusztig basis ``C′_w`` is
defined  as  the  only  basis  of  `ℋ  `  stable  by the bar involution and
congruent to ``t_w`` modulo ``∑_{w∈ W}Γ⁻ t_w``.

The  basis  ``C′_w``  can  be  computed  as  follows.  We  define  elements
``R_{x,y}``  of `ℤ[Γ]` by  ``T_y⁻¹=∑_x \\overline{R_{x,y⁻¹}} q_x⁻¹T_x``. We
then  define inductively  the Kazhdan-Lusztig  polynomials (in this general
context  we should say the Kazhdan-Lusztig elements of `ℤ[Γ]`, which belong
to the subalgebra of `ℤ[Γ]` generated by the `qₛ`) by
``P_{x,w}=τ_{≤(q_w/q_x)^½}  (∑_{x<y≤w}R_{x,y}P_{y,w})``  where  `τ`  is the
truncation:  ``τ_≤\\nu ∑_{γ∈  Γ} a_γγ=  ∑_{γ≤\\nu}a_γγ``; the  induction is
thus on decreasing `x` for the Bruhat order and starts at ``P_{w,w}=1``. We
have then ``C′_w=∑_y q_w^{-1/2} P_{y,w}T_y``.

The  Chevie code  for the  Kazhdan-Lusztig bases  `C`, `D` and their primed
versions, has been initially written by Andrew Mathas around 1994, who also
contributed  to  the  design  of  the programs dealing with Kazhdan-Lusztig
bases. He also implemented some other bases, such as the Murphy basis which
can  be  found  in  the  Chevie  contributions  directory. The code for the
unequal  parameters  case  has  been  written  around  1999  by F.Digne and
J.Michel. The other Kazhdan-Lusztig bases are computed in terms of the `C′`
basis.

When  the `ℤ[Γ]` is a  Laurent polynomial ring the  bar operation is taking
the  inverse of  the variables,  and truncation  is keeping terms of degree
smaller or equal to that of `ν`. It is possible to use arbitrary groups `Γ`
as   long   as   methods   `bar`:``∑_{γ∈   Γ}   a_γγ↦  ∑_{γ∈  Γ}  a_γγ⁻¹``,
`positive_part`  : ``∑_{γ∈  Γ} a_γγ↦  ∑_{γ≥ 1}  a_γγ`` and `negative_part`:
``∑_{γ∈  Γ}  a_γγ  ↦  ∑_{γ≤  1}  a_γγ``  have been defined on `ℤ[Γ]`. These
operations   will   be   used   internally   by  the  programs  to  compute
Kazhdan-Lusztig bases.

finally, benchmarks on julia 1.6.2
```benchmark
julia> function test_kl(W)
         q=Pol(); H=hecke(W,q^2,rootpara=q)
         C=Cpbasis(H); T=Tbasis(H)
         [T(C(w)) for w in elements(W)]
       end
test_kl (generic function with 1 method)

julia> @btime test_kl(coxgroup(:F,4));
2.019 s (17905502 allocations: 2.64 GiB)
```
Compare to GAP3 where the following function takes 11s for F4
```
test_kl:=function(W)local q,H,T,C;
  q:=X(Rationals);H:=Hecke(W,q^2,q);
  T:=Basis(H,"T");C:=Basis(H,"C'");
  List(Elements(W),e->T(C(e)));
end;
```
Another benchmark:
```benchmark
function test_kl2(W)
  el=elements(W)
  [KLPol(W,x,y) for x in el, y in el]
end

test_kl2 (generic function with 1 method)

julia>@btime test_kl2(coxgroup(:F,4));
5.915 s (49702830 allocations: 6.98 GiB)
```
Compare to GAP3 where the following function takes 42s for F4
```
test_kl2:=function(W)local el;
  el:=Elements(W);
  List(el,x->List(el,y->KazhdanLusztigPolynomial(W,x,y)));
end;
```

We provide also functionality to study the Kazhdan-Lusztig left cells
(for the equal-parameter Hecke algebra).

```julia-repl
julia> W=coxgroup(:H,3)
H₃

julia> c=LeftCells(W)
22-element Vector{LeftCell{FiniteCoxeterGroup{Perm{Int16},Cyc{Int64}}}}:
 LeftCell<H₃: duflo= character=φ₁‚₀>
 LeftCell<H₃: duflo=123 character=φ₁‚₁₅>
 LeftCell<H₃: duflo=(15) character=φ₅‚₅>
 LeftCell<H₃: duflo=(10) character=φ₅‚₅>
 LeftCell<H₃: duflo=(14) character=φ₅‚₅>
 LeftCell<H₃: duflo=7 character=φ₅‚₅>
 LeftCell<H₃: duflo=(12) character=φ₅‚₅>
 LeftCell<H₃: duflo=(9,12) character=φ₅‚₂>
 LeftCell<H₃: duflo=(5,11) character=φ₅‚₂>
 LeftCell<H₃: duflo=13 character=φ₅‚₂>
 ⋮
 LeftCell<H₃: duflo=(8,13) character=φ₃‚₆+φ₃‚₈>
 LeftCell<H₃: duflo=(1,15) character=φ₃‚₆+φ₃‚₈>
 LeftCell<H₃: duflo=3 character=φ₃‚₁+φ₃‚₃>
 LeftCell<H₃: duflo=2 character=φ₃‚₁+φ₃‚₃>
 LeftCell<H₃: duflo=1 character=φ₃‚₁+φ₃‚₃>
 LeftCell<H₃: duflo=6 character=φ₄‚₃+φ₄‚₄>
 LeftCell<H₃: duflo=(13) character=φ₄‚₃+φ₄‚₄>
 LeftCell<H₃: duflo=(11) character=φ₄‚₃+φ₄‚₄>
 LeftCell<H₃: duflo=9 character=φ₄‚₃+φ₄‚₄>
```
see  also  the  functions  `elements`,  `character`,  `representation`  and
`Wgraph`  for left  cells. The  operations `length`,  `in` (which  refer to
`elements`)  and `==` (which  compares Duflo involutions)  are also defined
for  left cells. When `Character(c)` has been computed, then `c.a` also has
been  bound which holds the common  value of Lusztig's `a`-function for the
elements of `c` and The irreducible constituents of `character(c)`.
"""
module KL
export KLPol, Cpbasis, Cbasis, LeftCell, LeftCells, character, Lusztigaw, 
 LusztigAw, AsymptoticAlgebra, Wgraph
using ..Gapjm

#--------- Meinolf Geck's code for KL polynomials ---------------------------
"""
 `critical_pair(W, y, w)` returns the critical pair z≤w associated to y≤w.

Let  `ℒ` (resp.  `ℛ `)  be the  left (resp.  right) descent  set. A pair of
elements y≤w of W is called critical if `ℒ(y)⊃ ℒ(w)` and `ℛ (y)⊃ ℛ (w)`. If
y≤w is not critical, y can be multiplied from the left (resp. the right) by
an  element of  `ℒ(w)` (resp.  `ℛ (w)`)  which is  not in `ℒ (y)` (resp. `ℛ
(y)`) until we get a critical pair z≤w. The function returns z. If y≤w then
y≤z≤w.

The significance of this construction is that `KLPol(W,y,w)==KLPol(W,z,w)`

```julia-repl
julia> W=coxgroup(:F,4)
F₄

julia> w=longest(W)*gens(W)[1];length(W,w)
23

julia> y=W(1:4...);length(W,y)
4

julia> cr=KL.critical_pair(W,y,w);length(W,cr)
16

julia> Pol(:x);KLPol(W,y,w)
Pol{Int64}: x³+1

julia> KLPol(W,cr,w)
Pol{Int64}: x³+1
```julia-repl

"""
function critical_pair(W::CoxeterGroup,y,w)::typeof(y)
  Lw=filter(i->isleftdescent(W,w,i),eachindex(gens(W)))
  Rw=filter(i->isleftdescent(W,inv(w),i),eachindex(gens(W)))
  function cr(y)::typeof(y)
    for s in Lw if !isleftdescent(W,y,s) return cr(gens(W)[s]*y) end end
    for s in Rw if !isleftdescent(W,inv(y),s) return cr(y*gens(W)[s]) end end
    y
  end
  cr(y)
end

"""
  KLμ(W, y, w) highest coefficient of KLPol(W,y,w)

KLμ returns the coefficient of highest possible degree (l(w)-l(y)-1)/2
of  KLPol(W,y,w). This is 0 unless y≤w for the Bruhat order.
"""
function KLμ(W::CoxeterGroup,y,w)
  ly=length(W,y)
  lw=length(W,w)
  if ly>=lw || !bruhatless(W,y,w) return 0 end
  if lw==ly+1 return 1 end
  if any(s->(isleftdescent(W,w,s) && !isleftdescent(W,y,s))
    || (isleftdescent(W,inv(w),s) && !isleftdescent(W,inv(y),s)),
    eachindex(gens(W)))
    return 0
  end
  pol=KLPol(W,y,w)
  if degree(pol)==(lw-ly-1)//2 return pol[end]
  else return 0 end
end

"""
  KLPol(W,y,w) returns the Kazhdan-Lusztig polynomial P_{y,w} of W

To  compute Kazhdan-Lusztig polynomials in  the one-parameter case it seems
that  the best  approach still  is by  using the  recursion formula  in the
original  article KL79. One can first run  a number of standard checks on a
given  pair  of  elements  to  see  if the computation of the corresponding
polynomial  can be reduced to a similar computation for elements of smaller
length.  One  such  check  involves  the  notion  of  critical  pairs  (see
[Alvis1987](biblio.htm#Alv87)):  a pair  of elements  `w₁,w₂∈ W`  such that
`w₁≤w₂`  is *critical* if `ℒ(w₂)  ⊆ ℒ(w₁)` and `ℛ  (w₂)⊆ ℛ (w₁)`, where `ℒ`
and `ℛ ` denote the left and right descent set, respectively. Now if `y≤w ∈
W`  are arbitrary elements  then there always  exists a critical pair `z≤w`
with  `y≤z≤w` and then ``P_{y,w}=P_{z,w}``. Given two elements `y` and `w`,
such a critical pair is found by the function 'critical_pair'. Whenever the
polynomial  corresponding to a critical pair is computed then this pair and
the  polynomial  are  stored  in  the  property  `:klpol` of the underlying
Coxeter group.

```julia-repl
julia> W=coxgroup(:B,3)
B₃

julia> map(i->map(x->KLPol(W,one(W),x),elements(W,i)),1:W.N)
9-element Vector{Vector{Pol{Int64}}}:
 [1, 1, 1]
 [1, 1, 1, 1, 1]
 [1, 1, 1, 1, 1, 1, 1]
 [1, 1, 1, x+1, 1, 1, 1, 1]
 [x+1, 1, 1, x+1, x+1, 1, x+1, 1]
 [1, x+1, 1, x+1, x+1, x²+1, 1]
 [x+1, x+1, x²+x+1, 1, 1]
 [x²+1, x+1, 1]
 [1]
```
"""
function KLPol(W::CoxeterGroup,y,w)::Pol{Int}
  if !bruhatless(W,y,w) return Pol(Int[],0) end
  y=critical_pair(W,y,w)
  lw=length(W,w)
  if lw-length(W,y)<=2 return Pol(1) end
  d=get!(()->Dict{Tuple{Perm,Perm},Pol{Int}}(),W,:klpol)
  if haskey(d,(w,y)) return  d[(w,y)] end
  s=firstleftdescent(W,w)
  v=W(s)*w
  pol=KLPol(W,W(s)*y,v)+shift(KLPol(W,y,v),1)
  lz=lw-2
  while div(lw-lz,2)<=degree(pol)
   for z in CoxGroups.elements(W,lz)::Vector{typeof(w)}
      if div(lw-lz,2)<=degree(pol) && pol.c[div(lw-lz,2)+1]>0 &&
        isleftdescent(W,z,s) && bruhatless(W,y,z)
        let z=z, m=m=KLμ(W,z,v)
        if m!=0
          pol-=m*shift(KLPol(W,y,z),div(lw-lz,2))
        end
        end
      end
    end
    lz-=2
  end
  d[(w,y)]=pol
end

#---------- JM & FD code for the C' basis -------------------------------------

HeckeAlgebras.rootpara(H::HeckeAlgebra,x::Perm)=equalpara(H) ?  rootpara(H)[1]^length(H.W,x) : prod(rootpara(H)[word(H.W,x)])

struct HeckeCpElt{P,C,TH<:HeckeAlgebra}<:HeckeElt{P,C}
  d::ModuleElt{P,C} # has better merge performance than Dict
  H::TH
end
HeckeAlgebras.clone(h::HeckeCpElt,d)=HeckeCpElt(d,h.H)

struct HeckeCElt{P,C,TH<:HeckeAlgebra}<:HeckeElt{P,C}
  d::ModuleElt{P,C} # has better merge performance than Dict
  H::TH
end
HeckeAlgebras.clone(h::HeckeCElt,d)=HeckeCElt(d,h.H)

HeckeAlgebras.basename(h::HeckeCpElt)="C'"
HeckeAlgebras.basename(h::HeckeCElt)="C"

"""
`Cpbasis(H)`
    
returns  a function which gives the `C'`-basis of the Iwahori-Hecke algebra
`H`  (see [(5.1)Lusztig1985](biblio.htm#Lus85)).  This basis  is defined by
``C'_x= ∑_{y≤x}P_{y,x}q_x^{-1/2} T_y`` for `x ∈ W`. We have
``C'_x=(-1)^{l(x)}alt(C_x)`` for all `x ∈ W` (see `alt`).

```julia-repl
julia> W=coxgroup(:B,2);@Pol v;H=hecke(W,[v^4,v^2])
hecke(B₂,Pol{Int64}[v⁴, v²])

julia> Cp=Cpbasis(H);h=Cp(1)^2
(v²+v⁻²)C′₁

julia> k=Tbasis(h)
(1+v⁻⁴)T.+(1+v⁻⁴)T₁

julia> Cp(k)
(v²+v⁻²)C′₁
```
"""
Cpbasis(H::HeckeAlgebra)=(x...)->isempty(x) ? HeckeCpElt(ModuleElt(one(H.W)=>one(coefftype(H))),H) : Cpbasis(H,x...)
Cpbasis(H::HeckeAlgebra,w::Vector{<:Integer})=HeckeCpElt(ModuleElt(H.W(w...)=>one(coefftype(H))),H)
Cpbasis(H::HeckeAlgebra,w::Vararg{Integer})=Cpbasis(H,collect(w))
Cpbasis(H::HeckeAlgebra,w)=Cpbasis(H,word(H.W,w))
Cpbasis(H::HeckeAlgebra,h::HeckeElt)=Cpbasis(h)

"""
`Cbasis(H::HeckeAlgebra)`

returns  a function which gives the  `C`-basis of the Iwahori-Hecke algebra
`H`. The algebra `H` should have the functon `rootpara` defined. This basis
is  defined as follows (see e.g. [(5.1)Lusztig1985](biblio.htm#Lus85)). Let
`W`  be the underlying Coxeter group. For  `x,y ∈ W` let ``P_{x,y}`` be the
corresponding  Kazhdan--Lusztig polynomial. If ``\\{T_w ∣ w∈ W\\}`` denotes
the usual T-basis, then ``C_x=\\sum_{y\\le
x}(-1)^{l(x)-l(y)}P_{y,x}(q^{-1})q_x^{1/2}q_y^{-1}  T_y`` for `x  ∈ W`. For
example,  we have `Cₛ=qₛ⁻½Tₛ-qₛ½T₁`  for `s ∈  S`. Thus, the transformation
matrix between the `T`-basis and the `C`-basis is lower unitriangular, with
monomials  in `qₛ` along the diagonal.  In the one-parameter case (all `qₛ`
are equal to `v²`) the multiplication rules for the `C` basis are given by:

`Cₛ⋅Cₓ =-(v+v^-1)Cₓ`, if `sx<x`, and `Cₛₓ+∑ₜ μ(t,x)Cₜ` if `sx>x`.

where  the sum is over  all `t` such that  `t<x, l(t)≢l(x)~mod~2 and st<t`.
The  coefficient `μ(t,x)` is the coefficient of degree `(l(x)-l(t)-1)/2` in
the Kazhdan--Lusztig polynomial ``P_{x,t}``.

```julia-repl
julia> W=coxgroup(:B,3);H=hecke(W,Pol(:v)^2)
hecke(B₃,v²)

julia> T=Tbasis(H);C=Cbasis(H);T(C(1))
-vT.+v⁻¹T₁

julia> C(T(1))
v²C.+vC₁
```

We  can  also  compute  character  values  on  elements in the `C`-basis as
follows:

```julia-repl
julia> ref=reflrep(H)
3-element Vector{Matrix{Pol{Int64}}}:
 [-1 0 0; -v² v² 0; 0 0 v²]
 [v² -2 0; 0 -1 0; 0 -v² v²]
 [v² 0 0; 0 v² -1; 0 0 -1]
```

```julia-rep1
julia> c=CharTable(H).irr[charinfo(W).extRefl[[2]],:]
1×10 Matrix{Pol{Int64}}:
 3  2v²-1  v⁸-2v⁴  -3v¹²  2v²-1  v⁴  v⁴-2v²  -v⁶  v⁴-v²  0

julia> hcat(char_values.(C.(classreps(W)),Ref(c))...)
1×10 Matrix{Pol{Int64}}:
 3  -v-v⁻¹  0  0  -v-v⁻¹  2  0  0  1  0
``` 
"""
Cbasis(H::HeckeAlgebra)=(x...)->isempty(x) ? HeckeCElt(ModuleElt(one(H.W)=>one(coefftype(H))),H) : Cbasis(H,x...)
Cbasis(H::HeckeAlgebra,w::Vector{<:Integer})=HeckeCElt(ModuleElt(H.W(w...)=>one(coefftype(H))),H)
Cbasis(H::HeckeAlgebra,w::Vararg{Integer})=Cbasis(H,collect(w))
Cbasis(H::HeckeAlgebra,w)=Cbasis(H,word(H.W,w))
Cbasis(H::HeckeAlgebra,h::HeckeElt)=Cbasis(h)

# To convert from "T", we use the fact that the transition matrix M from
# any  KL  bases to  the  standard  basis  is triangular  with  diagonal
# coefficient on  T_w equal  to rootpara(H,w)^-1.  The transition  matrix is
# lower triangular for the C and  C' bases, and upper triangular for the
# D and D' bases which is what index(maximum or minimum) is for.
function toKL(h::HeckeTElt,klbasis,index::Function)
  H=h.H
  res=klbasis(zero(h.d),H)
  while !iszero(h)
    l=length.(Ref(H.W),keys(h.d))
    l=findall(==(index(l)),l)
    tmp=klbasis(ModuleElt(w=>c*rootpara(H,w) for (w,c) in h.d.d[l];check=false),H)
    res+=tmp
    h-=Tbasis(H,tmp)
  end
  res
end

Cpbasis(h::HeckeTElt)=toKL(h,HeckeCpElt,maximum)

Cbasis(h::HeckeTElt)=toKL(h,HeckeCElt,maximum)

function getCp(H::HeckeAlgebra{C,G},w::P)where {P,C,G}
  W=H.W
  cdict=get!(()->Dict{P,Any}(one(W)=>one(H)),H,Symbol("C'->T"))
  if haskey(cdict,w) return cdict[w] end
  T=Tbasis(H)
  if equalpara(H)
    l=firstleftdescent(W,w)
    s=gens(W)[l]
    if w==s
      return cdict[w]=inv(rootpara(H)[l])*(T(s)-H.para[l][2]*one(H))
    else
      res=getCp(H,s)*getCp(H,s*w)
      tmp=zero(H)
      for (e,coef) in res.d
        if e!=w tmp+=positive_part(coef*rootpara(H,e))*getCp(H,e) end
      end
      res-=tmp
    end
  else
    elm=reduce(vcat,reverse(bruhatless(W,w)))
    coeff=fill(inv(rootpara(H,w)),length(elm))# start with Lusztig  ̃T basis
    f(w)= w==one(W) ? 1 : prod(y->-H.para[y][2],word(W,w))
    for i in 2:length(elm)
      x=elm[i]
      qx=rootpara(H,x)
      z=critical_pair(W,x,w)
      if x!=z coeff[i]=f(z)*inv(f(x))*coeff[findfirst(==(z),elm)]
      else
        coeff[i]=-negative_part(sum(j->
          bar(qx*inv(T(inv(elm[j]))).d[x])*coeff[j],1:i-1))*inv(qx)
      end
    end
    res=HeckeTElt(ModuleElt(Pair.(elm,coeff)),H)
  end
  cdict[w]=res
end

"""
`Tbasis(h::HeckeCpElt)` 

converts the element `h` of the `C'` basis to the `T` basis.

Implementation Jean Michel and François Digne 1999. 

For one-parameter Hecke algebras, we use the formulae:
``C'_w=Σ_{y≤w}P_{y,w}(q)q^{-l(w)/2}T_y``
and if ``sw<w`` then

``C'ₛ C'_{sw}=C'_w+Σ_{y<sw}μ(y,sw)C'_y=Σ_{v≤w}μᵥ Tᵥ``

where

``μᵥ=P_{v,w}(q)q^{-l(w)/2}+Σ_{v≤y≤sw}μ(y,sw)P_{v,y}(q)q^{-l(y)/2}``

It  follows that if ``deg(μᵥ)>=-l(v)``  then ``deg(μᵥ)=-l(v)`` with leading
coefficient  ``μ(v,sw)`` (this happens exactly for ``y=v`` in the sum which
occurs in the formula for ``μᵥ``).

```julia-repl
julia> W=coxgroup(:B,3)
B₃

julia> @Pol v;H=hecke(W,v^2,rootpara=v)
hecke(B₃,v²,rootpara=v)

julia> C=Cpbasis(H); Tbasis(C(1,2))
v⁻²T.+v⁻²T₂+v⁻²T₁+v⁻²T₁₂
```

For general Hecke algebras, we follow formula 2.2 in 
[Lusztig1983](biblio.htm#Lus83)

`` \\overline{P̄̄_{x,w}}-P_{x,w}=∑_{x<y≤w} R_{x,y} P_{y,w}``

where ``R_{x,y}=\\overline{(t_{y⁻¹}⁻¹|t_x)}`` where `t`  is the basis with
parameters  `qₛ,-qₛ⁻¹`. It follows that ``P_{x,w}`` is the negative part of
``∑_{x<y≤w}  R_{x,y} P_{y,w}`` which  allows to compute  it by induction on
`l(w)-l(x)`.
"""
HeckeAlgebras.Tbasis(h::HeckeCpElt)=sum(getCp(h.H,e)*c for (e,c) in h.d)

function HeckeAlgebras.Tbasis(h::HeckeCElt)
  sum(h.d)do (e,c)
    alt(getCp(h.H,e))*c*(-1)^length(h.H.W,e)
  end
end

Base.:*(a::HeckeCpElt,b::HeckeCpElt)=Cpbasis(Tbasis(a)*Tbasis(b))

#----------------------------------Left cells --------------------------
@GapObj struct LeftCell{G<:Group}
  group::G
# Optional (computed) fields are:
# .reps representatives of the cell
# .duflo the Duflo involution of the cell
# .character the character of the cell
# .a the a-function of the cell
# .elements the elements of the cell
end

Base.copy(c::LeftCell)=LeftCell(c.group,copy(c.prop))

duflo(c::LeftCell)=c.duflo

Base.hash(c::LeftCell, h::UInt)=hash(duflo(c),h)

function Base.length(c::LeftCell)
  if haskey(c,:character)
    sum(first.(CharTable(c.group).irr)[c.character])
  else length(elements(c))
  end
end

"""
`character(c)`

Returns  a list `l`  such that the  character of `c.group`  afforded by the
left cell `c` is `sum(CharTable(c.group).irr[l])`.

```julia-repl
julia> c=LeftCells(coxgroup(:G,2))[3]
LeftCell<G₂: duflo=2 character=φ₂‚₁+φ′₁‚₃+φ₂‚₂>

julia> character(c)
3-element Vector{Int64}:
 3
 5
 6
```
"""
function character(c::LeftCell)
  get!(c,:character)do
    r=representation(c,hecke(c.group))
    cc=HasType.traces_words_mats(r,classinfo(c.group)[:classtext])
    ct=CharTable(c.group)
    cc=decompose(ct,cc)
    char=vcat(map(i->fill(i,cc[i]),1:length(cc))...)
    c.a=charinfo(c.group).a[char]
    if length(Set(c.a))>1 error() else c.a=c.a[1] end
    char
  end
end

function Base.show(io::IO,c::LeftCell)
   print(io,"LeftCell<",c.group,": ")
   if haskey(c,:duflo)
     print(io,"duflo=",joindigits(describe_involution(c.group,duflo(c))))
   end
   if haskey(c,:character)
     uc=UnipotentCharacters(c.group)
     ch=c.character
     i=findfirst(f->uc.harishChandra[1][:charNumbers][ch[1]] in f[:charNumbers],
                 uc.families)
     f=uc.families[i]
     i=f.charNumbers[Families.special(f)]
     i=findfirst(==(i),uc.harishChandra[1][:charNumbers])
     p=findfirst(==(i),ch)
     p=vcat([[i,1]],tally(vcat(ch[1:p-1],ch[p+1:end])))
     print(io," character=",join(
       map(p)do v
        (v[2]!=1 ? string(v[2]) : "")*charnames(io,c.group)[v[1]]
      end,"+"))
   end
   print(io,">")
 end

# br is a braid_relation of W
# returns corresponding * op on w if applicable otherwise returns w
function leftstar(W,br,w)
  # st is a left or right member of a braidrelation of W
  # leftdescents(W,w) contains st[1] and not st[2]
  # returns corresponding * operation applied to w
  function leftstarNC(W,st,w)
    rst=refls(W,st)
    w0=prod(rst)
    i=1
    while true
      w=rst[i]*w
      i+=1
      w0*=rst[i]
      if !isleftdescent(W,w,st[i]) break end
    end
    w0*w
  end
  l,r=map(x->restriction(W)[x],br)
  if isleftdescent(W,w,l[1]) isleftdescent(W,w,r[1]) ? w : leftstarNC(W,l,w)
  else isleftdescent(W,w,r[1]) ? leftstarNC(W,r,w) : w
  end
end

# List of functions giving all possible left * images of w
leftstars(W)=map(st->(w->leftstar(W,st,w)),
                 filter(r->length(r[1])>2,braid_relations(W)))

function Groups.elements(c::LeftCell)
  get!(c,:elements)do
    elements=orbit(leftstars(c.group),duflo(c);action=(x,f)->f(x))
    for w in c.reps
      append!(elements,orbit(leftstars(c.group),w;action=(x,f)->f(x)))
    end
    sort(collect(Set(elements)))
  end
end

Groups.words(c::LeftCell)=word.(Ref(c.group),elements(c))

Base.:(==)(a::LeftCell,b::LeftCell)=duflo(a)==duflo(b)

Base.in(w,c::LeftCell)=w in elements(c)

# KLμMat(W, list)  . . . . (symmetrized) matrix of highest coefficients 
# μ(x,y) of Kazhdan-Lusztig polynomials P_{x,y} for x,y∈ list
function KLμMat(W,c)
  w0c=longest(W).*c
  lc=length.(Ref(W),c)
  m=zeros(Int,length(c),length(c))
  for k in 0:maximum(lc)-minimum(lc)
    for i in eachindex(c)
      for j in filter(j->lc[i]-lc[j]==k,eachindex(c))
        if lc[i]+lc[j]>W.N m[i,j]=KLμ(W,w0c[i],w0c[j])
        else m[i,j]=KLμ(W,c[j],c[i])
        end
        m[j,i]=m[i,j]
      end
    end
  end
  return m
end

function μ(c::LeftCell)
  get!(c,:mu)do
    KLμMat(c.group,elements(c))
  end
end

"""
`representation(c::LeftCell,H)`

returns matrices giving the representation of `H` on the left cell `c`.

```julia-repl
julia> W=coxgroup(:H,3)
H₃

julia> c=LeftCells(W)[3]
LeftCell<H₃: duflo=(15) character=φ₅‚₅>

julia> @Mvp q;H=hecke(W,q)
hecke(H₃,q)

julia> representation(c,H)
3-element Vector{Matrix{Mvp{Int64, Rational{Int64}}}}:
 [-1 0 … 0 0; 0 -1 … 0 -q½; … ; 0 0 … q 0; 0 0 … 0 q]
 [-1 -q½ … 0 0; 0 q … 0 0; … ; 0 0 … -1 0; 0 -q½ … 0 -1]
 [q 0 … 0 0; -q½ -1 … 0 0; … ; 0 0 … q 0; 0 0 … 0 -1]
```
"""
Chars.representation(c::LeftCell,H)=WGraphToRepresentation(H,Wgraph(c))

# returns right star operation st (a BraidRelation) of LeftCell c
function RightStar(st,c)
  res=copy(c)
  W=c.group
  rs(w)=leftstar(W,st,w^-1)^-1
  if haskey(c,:duflo)
   res.duflo=rs(rs(duflo(c))^-1)
  end
  if haskey(c,:reps) res.reps=rs.(c.reps) end
  if haskey(c,:elements)
    res.elements=rs.(c.elements)
    n=sortperm(res.elements)
    res.elements=res.elements[n]
    if haskey(c,:mu) res.mu=c.mu[n,n] end
    if haskey(c,:graph) res.orderGraph=c.orderGraph[n] end
  end
  res
end

# Fo an irreducible type, reps contain:
# .duflo,  .reps: elements of W represented as images of simple roots
# .character: decomposition of left cell in irreducibles
function LeftCellRepresentatives(W)
  res=map(refltype(W))do t
    R=reflection_group(t)
    rr=getchev(t,:KLeftCellRepresentatives)
    if isnothing(rr) return nothing end
    return map(rr)do r
      r=copy(r)
      function f(l)
        m=transpose(toM(R.rootdec[l]))
        w=Perm(R.rootdec,Ref(m).*R.rootdec)
        inclusion(W)[t.indices[word(R,w)]]
      end
      r[:duflo]=f(r[:duflo])
      if isempty(r[:reps]) r[:reps]=Vector{Int}[]
      else r[:reps]=f.(r[:reps])
      end
      push!(r[:reps],r[:duflo])
      r
    end
  end
  if isempty(res) return res end
  if nothing in res return nothing end
  n=getchev(W,:NrConjugacyClasses)
  return map(cartesian(res...)) do l
    duflo=W(vcat(map(x->x[:duflo],l)...)...)
    reps=map(v->W(vcat(v...)...),cartesian(map(x->x[:reps],l)...))
    reps=setdiff(reps,[duflo])
    character=map(p->cart2lin(n,p),cartesian(map(x->x[:character],l)...))
    a=charinfo(W).a[character]
    if length(Set(a))>1 error() else a=a[1] end
    return LeftCell(W,Dict{Symbol,Any}(:duflo=>duflo,:reps=>reps,
                 :character=>character,:a=>a))
  end
end

function OldLeftCellRepresentatives(W)
  st=map(st->(c->RightStar(st,c)),filter(r->length(r[1])>2,braid_relations(W)))
  rw=groupby(x->leftdescents(W,x^-1),elements(W))
  rw=[(rd=k,elements=sort(v)) for (k,v) in rw]
  sort!(rw;by=x->x.rd)
  sort!(rw;by=x->length(x.elements))
  cells0=LeftCell{typeof(W)}[]
  while length(rw)>0
    c=rw[1].elements
    InfoChevie("#I R(w)=",rw[1].rd," : #Elts=",length(c))
    mu=KLμMat(W,c)
    n=1:length(c)
    Lleq=[x==y || (mu[x,y]!=0 && any(i->isleftdescent(W,c[x],i) &&
       !isleftdescent(W,c[y],i),eachindex(gens(W)))) for x in n, y in n]
    Lleq=transitive_closure(Lleq)
    m=Set(n[Lleq[i,:].&Lleq[:,i]] for i in n)
    x=[LeftCell(W,Dict{Symbol,Any}(:elements=>c[d],:mu=>mu[d,d])) for d in m]
#   println("split ",length.(x))
    while length(x)>0
      c=x[1]
      i=filter(x->isone(x^2),c.elements)
      if length(i)==1 c.duflo=i[1]
      else m=map(x->length(W,x)-2*degree(KLPol(W,one(W),x)),i)
        p=argmin(m)
        c.a=m[p]
        c.duflo=i[p] # Duflo involutions minimize Delta
      end
      i=filter(x->!(c.duflo in x),
               orbits(leftstars(W),c.elements;action=(x,f)->f(x)))
      c.reps=first.(i)
      push!(cells0,c)
#     xprintln("c=",c," length=",length(c))
      n=orbit(st,c;action=(x,f)->f(x))
#     println(length(n),"x",length(n[1]))
      InfoChevie(", ",length(n)," new cell")
      if length(n)>1 InfoChevie("s") end
      for e in n
        rd=leftdescents(W,duflo(e))
        i=findfirst(x->x.rd==rd,rw)
        if i==1 x=filter(c->!(c.elements[1] in elements(e)),x)
        elseif i!==nothing
	  setdiff!(rw[i].elements,elements(e))
        end
      end
    end
    InfoChevie(" \n")
    rw=filter(x->length(x.elements)>0,rw)
    rw=rw[2:end]
    sort!(rw,by=x->length(x.elements))
  end
  cells0
end

function cellreps(W)
  get!(W,:cellreps)do
    cc=LeftCellRepresentatives(W)
    if isnothing(cc) cc=OldLeftCellRepresentatives(W) end
    cc
  end
end

"""
  `LeftCells(W[,i])` left cells of `W` [in `i`-th 2-sided cell]
  for the 1-parameter Hecke algebra `hecke(W,q)`

The  program uses precomputed  data(see [Geck-Halls 2014](biblio.htm#GH14))
for  exceptional types and for type `:A`,  so is quite fast for these types
(it  takes 13 seconds to compute the  101796 left cells for type `E₈`). For
other  types, left cells are computed from first principles, thus computing
many  Kazhdan-Lusztig polynomials. It takes 60  seconds to compute the left
cells of `D₆`, for example.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> LeftCells(W)
4-element Vector{LeftCell{FiniteCoxeterGroup{Perm{Int16},Int64}}}:
 LeftCell<G₂: duflo= character=φ₁‚₀>
 LeftCell<G₂: duflo=12 character=φ₁‚₆>
 LeftCell<G₂: duflo=2 character=φ₂‚₁+φ′₁‚₃+φ₂‚₂>
 LeftCell<G₂: duflo=1 character=φ₂‚₁+φ″₁‚₃+φ₂‚₂>
```

Printing such a record displays the character afforded by the left cell and
its  Duflo involution; the Duflo involution `r`  is printed as a subset `I`
of    `1:W.N`   such    that   `r=longest(reflection_subgroup(W,I))`,   see
`describe_involution`.

If  a second argument `i` is given, the program returns only the left cells
which  are in the `i`-th two-sided cell,  that is whose character is in the
`i`-th family of `W` (see [`Families`](@ref)).

```julia-repl
julia> W=coxgroup(:G,2);
julia> LeftCells(W,1)
2-element Vector{LeftCell{FiniteCoxeterGroup{Perm{Int16},Int64}}}:
 LeftCell<G₂: duflo=2 character=φ₂‚₁+φ′₁‚₃+φ₂‚₂>
 LeftCell<G₂: duflo=1 character=φ₂‚₁+φ″₁‚₃+φ₂‚₂>
```
"""
function LeftCells(W,i=0)
  cc=cellreps(W)
  if !iszero(i)
    uc=UnipotentCharacters(W)
    cc=filter(c->uc.harishChandra[1][:charNumbers][character(c)[1]]
                                in uc.families[i][:charNumbers],cc)
  end
  st=map(st->(c->RightStar(st,c)),filter(r->length(r[1])>2,braid_relations(W)))
  d=map(c->orbit(st,c;action=(x,f)->f(x)),cc)
  length(d)==1 ? d[1] : union(d...)
end

# gens is a list each element of which can operate on element e
# returns minimal word w such that Composition(gens[w]) applied to e
# satifies cond
function MinimalWordProperty(e,gens::Vector,cond::Function;action::Function=^)
  if cond(e) return Int[] end
  elements=[e]
  nbLength=[1]
  cayleyGraph=[Int[]]
  bag=Set(elements)
  InfoChevie("#I ")
  while true
    new=map(1+sum(nbLength[1:end-1]):length(elements))do h
      map(g->[action(elements[h],gens[g]),[h,g]],eachindex(gens))
    end
    new=unique(first,vcat(new...))
    new=filter(x->!(x[1] in bag),new)
    append!(cayleyGraph,map(x->x[2],new))
    new=first.(new)
    p=findfirst(cond,new)
    if !isnothing(p) InfoChevie("\n")
      res=Int[]
      p=length(elements)+p
      while p!=1 push!(res,cayleyGraph[p][2])
        p=cayleyGraph[p][1]
      end
      return res
    end
    if all(x->x in elements,new) error("no solution") end
    append!(elements,new)
    bag=union(bag,new)
#   if Length(new)>10 then
       InfoChevie(length(new)," ")
#   fi;
    push!(nbLength,length(new))
  end
end

"""
`LeftCell(W,w)`

returns  a  record  describing  the  left  cell  of  `W`  for  `hecke(W,q)`
containing element `w`.

```julia-repl
julia> W=coxgroup(:E,8)
E₈

julia> LeftCell(W,W((1:8)...))
LeftCell<E₈: duflo=(42,43) character=φ₃₅‚₂>
```
"""
function LeftCell(W,w)
  l=cellreps(W)
  sst=filter(r->length(r[1])>2,braid_relations(W))
  word=MinimalWordProperty(w,map(st->(w->leftstar(W,st,w^-1)^-1),sst),
     w->any(c->w in c,l);action=(x,f)->f(x))
  v=w
  for g in reverse(word) v=leftstar(W,sst[g],v^-1)^-1 end
  cell=l[findfirst(c->v in c,l)]
  for g in word cell=RightStar(sst[g],cell) end
  return cell
end

"""
`Wgraph(c::LeftCell)`
    
return the W-graph for a left cell for the one-parameter Hecke algebra
of a finite Coxeter group. 
"""
function Wgraph(c::LeftCell)
  get!(c,:graph)do
    e=elements(c)
    mu=μ(c)
    n=length(e)
    nodes=leftdescents.(Ref(c.group),e)
    p=sortperm(nodes)
    nodes=nodes[p]
    mu=mu[p,p]
    c.orderGraph=p
    nodes=vcat(map(tally(nodes)) do p
        p[2]==1  ? [p[1]] : [p[1],p[2]-1]
        end...)
    graph=[nodes,[]]
    l=vcat(map(i->map(j->[mu[i,j],mu[j,i],i,j],1:i-1),1:n)...)
    l=filter(x->x[1]!=0 || x[2]!=0,l)
    if isempty(l) return graph end
    for u in collectby(x->x[[1,2]],l)
      if u[1][1]==u[1][2] value=u[1][1] else value=u[1][[1,2]] end
      w=[value,[]]
      for k in collectby(first,map(x->x[[3,4]],u)) 
        push!(w[2],vcat([k[1][1]],map(x->x[2],k)))
      end
      push!(graph[2],w)
    end
    graph
  end
end

"""
`Wgraph(W::CoxeterGroup,i)`
    
return the W-graph for the `i`-th irreducible representation of `W` (or of the
1-parameter Hecke algebra of `W `).

Only implemented for irreducible groups of type `E`, `F` or `H`.
"""
function Wgraph(W,i)
  t=refltype(W)
  if length(t)!=1 error(W," should be irreducible") end
  g=getchev(t[1],:WGraph,i)
  if isnothing(g) error(W," should be of type `E`, `F` or `H`.") end
  g
end

"""
`Lusztigaw(W,w)`

For  `w` an element  of the Coxeter  groups `W`, this  function returns the
coefficients  on the irreducible characters of the virtual Character `ca_w`
defined  in [5.10.2 Lusztig1985](biblio.htm#Lus85).  This character has the
property that the corresponding almost character is integral and positive.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> l=Lusztigaw(W,W(1))
6-element Vector{Int64}:
 0
 0
 1
 0
 1
 1

julia> sum(l.*map(i->almostChar(W,i),eachindex(l)))
[G₂]:<φ′₁‚₃>+<φ₂‚₁>+<φ₂‚₂>
```
"""
function Lusztigaw(W,w)
  v=Pol()
  l=char_values(Tbasis(hecke(W,v^2;rootpara=v),w))*(-v)^-length(W,w)
  map((c,a)->c[-a],l,charinfo(W).a)
end

"""
`LusztigAw( <W>, <w>)`

For  <w> an element  of the Coxeter  groups <W>, this  function returns the
coefficients  on the irreducible  characters of the  virtual Character cA_w
defined  in [5.11.6 Lusztig1985](biblio.htm#Lus85).  This character has the
property that the corresponding almost character is integral and positive.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> l=LusztigAw(W,W(1))
6-element Vector{Int64}:
 0
 0
 0
 1
 1
 1

julia> sum(l.*map(i->almostChar(W,i),eachindex(l)))
[G₂]:<φ″₁‚₃>+<φ₂‚₁>+<φ₂‚₂>
```
"""
function LusztigAw(W,w)
  v=Pol()
  l=char_values(Tbasis(hecke(W,v^2;rootpara=v),w))*v^-length(W,w)
  map((c,a)->c[nref(W)-a],l,charinfo(W).A)
end

#----------------- Asymptotic algebra ------------------------------------
@GapObj struct AsymptoticAlgebra<:FiniteDimAlgebra
  e::Vector{Perm{Int16}}
  a::Int
  multable::Vector{Vector{Vector{Pair{Int,Int}}}}
  W
end

"""
`AsymptoticAlgebra(W,i)`

The  asymptotic algebra `A` associated to  the algebra `H=Hecke(W,q)` is an
algebra   with   basis   ``\\{tₓ\\}_{x∈   W}``   and   structure  constants
``t_xt_y=\\sum_z  γ_{x,y,z}  t_z``  given  by:  let  ``h_{x,y,z}``  be  the
coefficient  of  ``C_x  C_y``  on  ``C_z``. Then ``h_{x,y,z}=γ_{x,y,z^{-1}}
q^{a(z)/2}+``lower terms, where ``q^{a(z)/2}`` is the maximum over `x,y` of
the degree of ``h_{x,y,z}``.

The  algebra `A`  is the  direct product  of the subalgebras ``A_{\\mathcal
C}``  generated  by  the  elements  ``\\{t_x\\}_{x∈{\\mathcal  C}}``, where
``\\mathcal C`` runs over the two-sided cells of `W`. If ``\\mathcal C`` is
the  `i`-th  two-sided  cell  of  `W`, the command 'AsymptoticAlgebra(W,i)'
returns  the algebra ``A_{\\mathcal C}``. Note  that the function `a(z)` is
constant  over  a  two-sided  cell,  equal  to  the  common value of the `a
`-function   attached  to  the  characters   of  the  two-sided  cell  (see
'Character' for left cells).

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> A=AsymptoticAlgebra(W,1)
Asymptotic Algebra dim.10

julia> b=basis(A)
10-element Vector{AlgebraElt{AsymptoticAlgebra, Int64}}:
 t₂
 t₁₂
 t₂₁₂
 t₁₂₁₂
 t₂₁₂₁₂
 t₁
 t₂₁
 t₁₂₁
 t₂₁₂₁
 t₁₂₁₂₁

julia> b*permutedims(b)
10×10 Matrix{AlgebraElt{AsymptoticAlgebra, Int64}}:
 t₂      0            t₂₁₂            …  0               t₂₁₂₁        0
 t₁₂     0            t₁₂+t₁₂₁₂          0               t₁₂₁+t₁₂₁₂₁  0
 t₂₁₂    0            t₂+t₂₁₂+t₂₁₂₁₂     0               t₂₁+t₂₁₂₁    0
 t₁₂₁₂   0            t₁₂+t₁₂₁₂          0               t₁+t₁₂₁      0
 t₂₁₂₁₂  0            t₂₁₂               0               t₂₁          0
 0       t₁₂          0               …  t₁₂₁            0            t₁₂₁₂₁
 0       t₂+t₂₁₂      0                  t₂₁+t₂₁₂₁       0            t₂₁₂₁
 0       t₁₂+t₁₂₁₂    0                  t₁+t₁₂₁+t₁₂₁₂₁  0            t₁₂₁
 0       t₂₁₂+t₂₁₂₁₂  0                  t₂₁+t₂₁₂₁       0            t₂₁
 0       t₁₂₁₂        0                  t₁₂₁            0            t₁

julia> CharTable(A)
CharTable(Asymptotic Algebra dim.10)
     │2 12 212 1212 21212 1 21 121 2121 12121
─────┼────────────────────────────────────────
φ′₁‚₃│.  .   .    .     . 1  .  -1    .     1
φ₂‚₁ │1  .   2    .     1 1  .   2    .     1
φ₂‚₂ │1  .   .    .    -1 1  .   .    .    -1
φ″₁‚₃│1  .  -1    .     1 .  .   .    .     .
```
"""
function AsymptoticAlgebra(W,i)
  l=LeftCells(W,i)
  f=union(character.(l)...)
  a=l[1].a
  e=elements.(l)
  for ee in e sort!(ee,by=x->length(W,x)) end
  e=vcat(e...)
  t=map(x->findfirst(==(x.duflo),e),l)
  v=Pol()
  H=hecke(W,v^2,rootpara=v)
  T=Tbasis(H)
  Cp=Cpbasis(H)
  C=Cbasis(H)
  irr=hcat(map(x->map(p->(-1)^a*p[-a],char_values(C(x))[f]),e)...)
#   parameters:=List(e,x->IntListToString(CoxeterWord(W,x))),
#   basisname:="t");
#  A.identification:=[A.type,i,W];
#  A.zero:=AlgebraElement(A,[]);
#  A.dimension:=Length(e);
#  A.operations.underlyingspace(A);
  w0=longest(W)
  # The algorithm below follows D. Alvis, "Subrings of the asymptotic Hecke
  # algebra of type H4" Experimental Math. 17 (2008) 375--383
  multable=
  map(e)do x
    map(e)do y
#   InfoChevie(".")
      F=T(x)*T(y)
      lx=length(W,x)
      ly=length(W,y)
      sc=map(e)do z
        c=T(Cp(w0*z^-1))
        s=(-1)^length(W,z)*sum(p->c.d[w0*p[1]]*p[2]*(-1)^length(W,p[1]),F.d)
        # println("deg=",[valuation(s),degree(s)]," pdeg=",a+lx+ly-nref(W))
        findfirst(==(z^-1),e)=>s[a+lx+ly-nref(W)]
      end
      filter(x->!iszero(x[2]),sc)
    end
  end
#  A.operations.underlyingspace(A);
#  A.one:=Sum(A.basis{t});
  A=AsymptoticAlgebra(e,a,multable,W,Dict{Symbol,Any}(:irr=>irr))
  A.classnames=joindigits.(word.(Ref(W),e))
  A.charnames=charnames(W;TeX=true)[f]
  A
end

Algebras.dim(A::AsymptoticAlgebra)=length(A.e)

Base.show(io::IO,A::AsymptoticAlgebra)=print(io,"Asymptotic Algebra dim.",dim(A))

function Base.show(io::IO, h::AlgebraElt{AsymptoticAlgebra})
  function showbasis(io::IO,i)
    if hasdecor(io) res="t_"*joindigits(word(h.A.W,h.A.e[i]),"{}";always=true)
    else         res="t[$i]"
    end
    fromTeX(io,res)
  end
  show(IOContext(io,:showbasis=>showbasis),h.d)
end

Algebras.iscommutative(A::AsymptoticAlgebra)=false

function Chars.CharTable(A::AsymptoticAlgebra)
  centralizers=fill(dim(A),dim(A))
  CharTable(A.irr,A.charnames,A.classnames,centralizers,
            dim(A),Dict{Symbol,Any}(:name=>repr(A;context=:TeX=>true)))
end

end
