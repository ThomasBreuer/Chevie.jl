nspets=map(i->ComplexReflectionGroup(i),
           [5,7,9,10,11,12,16,17,18,20,22,13,15,21])

l2=[
  (ComplexReflectionGroup,4),
  (ComplexReflectionGroup,6),
  (ComplexReflectionGroup,8),
  (ComplexReflectionGroup,14),
  (ComplexReflectionGroup,24),
  (ComplexReflectionGroup,25),
  (ComplexReflectionGroup,26),
  (ComplexReflectionGroup,27),
  (ComplexReflectionGroup,29),
  (ComplexReflectionGroup,32),
  (ComplexReflectionGroup,33),
  (ComplexReflectionGroup,3,1,2),
  (ComplexReflectionGroup,3,3,3),
  (ComplexReflectionGroup,3,3,4),
  (ComplexReflectionGroup,4,4,3),
  (coxgroup,:A,1),
  (coxgroup,:A,2),
  (coxgroup,:A,3),
  (coxgroup,:A,4),
  (coxgroup,:A,5),
  (coxgroup,:A,6),
  (coxgroup,:A,7),
  (coxgroup,:B,2),
  (coxgroup,:B,3),
  (coxgroup,:B,4),
  (coxgroup,:B,5),
  (coxgroup,:B,6),
  (coxgroup,:B,7),
  (coxgroup,:C,3),
  (coxgroup,:C,4),
  (coxgroup,:C,5),
  (coxgroup,:C,6),
  (coxgroup,:C,7),
  (coxgroup,:D,4),
  (coxgroup,:E,6),
  (coxgroup,:E,7),
  (coxgroup,:E,8),
  (coxgroup,:F,4),
  (coxgroup,:G,2),
  (coxgroup,:H,3),
  (coxgroup,:H,4),
  (coxgroup,:I,2,5),
  (coxgroup,:D,5),
  (coxgroup,:D,6),
  (coxgroup,:D,7),  #ch
  (ComplexReflectionGroup,34), #ch
  (coxgroup,),
]

l3=[
  (rootdatum,:psu,3),
  (rootdatum,Symbol("2B2")),
  (rootdatum,Symbol("2G2")),
  (rootdatum,Symbol("2I"),5),
  (rootdatum,Symbol("2I"),8),
  (rootdatum,:psu,4),
  (rootdatum,Symbol("3D4")),
  (rootdatum,:psu,5),
  (rootdatum,Symbol("pso-"),8),
  (rootdatum,:psu,6),
  (rootdatum,Symbol("2F4")),
  (rootdatum,:psu,7),
  (rootdatum,Symbol("pso-"),10),
  (rootdatum,Symbol("2E6")),
  (rootdatum,:psu,8),
  (rootdatum,Symbol("pso-"),12),
  (rootdatum,Symbol("pso-"),14),
]

spets_ex=map(l2)do x
  printc("creating ",x,"\n")
  x[1](x[2:end]...)
end

twisted=map(l3) do x
  printc("creating ",x,"\n")
  x[1](x[2:end]...)
end

function chartab(l)
  for g in l
    printc("creating CharTable(",g,")\n")
    show(IOContext(stdout,:limit=>true),CharTable(g))
  end
end

function uch(l)
  for g in l
    printc("creating UnipotentCharacters(",g,")\n")
    show(IOContext(stdout,:limit=>true),UnipotentCharacters(g))
  end
end

function check_relations(H::HeckeAlgebra,t)
  W=H.W
  res=true
  for i in eachindex(gens(W))
    e=prod(q->(t[i]-q.*one(t[i])),H.para[i])
    if !iszero(e)
      println("#I  Error in ",Ordinal(i)," parameter relation");
      res=false
    end
  end
  for (l,r) in braid_relations(W)
    e=prod(t[l])-prod(t[r])
    if !iszero(e)
      println("#I Error in relation ",l,"=",r)
      res=false
    end
  end
  res
end

function FindRepresentation(W,gr,check=false)
  O=W
  if O isa HeckeAlgebra W=O.W end
  t=map(x->restriction(W,x),classinfo(W)[:classtext])
  l=1:length(t)
  l=sort(l,by=i->length(t[i]))
  t=t[l]
  ct=CharTable(O).irr
  pos=1:length(l)
  gens=gr
  for (i,w) in enumerate(t)
    r=traces_words_mats(gens,[w])[1]
#   println("w=$w r=$r")
#   if O isa HeckeAlgebra r=r*O.unit end
    pos=filter(j->iszero(ct[j,l[i]]-r),pos)
    if !check && length(pos)==1 return pos[1]
    elseif isempty(pos) return false
    end
  end
  if length(pos)==1 return pos[1]
  elseif length(pos)==0 return false
  else error("characters $pos are equal")
  end
end

function CheckRepresentations(W,l=Int[])
  O=W
  if W isa HeckeAlgebra
    H=W
    W=H.W
  else H=hecke(W)
  end
  cl=classinfo(W)[:classtext]
  ct=CharTable(O).irr
  if isempty(l) l=1:length(cl) end
  for i in l
    print("Representation #$i");
    gr=representation(O,i)
    if gr==false println("=false")
    else
      r=gr
      print(" dim:",size(r[1]),"...")
      check_relations(H,r)
      pos=FindRepresentation(O,gr,true)
      if pos==i println("")
      elseif !isnothing(pos) println("character found at ",pos)
      else println("character does not match")
	pos=TransposedMat([ct[i],traces_words_mats(gr,cl)])
	f=List(pos,x->x[1]!=x[2])
	pos=List(pos,x->List(x,FormatGAP))
	Print(FormatTable(ListBlist(pos,f),
	  rec(rowLabels=ListBlist(1:Length(pos),f),
	      columnLabels=["is","should be"])))
      end
    end
  end
end

function CheckLusztigInduction(WF)
  if !(WF isa Spets) WF=spets(WF) end
  W=Group(WF)
  for J in filter(x->length(x)<length(gens(W)),parabolic_representatives(W))
    CheckLusztigInduction(WF,J)
  end
end

function CheckLusztigInduction(WF,J::AbstractVector{<:Integer})
  for L in twistings(WF,J) CheckLusztigInduction(WF,L) end
end

function CheckLusztigInduction(WF,L)
  if L.phi==WF.phi print("Split ") end
  printc("Lusztig Induction from ",L," to ",WF,"\n")
  t=LusztigInductionTable(L,WF)
  if isnothing(t) return end
  if haskey(t.prop,:scalars) 
    println("************** scalars=",t.prop[:scalars]) 
  end
  if L.phi==WF.phi
    h=Lusztig.HCInductionTable(L,WF)
    if h.scalar!=t.scalar error("HC!=Lusztig") end
  end
  uh=UnipotentCharacters(L)
  uw=UnipotentCharacters(WF)
  q=Pol([1],1)
  nh=charnames(uh)
  hd=degrees(uh,q)
  ud=degrees(uw,q)
  index=generic_order(WF,q)/generic_order(L,q)
  index*=q^-index.v
  index*=generic_sign(L)/generic_sign(WF)
  pred=hd.*index
  ind=map(x->UniChar(WF,x),eachcol(t.scalar))
  for j in 1:length(hd)
    if pred[j]!=degree(ind[j])
     printc("!!  R_",L,"^",WF,"(",charnames(uh)[j],")=",ind[j],"\n!!",
        CycPol(degree(ind[j]))," instead of ",CycPol(pred[j]),
        " quotient ", CycPol(degree(ind[j]))*inv(CycPol(pred[j])),"\n")
    end
  end
  f=fusion_conjugacy_classes(L,WF)
#  Check Mackey with Tori
  c=map((a,b)->a//b,CharTable(WF).centralizers[f],CharTable(L).centralizers)
  u=Uch.DLCharTable(L)
  rhs=toM(map(1:HasType.NrConjugacyClasses(WF))do i
    l=findall(==(i),f)
    return isempty(l) ? u[1,:].*0 : sum(j->u[j,:].*c[j],l)
  end)
  rhs=Dict{Symbol,Any}(:scalar=>rhs, :u=>L,:g=>WF,
    :uNames=>UnipotentCharacters(L).prop[:TeXCharNames],
    :gNames=>classinfo(WF)[:classnames])
  m=copy(rhs)
  m[:scalar]=Uch.DLCharTable(WF)*t.scalar
  if m[:scalar]!=rhs[:scalar] error("tables differ",m[:scalar],rhs[:scalar]) end
  # Check transitivity with RTL
  if Uch.DLCharTable(L)*permutedims(t.scalar)!=Uch.DLCharTable(WF)[f,:]
     error("transitivity with RTL")
  end
end

