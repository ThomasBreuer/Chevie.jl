chevieset(Symbol("2F4"), :NrConjugacyClasses, 11)
chevieset(Symbol("2F4"), :ClassInfo, function ()
        local res
        res = Dict{Symbol, Any}(:classtext => [[], [2, 3, 2], [1], [1, 2, 1, 3, 2, 1, 4, 3, 2, 1], [1, 2], [2], [1, 2, 1, 3, 2, 1, 3, 2], [1, 2, 3, 2], [1, 2, 1, 3, 2, 1, 3, 2, 4, 3, 2, 1], [1, 2, 1, 3, 2, 1, 3, 2, 4, 3, 2, 1, 3, 2, 4, 3, 2, 1], [1, 2, 1, 3, 2, 1]], :orders => [2, 8, 4, 24, 24, 8, 8, 12, 4, 8, 8], :classes => [72, 144, 288, 96, 96, 144, 72, 192, 24, 12, 12], :classnames => ["2a", "8a", "4a", "24a", "24b", "8a", "8b", "12a", "4b", "8c", "8d"])
        res[:classparams] = map(joindigits, res[:classtext])
        return res
    end)
chevieset(Symbol("2F4"), :CharInfo, function ()
        local res, resparams
        res = Dict{Symbol, Any}(:extRefl => [1, 9, 7, 10, 2], :charparams => [[1, 0], [1, 24], [4, 8], [9, 2], [9, 10], [6, 6, 1], [6, 6, 2], [12, 4], [4, 1], [4, 13], [16, 5]], :kondo => ["1_1", "1_4", "4_1", "9_1", "9_4", "6_1", "6_2", "12", "4_2", "4_5", "16"])
        resparams = ((chevieget(:F4, :CharInfo))())[:charparams]
        res[:charRestrictions] = map((x->begin
                        Position(resparams, x)
                    end), res[:charparams])
        res[:nrGroupClasses] = length(resparams)
        res[:b] = map((x->begin
                        x[2]
                    end), res[:charparams])
        res[:charnames] = map(exceptioCharName, res[:charparams])
        return res
    end)
chevieset(Symbol("2F4"), :cyclestructure, [[24], [4, nothing, nothing, nothing, nothing, nothing, 5], [2, nothing, 11], [nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, 2], [nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, 2], [4, nothing, nothing, nothing, nothing, nothing, 5], [nothing, nothing, nothing, nothing, nothing, nothing, 6], [nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, 4], [nothing, nothing, 12], [nothing, nothing, nothing, nothing, nothing, nothing, 6], [nothing, nothing, nothing, nothing, nothing, nothing, 6]])
chevieset(Symbol("2F4"), :generators, [perm"( 1,25)( 2, 5)( 6, 9)( 7,11)(10,14)(12,15)(16,18)(21,23)(26,29)(30,33)(31,35)(34,38)(36,39)(40,42)(45,47)", perm"( 1, 5)( 2,26)( 3, 7)( 8,12)( 9,13)(14,17)(18,20)(19,21)(25,29)(27,31)(32,36)(33,37)(38,41)(42,44)(43,45)", perm"( 2, 6)( 3,27)( 4, 8)( 5, 9)(12,16)(15,18)(17,19)(20,22)(26,30)(28,32)(29,33)(36,40)(39,42)(41,43)(44,46)", perm"( 3, 8)( 4,28)( 6,10)( 7,12)( 9,14)(11,15)(13,17)(22,24)(27,32)(30,34)(31,36)(33,38)(35,39)(37,41)(46,48)"])
chevieset(Symbol("2F4"), :phi, perm"( 1, 4)( 2, 3)( 5, 8)( 6, 7)( 9,12)(10,11)(13,16)(14,15)(17,18)(19,20)(21,22)(23,24)(25,28)(26,27)(29,32)(30,31)(33,36)(34,35)(37,40)(38,39)(41,42)(43,44)(45,46)(47,48)")
chevieset(Symbol("2F4"), :CartanMat, [[2, -1, 0, 0], [-1, 2, -(root(2)), 0], [0, -(root(2)), 2, -1], [0, 0, -1, 2]])
chevieset(Symbol("2F4"), :ClassParameter, function (w,)
        local x, l
        if length(w) == 1
            if CycleStructurePerm(x * chevieget(Symbol("2F4"), :phi)) == [2, nothing, 11]
                return (chevieget(Symbol("2F4"), :classparams))[3]
            else
                return (chevieget(Symbol("2F4"), :classparams))[6]
            end
        else
            l = map(length, chevieget(Symbol("2F4"), :WordsClassRepresentatives))
            return (chevieget(Symbol("2F4"), :classparams))[Position(l, length(w))]
        end
    end)
chevieset(Symbol("2F4"), :HeckeCharTable, function (param, sqrtparam)
        local v, q, tbl
        q = -((param[1])[1]) // (param[1])[2]
        if !(sqrtparam[1] !== nothing)
            v = GetRoot(q, 2, "CharTable(Hecke(2F4))")
        else
            v = -(sqrtparam[1]) // (param[1])[2]
        end
        tbl = Dict{Symbol, Any}(:identifier => "H(2F4)", :parameter => [q, q, q, q], :sqrtparameter => [v, v, v, v], :cartan => chevieget(Symbol("2F4"), :CartanMat), :size => 1152, :irreducibles => [[1, v ^ 6, v ^ 2, v ^ 20, v ^ 4, v ^ 2, v ^ 16, v ^ 8, v ^ 24, v ^ 36, v ^ 12], [1, -1, -1, 1, 1, -1, 1, 1, 1, 1, 1], [2, v ^ 6 - 1, v ^ 2 - 1, -(v ^ 10), -(v ^ 2), v ^ 2 - 1, v ^ 10 + v ^ 6, -(v ^ 4), 2 * v ^ 12, 2 * v ^ 18, 2 * v ^ 6], [1, v ^ 6, -1, 0, 0, v ^ 2, v ^ 12 - 2 * v ^ 10, 0, -3 * v ^ 16, 3 * v ^ 24, 3 * v ^ 8], [-1, 1, -(v ^ 2), 0, 0, 1, 2 * v ^ 6 - v ^ 4, 0, 3 * v ^ 8, -3 * v ^ 12, -3 * v ^ 4], [0, 0, 0, v ^ 10, v ^ 2, 0, 2 * v ^ 8, -(v ^ 4), -4 * v ^ 12, -2 * v ^ 18, -2 * v ^ 6], [-2, -(v ^ 6) + 1, -(v ^ 2) + 1, v ^ 10, v ^ 2, -(v ^ 2) + 1, (v ^ 10 - 2 * v ^ 8) + v ^ 6, -(v ^ 4), 2 * v ^ 12, 4 * v ^ 18, 4 * v ^ 6], [2, v ^ 6 - 1, v ^ 2 - 1, v ^ 10, v ^ 2, v ^ 2 - 1, -(v ^ 10) - v ^ 6, -(v ^ 4), 2 * v ^ 12, -2 * v ^ 18, -2 * v ^ 6], [0, -(root(2)) * v ^ 3, 0, -(root(2)) * v ^ 15, root(2) * v ^ 3, root(2) * v, root(2) * (v ^ 13 - v ^ 11), 0, 0, -2 * root(2) * v ^ 27, 2 * root(2) * v ^ 9], [0, -(root(2)) * v ^ 3, 0, root(2) * v ^ 5, -(root(2)) * v, root(2) * v, root(2) * (v ^ 5 - v ^ 3), 0, 0, 2 * root(2) * v ^ 9, -2 * root(2) * v ^ 3], [0, 0, 0, root(2) * v ^ 10, -(root(2)) * v ^ 2, 0, root(2) * ((v ^ 10 - 2 * v ^ 8) + v ^ 6), 0, 0, -4 * root(2) * v ^ 18, 4 * root(2) * v ^ 6]] * v ^ 0, :irredinfo => chevieget(Symbol("2F4"), :IrredInfo))
        Inherit(tbl, (chevieget(Symbol("2F4"), :ClassInfo))())
        tbl[:centralizers] = map((x->begin
                        div(tbl[:size], x)
                    end), tbl[:classes])
        tbl = ((CHEVIE[:compat])[:MakeCharacterTable])(tbl)
        ((CHEVIE[:compat])[:AdjustHeckeCharTable])(tbl, param)
        return tbl
    end)
chevieset(Symbol("2F4"), :PhiFactors, [1, -1, 1, -1])
chevieset(Symbol("2F4"), :Representation, function (i,)
        return (chevieget(Symbol("2F4"), :HeckeRepresentation))(map((x->begin
                            [1, -1]
                        end), 1:4), [1, 1, 1, 1], i)
    end)
chevieset(Symbol("2F4"), :HeckeRepresentation, function (para, rootpara, i)
        local v, res
        if rootpara[1] !== nothing
            v = rootpara[1] * (para[1])[2]
        else
            v = GetRoot(-((para[1])[1]) // (para[1])[2], 2, "Representation(Hecke(2F4),[", i, "])")
        end
        res = [Dict{Symbol, Any}(:gens => 1, :F => [[1]]), Dict{Symbol, Any}(:gens => 4, :F => [[1]]), Dict{Symbol, Any}(:gens => 9, :F => Permuted(IdentityMat(4), perm"(1,4)")), Dict{Symbol, Any}(:gens => 10, :F => Permuted(IdentityMat(9), perm"(1,9)(2,6)(4,8)(5,7)")), Dict{Symbol, Any}(:gens => 13, :F => -(Permuted(IdentityMat(9), perm"(1,9)(2,6)(4,8)(5,7)"))), Dict{Symbol, Any}(:gens => 14, :F => Permuted(IdentityMat(6), perm"(1,3)(2,5)(4,6)")), Dict{Symbol, Any}(:gens => 15, :F => -([[0, 0, 0, 0, 0, 2], [0, 0, 0, 0, 1, 0], [0, 0, 1, 0, 0, 0], [0, 0, 0, 1, 0, 0], [0, 1, 0, 0, 0, 0], [1 // 2, 0, 0, 0, 0, 0]])), Dict{Symbol, Any}(:gens => 16, :F => Permuted(IdentityMat(12), perm"(1,12)(2,5)(3,10)(4,9)(7,11)")), Dict{Symbol, Any}(:gens => 17, :F => -([[0, 0, 0, 1], [0, 0, 1, 0], [0, 2, 0, 0], [2, 0, 0, 0]]) // root(2)), Dict{Symbol, Any}(:gens => 20, :F => [[0, 0, 0, 2], [0, 0, 2, 0], [0, 1, 0, 0], [1, 0, 0, 0]] // root(2)), Dict{Symbol, Any}(:gens => 25, :F => -([[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0], [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0], [0, 0, 0, -1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0], [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]) // root(2))]
        res = res[i]
        res[:gens] = -((para[1])[2]) * WGraphToRepresentation(4, (chevieget(:F4, :WGraph))(res[:gens]), v) * v ^ 0
        return res
    end)
(CHEVIE[:families])[:X2] = Dict{Symbol, Any}(:name => "X_2", :fourierMat => root(2) // 2 * [[-1, -1], [-1, 1]], :eigenvalues => [E(8, 3), -(E(8))], :charLabels => ["1", "2"], :special => 1, :sh => [1, -1])
chevieset(Symbol("2F4"), :sparseFakeDegrees, [[1, 0], [1, 24], [1, 8, 1, 16], [1, 2, -1, 4, 1, 8, -1, 12, 1, 14], [-1, 10, 1, 12, -1, 16, 1, 20, -1, 22], [1, 6, -1, 8, -1, 16, 1, 18], [-1, 6, 1, 8, -2, 12, 1, 16, -1, 18], [1, 4, 1, 20], [1, 1, -1, 5, 1, 7, -1, 11], [1, 13, -1, 17, 1, 19, -1, 23], [-1, 5, 2, 9, -1, 11, -1, 13, 2, 15, -1, 19]])
chevieset(Symbol("2F4"), :UnipotentCharacters, function ()
        local res
        return Dict{Symbol, Any}(:harishChandra => [Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "I", :indices => [1, 2], :bond => 8, :rank => 2), :parameterExponents => [2, 4], :levi => [], :eigenvalue => 1, :cuspidalName => "", :charNumbers => [1, 5, 4, 2, 3, 20, 19]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [1], :rank => 1), :parameterExponents => [12], :levi => [2, 3], :eigenvalue => E(8, 3), :cuspidalName => "{}^2B_2[1,3]", :charNumbers => [10, 9]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [1], :rank => 1), :parameterExponents => [12], :levi => [2, 3], :eigenvalue => -(E(8)), :cuspidalName => "{}^2B_2[1,5]", :charNumbers => [13, 12]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [6], :eigenvalue => -(E(3)), :cuspidalName => "{}^2F_4[-\\zeta_3]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [7], :eigenvalue => -1, :cuspidalName => "{}^2F_4[-1]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [8], :eigenvalue => -1, :cuspidalName => "{}^2F_4^2[-1]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [11], :eigenvalue => -1, :cuspidalName => "{}^2F_4^3[-1]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [14], :eigenvalue => -(E(4)), :cuspidalName => "{}^2F_4[-i]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [15], :eigenvalue => E(4), :cuspidalName => "{}^2F_4[i]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [16], :eigenvalue => E(4), :cuspidalName => "{}^2F_4^2[i]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [17], :eigenvalue => -(E(4)), :cuspidalName => "{}^2F_4^2[-i]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [18], :eigenvalue => -(E(3, 2)), :cuspidalName => "{}^2F_4[-\\zeta_3^2]"), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :parameterExponents => [], :charNumbers => [21], :eigenvalue => -1, :cuspidalName => "{}^2F_4^4[-1]")], :families => [Family("C1", [1]), Family("C1", [2]), Family("C1", [4]), Family(Dict{Symbol, Any}(:name => "C''_1", :group => "C1", :charLabels => [""], :fourierMat => [[-1]], :eigenvalues => [1], :sh => [1]), [5]), Family("X2", [9, 12]), Family("X2", [10, 13]), Family(Dict{Symbol, Any}(:name => "sub D(\\tilde S_4)", :fourierMat => Permuted(TransposedMat([[3, 0, -6, 3, root(2) * 3, root(2) * 3, root(2) * 3, root(2) * 3, 3, -3, 0, 0, 0], [3, 0, -6, 3, -(root(2)) * 3, -(root(2)) * 3, -(root(2)) * 3, -(root(2)) * 3, 3, -3, 0, 0, 0], [6, 0, 0, 6, 0, 0, 0, 0, -6, 6, 0, 0, 0], [-6, -4, -4, 2, 0, 0, 0, 0, -6, -2, -4, -4, 0], [-3, 4, -2, 1, -(root(2)) * 3, root(2) * 3, root(2) * 3, -(root(2)) * 3, -3, -1, 4, 4, 0], [-3, 4, -2, 1, root(2) * 3, -(root(2)) * 3, -(root(2)) * 3, root(2) * 3, -3, -1, 4, 4, 0], [-3, 0, 0, 3, root(2) * 3, -(root(2)) * 3, root(2) * 3, -(root(2)) * 3, 3, 3, 0, 0, 6], [-3, 0, 0, 3, root(2) * 3, root(2) * 3, -(root(2)) * 3, -(root(2)) * 3, 3, 3, 0, 0, -6], [-3, 0, 0, 3, -(root(2)) * 3, -(root(2)) * 3, root(2) * 3, root(2) * 3, 3, 3, 0, 0, -6], [-3, 0, 0, 3, -(root(2)) * 3, root(2) * 3, -(root(2)) * 3, root(2) * 3, 3, 3, 0, 0, 6], [0, 4, 4, 4, 0, 0, 0, 0, 0, -4, 4, -8, 0], [0, 4, 4, 4, 0, 0, 0, 0, 0, -4, -8, 4, 0], [0, -8, 4, 4, 0, 0, 0, 0, 0, -4, 4, 4, 0]] // 12), perm"(8,13)"), :special => 4, :charLabels => ["z,\\chi_3", "t_1t_2,1", "z,\\chi_2", "1,1", "zt_1t_2t_3,1", "t_1t_2t_3,\\zeta_8^6", "t_1t_2t_3,\\zeta_8^2", "t_1t_3,\\zeta_8^6", "z,\\chi'_3", "z,\\varepsilon", "t_1t_2,\\zeta_6^4", "t_1t_2,\\zeta_6^2", "zt_1t_2t_3,\\zeta_8^4"], :almostCharLabels => ["t_1t_3,\\zeta_8", "t_1t_3,\\zeta_8^3", "t_1,\\zeta_4", "1,\\psi_4", "1,\\psi'_2", "1,\\psi_2", "t_1t_2t_3,\\zeta_8^5", "t_1t_2t_3,\\zeta_8^3", "t_1t_2t_3,\\zeta_8^7", "t_1t_2t_3,\\zeta_8", "z t_1t_2,\\zeta_6", "z t_1t_2,\\zeta_6^5", "z t_1t_2,\\zeta_6^3"], :explanation => Concatenation("subcategory of Drinfeld double of \$\\tilde\\frakS_4\n\$", "see Ph. D. Thesis of Abel Lacabanne, section 5[:2]\n"), :eigenvalues => [1, 1, 1, -1, -1, -1, -(E(4)), E(4), E(4), -(E(4)), -(E(3)), -(E(3, 2)), -1], :sh => [1, 1, 1, 1, 1, E(4), -(E(4)), -1, 1, 1, E(3), E(3, 2), -1], :ennola => [2, 1, 3, 4, 6, 5, 10, 9, 8, 7, 11, 12, 13]), [3, 19, 20, 7, 8, 11, 14, 15, 16, 17, 6, 18, 21])], :almostHarishChandra => [Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:orbit => [Dict{Symbol, Any}(:series => "F", :cartanType => root(2), :indices => 1:4, :rank => 4)], :twist => perm"(1,4)(2,3)"), :levi => [], :eigenvalue => 1, :cuspidalName => "", :charNumbers => [1, 2, 3, 4, 5, 19, 20, 7, 9, 10, 8]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:orbit => [Dict{Symbol, Any}(:series => "B", :indices => [1, 4], :cartanType => root(2), :rank => 2)], :twist => perm"(1,2)"), :levi => [2, 3], :eigenvalue => -1, :cuspidalName => "B_2", :charNumbers => [12, 13, 15]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => -1, :cuspidalName => "F_4[-1]", :charNumbers => [21]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => -(E(4)), :cuspidalName => "F_4[-i]", :charNumbers => [14]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => E(4), :cuspidalName => "F_4[i]", :charNumbers => [11]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => E(3), :cuspidalName => "F_4[\\zeta_3]", :charNumbers => [6]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => E(3, 2), :cuspidalName => "F_4[\\zeta_3^2]", :charNumbers => [18]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => 1, :cuspidalName => "F_4[1]", :charNumbers => [16]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:4, :eigenvalue => 1, :cuspidalName => "F_4^2[1]", :charNumbers => [17])], :a => [0, 24, 4, 2, 10, 4, 4, 4, 1, 13, 4, 1, 13, 4, 4, 4, 4, 4, 4, 4, 4], :A => [0, 24, 20, 14, 22, 20, 20, 20, 11, 23, 20, 11, 23, 20, 20, 20, 20, 20, 20, 20, 20])
    end)
