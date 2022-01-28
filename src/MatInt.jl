"""
Operations on integral GAP matrices (vectors of vectors)

Quickly ported from GAP; the code is still horrible (unreadable) like the
original one.
"""
module MatInt

export complementInt, leftnullspaceInt, SolutionIntMat, smith, hermite, 
  DiaconisGraham, baseInt

# largest factor of N prime to a
function prime_part(N, a)
  while true
    a=gcd(a, N)
    if a==1 return N end
    N=div(N, a)
  end
end

# rgcd(N,a) smallest nonnegative c such that gcd(N,a+c)==1
function rgcd(N, a)
  if N==1 return 0 end
  r=[mod(a-1, N)]
  d=[N]
  c=0
  while true
    for i in 1:length(r) r[i]=mod(r[i]+1,d[i]) end
    i=findfirst(<=(0),r)
    if isnothing(i)
      g=1
      i=0
      while g==1 && i<length(r)
        i+=1
        g=gcd(r[i], d[i])
      end
      if g == 1 return c end
      q=prime_part(div(d[i], g), g)
      if q>1
       push!(r,mod(r[i], q))
       push!(d, q)
      end
      r[i]=0
      d[i]=g
    end
    c+=1
  end
end

"""
`Gcdex(n1,n2)`

`Gcdex` returns a named tuple with fields `gcd` and `coeff`.

`gcd` is the gcd of `n1` and n2`.

`coeff'  is a unimodular matrix (an  integer matrix of determinant ±1) such
that `coeff*[n1,n2]=[gcd,0]`.

If  both `n1`  and `n2`  are nonzero,  abs(coeff[1,1])≤abs(n2)/(2*gcd)` and
``abs(coeff[1,2])≤abs(n1)/(2*gcd)`.

If `n1` or `n2` are not both zero `coeff[2,1]` is -n2/gcd` and `coeff[2,2]`
is `n1/gcd`.

```julia-repl
julia> MatInt.Gcdex(123,66)
(gcd = 3, coeff = [7 -13; -22 41])
# [7 -13;-22 41]*[123,66]==[3,0]
julia> MatInt.Gcdex(0,-3)
(gcd = 3, coeff = [0 -1; 1 0])
julia> MatInt.Gcdex(0,0)
(gcd = 0, coeff = [1 0; 0 1])
```
"""
function Gcdex( m, n )
  if 0<=m  f=m; fm=1
  else f=-m; fm=-1 end
  g=0<=n ? n : -n
  gm=0
  while g!=0
    q=div(f,g)
    h=g
    hm=gm
    g=f-q*g
    gm=fm-q*gm
    f=h
    fm=hm
  end
  (gcd=f, coeff= n==0 ? [fm 0; gm 1] : [fm div(f-fm*m,n); gm div(-gm*m,n)])
end

#  mgcdex(<N>,<a>,<v>) - Returns c[1],c[2],...c[k] such that
#   gcd(N,a+c[1]*v[1]+...+c[n]*v[k])==gcd(N,a,v[1],v[2],...,v[k])
function mgcdex(N, a, v)
  l=length(v)
  h=N
  M=map(1:l)do i
    g=h
    h=gcd(g, v[i])
    div(g, h)
  end
  h=gcd(a,h)
  g=div(a,h)
  reverse(map(l:-1:1)do i
    b=div(v[i], h)
    d=prime_part(M[i], b)
    if d==1 c=0
    else c=rgcd(d, numerator(g//b)*invmod(denominator(g//b),d))
      g+=c*b
    end
    c
  end)
end

#  bezout(a,b,c,d) - returns P to transform A=[a b;c d] to hnf (PA=H);
#
#  (P=coeff)*A=[e f;0 g]
#
function bezout(a, b, c, d)
  e=Gcdex(a, c)
  f=e.coeff[1,1]*b+e.coeff[1,2]*d
  g=e.coeff[2,1]*b+e.coeff[2,2]*d
  if iszero(g) return e end
  if g<0
    e=(gcd=e.gcd,coeff=[e.coeff[1,1] e.coeff[1,2];-e.coeff[2,1] -e.coeff[2,2]])
    g=-g
  end
  q=div(f-mod(f, g), g)
  (gcd=e.gcd,coeff=[e.coeff[1,1]-q*e.coeff[2,1] e.coeff[1,2]-q*e.coeff[2,2];
                    e.coeff[2,1] e.coeff[2,2]])
end

## SNFofREF - fast SNF of REF matrix
function SNFofREF(R, INPLACE)
# println("R=$R INPLACE=$INPLACE")
  n,m=size(R)
  piv=findfirst.(!iszero,eachrow(R))
  r=findfirst(isnothing,piv)
  if isnothing(r) r=length(piv)
  else
      r-=1
      piv=piv[1:r]
  end
  append!(piv, setdiff(1:m, piv))
  if INPLACE
    T=R
    for i in 1:r T[i,1:m]=T[i,piv] end
  else
    T=fill(zero(eltype(R)),n,m)
    for j in 1:m
      for i in 1:min(r,j) T[i,j]=R[i,piv[j]] end
    end
  end
  si=1
  A=Vector{Int}(undef,n)
  d=2
  for k in 1:m
    if k <= r
      d*=abs(T[k,k])
      T[k,:].=mod.(T[k,:], 2d)
    end
    t=min(k, r)
    for i in t-1:-1:si
        t=mgcdex(A[i], T[i,k], [T[i+1,k]])[1]
        if t != 0
            T[i,:]+=T[i+1,:].*t
            T[i,:].=mod.(T[i,:], A[i])
        end
    end
    for i in si:min(k-1, r)
      g=gcdx(A[i], T[i,k])
      T[i,k]=0
      if g[1] != A[i]
        b=div(A[i], g[1])
        A[i]=g[1]
        for ii in i+1:min(k-1,r)
          T[ii,:]+=mod.(T[i,:]*(-g[3]*div(T[ii,k],A[i])),A[ii])
          T[ii,k]*=b
          T[ii,:].=mod.(T[ii,:],A[ii])
        end
        if k<=r
          t=g[3]*div(T[k,k], g[1])
          T[k,:]+=-t*T[i,:]
          T[k,k]*=b
        end
        T[i,:].=mod.(T[i,:], A[i])
        if A[i]==1 si=i+1 end
      end
    end
    if k <= r
        A[k]=abs(T[k,k])
        T[k,:].=mod.(T[k,:], A[k])
    end
  end
  for i in 1:r T[i,i]=A[i] end
  T
end

"""
general operation for computation of various Normal Forms.

Options:
  - TRIANG Triangular Form / Smith Normal Form.
  - REDDIAG Reduce off diagonal entries.
  - ROWTRANS Row Transformations.
  - COLTRANS Col Transformations.
  - INPLACE change original matrix in place -- save memory

Compute  a Triangular, Hermite or  Smith form of the  `n × m` integer input
matrix `A`. Optionally, compute `n × n` and `m × m` unimodular transforming
matrices `Q, P` which satisfy `Q A==H` or `Q A P==S`.

Compute a Triangular, Hermite or Smith form of the n x m 
integer input matrix A.  Optionally, compute n x n / m x m
unimodular transforming matrices which satisfy Q C A==H 
or  Q C A B P==S.

Triangular / Hermite :

Let I be the min(r+1,n) x min(r+1,n) identity matrix with r=rank(A).
Then Q and C can be written using a block decomposition as

             [ Q1 |   ]  [ C1 | C2 ]
             [----+---]  [----+----]  A== H.
             [ Q2 | I ]  [    | I  ]

Smith :

  [ Q1 |   ]  [ C1 | C2 ]     [ B1 |   ]  [ P1 | P2 ]
  [----+---]  [----+----]  A  [----+---]  [----+----] ==S.
  [ Q2 | I ]  [    | I  ]     [ B2 | I ]  [ *  | I  ]

 * - possible non-zero entry in upper right corner...

The routines used are based on work by Arne Storjohann and were implemented
in GAP4 by him and R.Wainwright.

Returns a Dict with entry `:normal` containing the computed normal form and
optional  entries `:rowtrans` and/or `:coltrans`  which hold the respective
transformation matrix. Also in the dict are entries holding the sign of the
determinant if A is square, `:signdet`, and the rank of the matrix, `:rank`.

```julia-repl
julia> m=[1 15 28;4 5 6;7 8 9]
3×3 Matrix{Int64}:
 1  15  28
 4   5   6
 7   8   9

julia> MatInt.NormalFormIntMat(m,REDDIAG=true,ROWTRANS=true)
Dict{Symbol, Any} with 6 entries:
  :rowQ     => [-2 62 -35; 1 -30 17; -3 97 -55]
  :normal   => [1 0 1; 0 1 1; 0 0 3]
  :rowC     => [1 0 0; 0 1 0; 0 0 1]
  :rank     => 3
  :signdet  => 1
  :rowtrans => [-2 62 -35; 1 -30 17; -3 97 -55]

julia> r=MatInt.NormalFormIntMat(m,TRIANG=true,ROWTRANS=true,COLTRANS=true)
Dict{Symbol, Any} with 9 entries:
  :rowQ     => [-2 62 -35; 1 -30 17; -3 97 -55]
  :normal   => [1 0 0; 0 1 0; 0 0 3]
  :colQ     => [1 0 -1; 0 1 -1; 0 0 1]
  :coltrans => [1 0 -1; 0 1 -1; 0 0 1]
  :rowC     => [1 0 0; 0 1 0; 0 0 1]
  :rank     => 3
  :colC     => [1 0 0; 0 1 0; 0 0 1]
  :signdet  => 1
  :rowtrans => [-2 62 -35; 1 -30 17; -3 97 -55]

julia> r[:rowtrans]*m*r[:coltrans]
3×3 Matrix{Int64}:
 1  0  0
 0  1  0
 0  0  3
```
"""
function NormalFormIntMat(mat::AbstractMatrix; TRIANG=false, REDDIAG=false, ROWTRANS=false, COLTRANS=false, INPLACE=false)
# if isempty(mat) mat=[Int[]] end
# println("mat=$mat opt=$opt")
  INPLACE=false # since the code for INPLACE can never work
  sig=1
  #Embed nxm mat in a (n+2)x(m+2) larger "id" matrix
  n,m=size(mat).+(2,2)
  A=fill(zero(eltype(mat)),n,m)
  A[2:end-1,2:end-1]=mat
  A[1,1]=1
  A[n,m]=1
  if ROWTRANS
    Q=zeros(eltype(mat),n,n)
    Q[1,1]=1
    C=one(Q)
  end
  if TRIANG && COLTRANS
    B=one(fill(zero(eltype(mat)),m,m))
    P=copy(B)
  end
  r=0
  c2=1
  rp=Int[]
  while m>c2
    c1=c2
    push!(rp,c1)
    r+=1
    if ROWTRANS Q[r+1,r+1]=1 end
    j=c1+1
    k=0
    while j<=m
      k=r+1
      while k<=n && A[r,c1]*A[k,j]==A[k,c1]*A[r,j] k+=1 end
      if k<=n
        c2=j
        j=m
      end
      j+=1
    end
    #Smith with some transforms..
    if TRIANG && ((COLTRANS || ROWTRANS) && c2<m)
        N=gcd(@view A[r:n,c2])
        L=vcat(c1+1:c2-1,c2+1:m-1)
        push!(L,c2)
        for j in L
            if j == c2
                b=A[r,c2]
                a=A[r,c1]
                for i in r+1:n
                    if b != 1
                        g=gcdx(b, A[i,c2])
                        b=g[1]
                        a=g[2]*a+g[3]*A[i,c1]
                    end
                end
                N=0
                for i in r:n
                  if N!=1 N=gcd(N, A[i,c1]-div(A[i,c2],b)*Int128(a)) end
                end
                N=Int(N)
            else
              c=mgcdex(N, A[r,j], @view A[r+1:n,j])
              b=A[r,j]+sum(c.*@view A[r+1:n,j])
              a=A[r,c1]+sum(c.*@view A[r+1:n,j])
            end
            t=mgcdex(N, a, [b])[1]
            tmp=A[r,c1]+t*A[r,j]
            if tmp==0 || tmp*A[k,c2]==(A[k,c1]+t*A[k,j])*A[r,c2]
                t+=1+mgcdex(N, a+t*b+b,[b])[1]
            end
            if t > 0
                for i in 1:n A[i,c1]+=t*A[i,j] end
                if COLTRANS B[j,c1]+=t end
            end
        end
        if A[r,c1]*A[k,c1+1]==A[k,c1]*A[r,c1+1]
            for i in 1:n A[i,c1+1]+=A[i,c2] end
            if COLTRANS B[c2,c1+1]=1 end
        end
        c2=c1+1
    end
    c=mgcdex(abs(A[r,c1]), A[r+1,c1], @view A[r+2:n,c1])
    for i in r+2:n
      if c[i-r-1]!=0
        A[r+1,:]+=c[i-r-1].*@view A[i,:]
        if ROWTRANS
          C[r+1,i]=c[i-r-1]
          Q[r+1,:]+=c[i-r-1].*@view Q[i,:]
        end
      end
    end
    i=r+1
    while A[r,c1]*A[i,c2]==A[i,c1]*A[r,c2] i+=1 end
    if i>r+1
      c=mgcdex(abs(A[r,c1]), A[r+1,c1]+A[i,c1], [A[i,c1]])[1]+1
      A[r+1,:]+=c.*@view A[i,:]
      if ROWTRANS
        C[r+1,i]+=c
        Q[r+1,:]+=c.*@view Q[i,:]
      end
    end
    g=bezout(A[r,c1], A[r,c2], A[r+1,c1], A[r+1,c2])
    sig*= sign(A[r,c1]*A[r+1,c2]-A[r,c2]*A[r+1,c1])
    A[r:r+1,:]=g.coeff*@view A[r:r+1,:]
    if ROWTRANS
      Q[r:r+1,:]=g.coeff*@view Q[r:r+1,:]
    end
    for i in r+2:n
      q=div(A[i,c1], A[r,c1])
      A[i,:]-=q.*@view A[r,:]
      if ROWTRANS Q[i,:]-=q.*@view Q[r,:] end
      q=div(A[i,c2], A[r+1,c2])
      A[i,:]-=q.*@view A[r+1,:]
      if ROWTRANS Q[i,:]-=q.* @view Q[r+1,:] end
    end
  end
  push!(rp,m) # length(rp)==r+1
  if n==m && r+1<n sig=0 end
  #smith w/ NO transforms - farm the work out...
  if TRIANG && !(ROWTRANS || COLTRANS)
    A=A[2:end-1,2:end-1]
    R=Dict(:normal => SNFofREF(A, INPLACE), :rank => r - 1)
    if n==m R[:signdet]=sig end
    return R
  end
  # hermite or (smith w/ column transforms)
  if (!TRIANG && REDDIAG) || (TRIANG && COLTRANS)
    for i in r:-1:1
      for j in i+1:r+1
        q=div(A[i,rp[j]]-mod(A[i,rp[j]], A[j,rp[j]]), A[j,rp[j]])
        A[i,:]-=q.*@view A[j,:]
        if ROWTRANS Q[i,:]-=q.*@view Q[j,:] end
      end
      if TRIANG && i<r
        for j in i+1:m
          q=div(A[i,j], A[i,i])
          for k in 1:i A[k,j]-=q*A[k,i] end
          if COLTRANS P[i,j]=-q end
        end
      end
    end
  end
  #Smith w/ row but not col transforms
  if TRIANG && ROWTRANS && !COLTRANS
    for i in 1:r-1
      t=A[i,i]
      A[i,:]=zero(A[i,:])
      A[i,i]=t
    end
    for j in r+1:m-1
      A[r,r]=gcd(A[r,r], A[r,j])
      A[r,j]=0
    end
  end
  #smith w/ col transforms
  if TRIANG && COLTRANS && r<m-1
    c=mgcdex(A[r,r], A[r,r+1], @view A[r,r+2:m-1])
    for j in r+2:m-1
        A[r,r+1]+=c[j-r-1]*A[r,j]
        B[j,r+1]=c[j-r-1]
        for i in 1:r P[i,r+1]+=c[j-r-1]*P[i,j] end
    end
    P[r+1,:].=zeros(Int,m)
    P[r+1,r+1]=1
    g=Gcdex(A[r,r], A[r,r+1])
    A[r,r]=g.gcd
    A[r,r+1]=0
    for i in 1:r+1
 #    t=P[i,r]
 #    P[i,r]=P[i,r] * g.coeff[1,1]+P[i,r+1] * g.coeff[1,2]
 #    P[i,r+1]=t * g.coeff[2,1]+P[i,r+1] * g.coeff[2,2]
      P[i,r:r+1]=g.coeff*P[i,r:r+1]
    end
    for j in r+2:m-1
      q=div(A[r,j], A[r,r])
      for i in 1:r+1 P[i,j]-=q*P[i,r] end
      A[r,j]=0
    end
    for i in r+2:m-1
      P[i,:].=0
      P[i,i]=1
    end
  end
  #row transforms finisher
  if ROWTRANS for i in r+2:n Q[i,i]=1 end end
  A=A[2:end-1,2:end-1]
  R=Dict{Symbol,Any}(:normal => A)
  if ROWTRANS
    R[:rowC]=C[2:end-1,2:end-1]
    R[:rowQ]=Q[2:end-1,2:end-1]
  end
  if TRIANG && COLTRANS
    R[:colC]=B[2:end-1,2:end-1]
    R[:colQ]=P[2:end-1,2:end-1]
  end
  R[:rank]=r-1
  if n==m R[:signdet]=sig end
  if ROWTRANS R[:rowtrans]=R[:rowQ]*R[:rowC] end
  if TRIANG && COLTRANS R[:coltrans]=R[:colC]*R[:colQ] end
  R
end

"""
`TriangulizedIntegerMat(mat)`
Changes  `mat` to be in  upper triangular form.

```julia-repl
julia> m=[1 15 28;4 5 6;7 8 9]
3×3 Matrix{Int64}:
 1  15  28
 4   5   6
 7   8   9

julia> MatInt.TriangulizedIntegerMat(m)
3×3 Matrix{Int64}:
 1  15  28
 0   1   1
 0   0   3

julia> n=MatInt.TriangulizedIntegerMatTransform(m)
Dict{Symbol, Any} with 6 entries:
  :rowQ     => [1 0 0; 1 -30 17; -3 97 -55]
  :normal   => [1 15 28; 0 1 1; 0 0 3]
  :rowC     => [1 0 0; 0 1 0; 0 0 1]
  :rank     => 3
  :signdet  => 1
  :rowtrans => [1 0 0; 1 -30 17; -3 97 -55]


julia> n[:rowtrans]*m==n[:normal]
true
```
"""
TriangulizedIntegerMat(mat)=NormalFormIntMat(mat;)[:normal]
TriangulizedIntegerMatTransform(mat)=NormalFormIntMat(mat;ROWTRANS=true)

"""
`hermite(m::AbstractMatrix{<:Integer};transforms=false)`

returns the Hermite normal form `H` of the integer matrix `m`; `H` is a row
equivalent  upper triangular  form such  that all  off-diagonal entries are
reduced modulo the diagonal entry of the column they are in. There exists a
unique unimodular matrix `Q` such that `QA==H`.

If   `transforms=true`  the  function  returns   a  tuple  with  components
`.normal=H` and `.rowtrans=Q`.

```julia-repl
julia> m=[1 15 28;4 5 6;7 8 9]
3×3 Matrix{Int64}:
 1  15  28
 4   5   6
 7   8   9

julia> hermite(m)
3×3 Matrix{Int64}:
 1  0  1
 0  1  1
 0  0  3

julia> n=hermite(m;transforms=true)
(normal = [1 0 1; 0 1 1; 0 0 3], rowtrans = [-2 62 -35; 1 -30 17; -3 97 -55], rank = 3, signdet = 1)

julia> n.rowtrans*m==n.normal
true
```
"""
function hermite(mat::AbstractMatrix{<:Integer};transforms=false)
  if !transforms NormalFormIntMat(mat;REDDIAG=true)[:normal]
  else res=NormalFormIntMat(mat;REDDIAG=true,ROWTRANS=true)
    (normal=res[:normal], rowtrans=res[:rowtrans], rank=res[:rank],
     signdet=get(res,:signdet,nothing))
  end
end

"""
`smith(m::AbstractMatrix{<:Integer})`

computes  the  Smith  normal  form  of  `m`, the unique equivalent diagonal
matrix  `S`  such  that  `Sᵢ,ᵢ`  divides  `Sⱼ,ⱼ`  for  `i≤j`.  There  exist
unimodular integer matrices `P, Q` such that `Q*m*P==S`.

If  `transforms=true`  the  function  returns  a  tuple  with  `.normal=S`,
`.rowtrans=Q` and `.coltrans=P`.

```julia-repl
julia> m=[1 15 28;4 5 6;7 8 9]
3×3 Matrix{Int64}:
 1  15  28
 4   5   6
 7   8   9

julia> smith(m)
3×3 Matrix{Int64}:
 1  0  0
 0  1  0
 0  0  3

julia> n=smith(m;transforms=true)
(normal = [1 0 0; 0 1 0; 0 0 3], coltrans = [1 0 -1; 0 1 -1; 0 0 1], rowtrans = [-2 62 -35; 1 -30 17; -3 97 -55], rank = 3, signdet = 1) 

julia> n.rowtrans*m*n.coltrans==n.normal
true
```
"""
function smith(mat::AbstractMatrix{<:Integer};transforms=false)
  if !transforms NormalFormIntMat(mat,TRIANG=true)[:normal]
  else res=NormalFormIntMat(mat;TRIANG=true,ROWTRANS=true,COLTRANS=true)
    (normal=res[:normal], coltrans=res[:coltrans], rowtrans=res[:rowtrans],
    rank=res[:rank], signdet=get(res,:signdet,nothing))
  end
end

"""
`baseInt(m::Matrix{<:Integer})`

returns  a list of vectors that forms a  basis of the integral row space of
`m`, i.e. of the set of integral linear combinations of the rows of `m`.

```julia-repl
julia> m=[1 2 7;4 5 6;10 11 19]
3×3 Matrix{Int64}:
  1   2   7
  4   5   6
 10  11  19

julia> baseInt(m)
3×3 Matrix{Int64}:
 1  2   7
 0  3   7
 0  0  15
```
"""
baseInt(m::Matrix{<:Integer})=BaseIntMat(m)

function BaseIntMat(mat)
  norm=NormalFormIntMat(mat;REDDIAG=true)
  norm[:normal][1:norm[:rank],:]
end

"""
If  `m` and `n` are matrices with integral entries, this function returns a
list  of vectors that forms a basis of the intersection of the integral row
spaces of `m` and `n`.

```julia-repl
julia> mat=[1 2 7;4 5 6;10 11 19]; nat=[5 7 2;4 2 5;7 1 4]
3×3 Matrix{Int64}:
 5  7  2
 4  2  5
 7  1  4

julia> MatInt.BaseIntersectionIntMats(mat,nat)
3×3 Matrix{Int64}:
 1  5  509
 0  6  869
 0  0  960
```
"""
function BaseIntersectionIntMats(M1, M2)
  M=vcat(M1, M2)
  r=TriangulizedIntegerMatTransform(M)
  T=r[:rowtrans][r[:rank]+1:size(M,1),axes(M1,1)]
  if !isempty(T) T*=M1 end
  BaseIntMat(T)
end

"""
`complementInt(full::Matrix{<:Integer}, sub::Matrix{<:Integer})`

 Let  `M` be the integral row module of  `full` and let `S`, a submodule of
 `M`,  be the integral row  module of `sub`. This  function computes a free
 basis for `M` that extends `S`, that is, if the dimension of `S` is `n` it
 determines  a basis  `B={b₁,…,bₘ}` for  `M`, as  well as `n` integers `xᵢ`
 such that the `n` vectors `sᵢ:=xᵢ⋅bᵢ` form a basis for `S`.

 It returns a named tuple with the following components:
  - `complement` a matrix whose lines are `bₙ₊₁,…,bₘ`.
  - `sub` a matrix whose lines are the `sᵢ` (a basis for `S`).
  - `moduli` the factors `xᵢ`.

```julia-repl
julia> m=one(rand(Int,3,3))
3×3 Matrix{Int64}:
 1  0  0
 0  1  0
 0  0  1

julia> n=[1 2 3;4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> complementInt(m,n)
(complement = [0 0 1], sub = [1 2 3; 0 3 6], moduli = [1, 3])
```
"""
function complementInt(full::Matrix{<:Integer}, sub::Matrix{<:Integer})
  F=BaseIntMat(full)
  if isempty(sub) || iszero(sub) return (complement=F,sub=sub,moduli=Int[]) end
  S=BaseIntersectionIntMats(F, sub)
  if S!=BaseIntMat(sub) error(sub," must be submodule of ",full) end
  M=vcat(F,S)
  T=Int.(inv(Rational.(TriangulizedIntegerMatTransform(M)[:rowtrans])))
  T=T[size(F,1)+1:end,axes(F,1)]
  r=smith(T;transforms=true)
  M=Int.(inv(Rational.(r.coltrans))*F)
  (complement=BaseIntMat(M[1+r.rank:end,:]), sub=r.rowtrans*T*F, 
   moduli=map(i->r.normal[i,i],1:r.rank))
end

"""
`leftnullspaceInt(m::Matrix{<:Integer})

returns  a matrix whose rows form a  basis of the integral leftnullspace of
`m`,  that is of elements  of the left nullspace  of `m` that have integral
entries.

```julia-repl
julia> m=[1 2 7;4 5 6;7 8 9;10 11 19;5 7 12]
5×3 Matrix{Int64}:
  1   2   7
  4   5   6
  7   8   9
 10  11  19
  5   7  12

julia> MatInt.leftnullspaceInt(m)
2×5 Matrix{Int64}:
 1  18   -9  2  -6
 0  24  -13  3  -7
```
"""
function leftnullspaceInt(mat)
  norm=TriangulizedIntegerMatTransform(mat)
  BaseIntMat(norm[:rowtrans][norm[:rank]+1:size(mat,1),:])
end

"""
If `mat` is a matrix with integral entries and `vec` a vector with integral
entries,  this function returns a vector `x` with integer entries that is a
solution  of the equation `x*mat=vec`. It returns `false` if no such vector
exists.

```julia-repl
julia> mat=[1 2 7;4 5 6;7 8 9;10 11 19;5 7 12]
5×3 Matrix{Int64}:
  1   2   7
  4   5   6
  7   8   9
 10  11  19
  5   7  12

julia> solutionmat(mat,[95,115,182])
5-element Vector{Rational{Int64}}:
  47//4
 -17//2
  67//4
   0//1
   0//1

julia> SolutionIntMat(mat,[95,115,182])
5-element Vector{Int64}:
  2285
 -5854
  4888
 -1299
     0
```
"""
function SolutionIntMat(mat, v)
  if iszero(mat)
    if iszero(v) return fill(0,length(mat))
    else return false
    end
  end
  norm=TriangulizedIntegerMatTransform(mat)
  t=norm[:rowtrans]
  rs=norm[:normal][1:norm[:rank],:]
  M=vcat(rs, permutedims(v))
  r=TriangulizedIntegerMatTransform(M)
  if r[:rank]==size(r[:normal],1) || r[:rowtrans][end,end]!=1
      return false
  end
  -permutedims(t[1:r[:rank],:])*r[:rowtrans][end,1:r[:rank]]
end
    
"""
This  function returns  a list  of length  two, its  first entry  being the
result  of a call  to `SolutionIntMat` with  same arguments, the second the
result of `NullspaceIntMat` applied to the matrix `mat`. The calculation is
performed faster than if two separate calls would be used.
```julia_repl
julia> mat=[1 2 7;4 5 6;7 8 9;10 11 19;5 7 12]
julia> MatInt.SolutionNullspaceIntMat(mat,[95,115,182])
2-element Vector{Array{Int64}}:
 [2285, -5854, 4888, -1299, 0]
 [1 18 … 2 -6; 0 24 … 3 -7]
```
"""
function SolutionNullspaceIntMat(mat, v)
  if iszero(mat)
    len=size(mat,1)
    if iszero(v) return [fill(0,max(0,len)), one(fill(0,len,len))]
    else return [false, one(fill(0,len,len))]
    end
  end
  norm=TriangulizedIntegerMatTransform(mat)
  kern=norm[:rowtrans][norm[:rank]+1:size(mat,1),:]
  kern=BaseIntMat(kern)
  t=norm[:rowtrans]
  rs=norm[:normal][1:norm[:rank],:]
  M=vcat(rs, permutedims(v))
  r=TriangulizedIntegerMatTransform(M)
  if r[:rank]==size(r[:normal],1) || r[:rowtrans][end,end]!=1
      return [false, kern]
  end
  [-permutedims(t[1:r[:rank],:])*r[:rowtrans][end,1:r[:rank]], kern]
end

function DeterminantIntMat(mat)
  sig=1
  n=size(mat,1)+2
  if n<22 return DeterminantMat(mat) end
  m=size(mat,2)+2
  if n!=m error("DeterminantIntMat: <mat> must be a square matrix") end
  A=fill(zero(eltype(mat)),m,n)
  A[2:end-1,2:end-1]=m
  A[1,1]=1
  A[n,m]=1
  r=0
  c2=1
  while m>c2
    r+=1
    c1=c2
    j=c1+1
    while j <= m
      k=r+1
      while k<=n && A[r,c1]*A[k,j]==A[k,c1]*A[r,j] k+=1 end
      if k<=n
        c2=j
        j=m
      end
      j+=1
    end
    c=mgcdex(abs(A[r,c1]), A[r+1,c1], A[r+2:n,c1])
    for i in r+2:n
      if c[i-r-1]!=0 A[r+1,:]+=A[i,:].*c[i-r-1] end
    end
    i=r+1
    while A[r,c1]*A[i,c2]==A[i,c1]*A[r,c2] i+=1 end
    if i>r+1
      c=mgcdex(abs(A[r,c1]), A[r+1,c1]+A[i,c1], [A[i,c1]])[1]+1
      A[r+1,:]+=A[i,:].* c
    end
    g=bezout(A[r,c1], A[r,c2], A[r+1,c1], A[r+1,c2])
    sig*=sign(A[r,c1]*A[r+1,c2]-A[r,c2]*A[r+1,c1])
    if sig == 0 return 0 end
    A[r:r+1,:]=g.coeff*A[r:r+1,:]
    for i in r+2:n
      q=div(A[i,c1], A[r,c1])
      A[i,:]-=A[r,:].*q
      q=div(A[i,c2], A[r+1,c2])
      A[i,:]-=q.*A[r+1,:]
    end
  end
  for i in 2:r+1 sig*=A[i,i] end
  sig
end

function IntersectionLatticeSubspace(m)
  m*=lcm(denominator.(vcat(m...)))
  r=smith_normal_form(m;transforms=true)
  for i in 1:length(r[:normal])
    if !iszero(r[:normal][i,:])
      r[:normal][i,:]//=maximum(abs.(r[:normal][i,:]))
    end
  end
  r[:rowtrans]^-1*r[:normal]*r[:coltrans]
end

"""
`DiaconisGraham(m, moduli)`

[Diaconis-Graham1999](biblio.htm#dg99) defined a normal form for generating
sets of abelian groups. Here `moduli` should be a list of positive integers
such  that `moduli[i+1]` divides `moduli[i]`  for all `i`, representing the
abelian group `A=Z/moduli[1]×…×Z/moduli[n]`. The integral matrix `m` should
have  `n` columns where `n=Length(moduli)`, and  each line (with the `i`-th
element  taken `mod moduli[i]`) represents an element of the group `A`, and
such that the set of lines of `m` generates `A`.

The  function returns 'false' if the set  of elements of `A` represented by
the  lines of `m` does not generate  `A`. Otherwise it returns a `Dict` `r`
with fields

`:normal`:  the Diaconis-Graham normal form, a  matrix of same shape as `m`
where  either the first `n` lines are the identity matrix and the remaining
lines  are `0`,  or `length(m)=n`  and `:normal`  differs from the identity
matrix only in the entry `:normal[n,n]`, which is prime to `moduli[n]`.

`:rowtrans`: a unimodular matrix such that  
`r[:normal]=map(v->mod.(v,moduli),r[:rowtrans]*m)`

Here is an example:

```julia-repl
julia> DiaconisGraham([3 0;4 1],[10,5])
Dict{Symbol, Any} with 2 entries:
  :normal   => [1 0; 0 2]
  :rowtrans => [-13 10; 4 -3]
```
"""
function DiaconisGraham(m, moduli)
  if moduli==[] return Dict{Symbol, Any}(:rowtrans=>[],:normal=>m) end
  if any(i->moduli[i]%moduli[i+1]!=0,1:length(moduli)-1)
    error("DiaconisGraham(m,moduli): moduli[i+1] should divide moduli[i] for all i")
  end
  r=hermite(m,transforms=true)
  res=r.rowtrans
  m=r.normal
  n=length(moduli)
  if size(m,1)>0 && n!=size(m,2)
    error("DiaconisGraham(m,moduli): length(moduli) should equal size(m,2)")
  end
  RowMod(m,moduli)=mod.(m,permutedims(moduli))
  for i in 1:min(n,size(m,1)-1)
    l=m[i,i]
    if m[i,i] != 1
      if gcd(m[i,i], moduli[i]) != 1 return false end
      l1=invmod(l, moduli[i])
      e=one(fill(0,size(m,1),size(m,1)))
      e[i:i+1,i:i+1]=[l1 l1-1;1-l*l1 (l+1)-l*l1]
      res=e*res
      m=RowMod(e*m,moduli)
    end
  end
  r=hermite(m;transforms=true)
  m=RowMod(r.normal, moduli)
  res=r.rowtrans*res
  if size(m,1)==n
    if m[n,n]>div(moduli[n], 2)
      m[n,n]=mod(-m[n,n], moduli[n])
      res[n,:]*=-1
    end
    l=m[n,n]
    if gcd(l,moduli[n])!=1 return false end
    l1=invmod(l, moduli[n])
    for i in 1:n-1
      if m[i,n]!=0
        e=one(fill(0,size(m,1),size(m,1)))
        e[[i,n],[i,n]]=[1 -m[i,n]*l1;0 1]
        res=e*res
        m=RowMod(e*m, moduli)
      end
    end
  end
  return Dict{Symbol, Any}(:rowtrans => res, :normal => m)
end

end
