
chevieset(Symbol("2E6"), :NrConjugacyClasses, 25)
chevieset(Symbol("2E6"), :ClassInfo, function ()
        local res
        res = Dict{Symbol, Any}(:classtext => [[1, 2, 3, 1, 4, 2, 3, 1, 4, 3, 5, 4, 2, 3, 1, 4, 3, 5, 4, 2, 6, 5, 4, 2, 3, 1, 4, 3, 5, 4, 2, 6, 5, 4, 3, 1], [], [3, 4, 3, 5, 4, 3], [1, 2, 4, 3, 1, 5, 4, 3, 6, 5, 4, 3], [1, 2, 3, 1, 4, 3, 1, 5, 4, 3, 1, 6, 5, 4, 3, 1], [2, 3, 4, 2, 3, 4, 6, 5, 4, 2, 3, 4, 5, 6], [1, 4, 2, 3, 1, 4, 3, 5, 4, 2, 3, 1, 4, 6, 5, 4, 3, 1], [1, 2], [4, 5, 4, 2, 3, 1, 4, 5], [4, 2, 5, 4, 2, 3, 4, 5, 6, 5, 4, 2, 3, 4, 5, 6], [2, 4], [1, 5], [5, 4], [1, 2, 5, 4], [1, 2, 3, 1, 4, 3], [1, 3, 1, 4, 3, 1, 5, 4, 3, 1, 6, 5, 4, 3, 1], [2], [1], [2, 3, 4, 3, 5, 4, 3], [1, 3, 4, 3, 5, 4, 3], [1, 3, 1, 4, 3], [1, 2, 5], [2, 5, 4], [1, 5, 4], [1, 2, 4]], :classnames => ["A_0", "4A_1", "2A_1", "3A_2", "A_2", "2A_2", "D_4(a_1)", "A_3+A_1", "A_4", "E_6(a_2)", "D_4", "A_5+A_1", "A_2+2A_1", "E_6(a_1)", "E_6", "A_1", "3A_1", "A_3+2A_1", "A_3", "A_2+A_1", "2A_2+A_1", "A_5", "D_5", "A_4+A_1", "D_5(a_1)"], :classes => [1, 45, 270, 80, 240, 480, 540, 3240, 5184, 720, 1440, 1440, 2160, 5760, 4320, 36, 540, 540, 1620, 1440, 1440, 4320, 6480, 5184, 4320])
        res[:classparams] = res[:classnames]
        return res
    end)
chevieset(Symbol("2E6"), :CharInfo, function ()
        return (chevieget(:E6, :CharInfo))()
    end)
chevieset(Symbol("2E6"), :cyclestructure, [[], [36], [30], [nothing, 24], [nothing, 20], [nothing, 22], [nothing, nothing, 18], [5, nothing, 15], [nothing, nothing, nothing, 14], [nothing, nothing, nothing, nothing, 12], [6, nothing, nothing, nothing, 10], [3, nothing, nothing, nothing, 11], [6, 4, nothing, nothing, 8], [nothing, nothing, nothing, nothing, nothing, nothing, nothing, 8], [nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, 6], [21], [35], [6, nothing, 15], [4, nothing, 15], [3, 8, nothing, nothing, 6], [3, 10, nothing, nothing, 6], [2, nothing, nothing, nothing, 11], [nothing, nothing, nothing, nothing, nothing, nothing, 9], [1, nothing, nothing, 6, nothing, nothing, nothing, nothing, 4], [nothing, nothing, 3, nothing, 2, nothing, nothing, nothing, nothing, nothing, 4]])
chevieset(Symbol("2E6"), :generators, [perm"(1,37)(3,7)(9,12)(13,17)(15,18)(19,22)(21,23)(24,26)(25,27)(28,30)(31,33)(39,43)(45,48)(49,53)(51,54)(55,58)(57,59)(60,62)(61,63)(64,66)(67,69)", perm"( 2,38)( 4, 8)( 9,13)(10,14)(12,17)(15,19)(16,20)(18,22)(21,25)(23,27)(35,36)(40,44)(45,49)(46,50)(48,53)(51,55)(52,56)(54,58)(57,61)(59,63)(71,72)", perm"( 1, 7)( 3,39)( 4, 9)( 8,13)(10,15)(14,19)(16,21)(20,25)(26,29)(30,32)(33,34)(37,43)(40,45)(44,49)(46,51)(50,55)(52,57)(56,61)(62,65)(66,68)(69,70)", perm"( 2, 8)( 3, 9)( 4,40)( 5,10)( 7,12)(11,16)(19,24)(22,26)(25,28)(27,30)(34,35)(38,44)(39,45)(41,46)(43,48)(47,52)(55,60)(58,62)(61,64)(63,66)(70,71)", perm"( 4,10)( 5,41)( 6,11)( 8,14)( 9,15)(12,18)(13,19)(17,22)(28,31)(30,33)(32,34)(40,46)(42,47)(44,50)(45,51)(48,54)(49,55)(53,58)(64,67)(66,69)(68,70)", perm"( 5,11)( 6,42)(10,16)(14,20)(15,21)(18,23)(19,25)(22,27)(24,28)(26,30)(29,32)(41,47)(46,52)(50,56)(51,57)(54,59)(55,61)(58,63)(60,64)(62,66)(65,68)"])
chevieset(Symbol("2E6"), :phi, perm"(1,42)(2,38)(3,41)(4,40)(5,39)(6,37)(7,47)(8,44)(9,46)(10,45)(11,43)(12,52)(13,50)(14,49)(15,51)(16,48)(17,56)(18,57)(19,55)(20,53)(21,54)(22,61)(23,59)(24,60)(25,58)(26,64)(27,63)(28,62)(29,67)(30,66)(31,65)(32,69)(33,68)(34,70)(35,71)(36,72)")
chevieset(Symbol("2E6"), :CartanMat, [[2, 0, -1, 0, 0, 0], [0, 2, 0, -1, 0, 0], [-1, 0, 2, -1, 0, 0], [0, -1, -1, 2, -1, 0], [0, 0, 0, -1, 2, -1], [0, 0, 0, 0, -1, 2]])
chevieset(Symbol("2E6"), :vpolheckeirreducibles, [[[[1], 72], [[1], 0], [[1], 12], [[1], 24], [[1], 32], [[1], 28], [[1], 36], [[1], 4], [[1], 16], [[1], 32], [[1], 4], [[1], 4], [[1], 4], [[1], 8], [[1], 12], [[1], 30], [[1], 2], [[1], 2], [[1], 14], [[1], 14], [[1], 10], [[1], 6], [[1], 6], [[1], 6], [[1], 6]], [[[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0], [[-1], 0]], [[[-10], 36], [[6], 0], [[-3, 0, 4, 0, -3], 4], [[-1], 12], [[-1, 0, 0, 0, 4, 0, 0, 0, -1], 12], [[-1, 0, -2, 0, -1], 12], [[-2], 18], [[2, 0, -2, 0, 2], 0], [[], 0], [[3], 16], [[1, 0, -2, 0, 1], 0], [[1, 0, -2, 0, 1], 0], [[-2], 2], [[-1], 4], [[1], 6], [[5, 0, 0, 0, 0, 0, -5], 12], [[-3, 0, 3], 0], [[-3, 0, 3], 0], [[-1, 0, 1], 6], [[1, 0, -2, 0, 2, 0, -1], 4], [[2, 0, -2], 4], [[-1, 0, 1, 0, -1, 0, 1], 0], [[], 0], [[], 0], [[-1, 0, 1, 0, -1, 0, 1], 0]], [[[-6], 60], [[2], 0], [[-3, 0, 0, 0, 1], 8], [[3], 20], [[-4, 0, 1], 26], [[-2, 0, 2], 22], [[-2], 30], [[-1, 0, 1], 2], [[-1], 12], [[-2, 0, 1], 26], [[-1], 2], [[2], 4], [[1], 4], [[], 0], [[1], 10], [[-5, 0, 0, 0, 0, 0, 1], 24], [[-1, 0, 1], 0], [[2], 2], [[-2], 10], [[-2, 0, 0, 0, 1], 10], [[1, 0, 1], 8], [[-1, 0, 1], 4], [[], 0], [[1], 6], [[-1], 4]], [[[-6], 12], [[2], 0], [[1, 0, 0, 0, -3], 0], [[3], 4], [[1, 0, -4], 4], [[2, 0, -2], 4], [[-2], 6], [[1, 0, -1], 0], [[-1], 4], [[1, 0, -2], 4], [[-1], 2], [[2], 0], [[1], 0], [[], 0], [[1], 2], [[-1, 0, 0, 0, 0, 0, 5], 0], [[-1, 0, 1], 0], [[-2], 0], [[2], 4], [[-1, 0, 0, 0, 2], 0], [[-1, 0, -1], 0], [[-1, 0, 1], 0], [[], 0], [[-1], 0], [[1], 2]], [[[-20], 36], [[-4], 0], [[-1, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, -1], 0], [[7], 12], [[-4, 0, 6, 0, -4], 14], [[2, 0, -6, 0, 2], 12], [[-4], 18], [[-1, 0, 2, 0, -1], 0], [[], 0], [[-2, 0, 3, 0, -2], 14], [[2], 2], [[2], 2], [[-1, 0, 0, 0, -1], 0], [[1], 4], [[-1], 6], [[-10, 0, 0, 0, 0, 0, 10], 12], [[2, 0, -2], 0], [[2, 0, -2], 0], [[-2, 0, 0, 0, 0, 0, 2], 4], [[1, 0, -1], 6], [[-1, 0, 1], 4], [[-1, 0, 1], 2], [[], 0], [[], 0], [[-1, 0, 1], 2]], [[[-15], 48], [[1], 0], [[-3, 0, 0, 0, 3, 0, 0, 0, 1], 4], [[-6], 16], [[-6, 0, 4, 0, -1], 20], [[-1, 0, 4, 0, -3], 16], [[-3], 24], [[1], 4], [[], 0], [[-3, 0, 2, 0, -1], 20], [[-1, 0, 0, 0, 2], 0], [[-1, 0, -1], 2], [[1], 4], [[], 0], [[], 0], [[-10, 0, 0, 0, 0, 0, 5], 18], [[1, 0, 2], 0], [[-1], 0], [[-1, 0, -1, 0, 0, 0, 0, 0, 1], 6], [[-1, 0, 0, 0, 2], 6], [[-1, 0, -1], 6], [[], 0], [[1], 6], [[], 0], [[-1, 0, -1, 0, 1], 2]], [[[-15], 24], [[1], 0], [[1, 0, 0, 0, 3, 0, 0, 0, -3], 0], [[-6], 8], [[-1, 0, 4, 0, -6], 8], [[-3, 0, 4, 0, -1], 8], [[-3], 12], [[1], 0], [[], 0], [[-1, 0, 2, 0, -3], 8], [[2, 0, 0, 0, -1], 0], [[-1, 0, -1], 0], [[1], 0], [[], 0], [[], 0], [[-5, 0, 0, 0, 0, 0, 10], 6], [[-2, 0, -1], 0], [[1], 2], [[-1, 0, 0, 0, 0, 0, 1, 0, 1], 0], [[-2, 0, 0, 0, 1], 4], [[1, 0, 1], 2], [[], 0], [[-1], 0], [[], 0], [[-1, 0, 1, 0, 1], 0]], [[[-15], 48], [[-7], 0], [[-4, 0, 3, 0, 0, 0, -2], 6], [[3], 16], [[4, 0, -4], 20], [[-4, 0, 1], 18], [[1], 24], [[-1, 0, 3, 0, -3], 0], [[], 0], [[1, 0, -2], 20], [[3, 0, -1], 2], [[2, 0, -3], 2], [[2, 0, -2], 2], [[], 0], [[1], 8], [[5, 0, -9, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1], 18], [[3, 0, -4], 0], [[2, 0, -5], 0], [[1, 0, -2, 0, 2], 6], [[-2, 0, 1, 0, 0, 0, -1], 8], [[2, 0, 0, 0, -1], 6], [[-1, 0, 2, 0, -2], 2], [[1], 4], [[1, 0, -1], 4], [[-1, 0, 2, 0, -1], 2]], [[[-15], 24], [[-7], 0], [[-2, 0, 0, 0, 3, 0, -4], 0], [[3], 8], [[-4, 0, 4], 10], [[1, 0, -4], 8], [[1], 12], [[-3, 0, 3, 0, -1], 0], [[], 0], [[-2, 0, 1], 10], [[-1, 0, 3], 0], [[-3, 0, 2], 0], [[-2, 0, 2], 0], [[], 0], [[1], 4], [[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, -5], 0], [[4, 0, -3], 0], [[5, 0, -2], 0], [[-2, 0, 2, 0, -1], 4], [[1, 0, 0, 0, -1, 0, 2], 0], [[1, 0, 0, 0, -2], 0], [[2, 0, -2, 0, 1], 0], [[-1], 2], [[1, 0, -1], 0], [[1, 0, -2, 0, 1], 0]], [[[20], 54], [[4], 0], [[2, 0, 0, 0, 0, 0, 2], 6], [[2], 18], [[4, 0, 0, 0, 1], 22], [[-2, 0, 1], 20], [[], 0], [[-2, 0, 2], 2], [[], 0], [[-2], 24], [[-1, 0, 2], 2], [[-1, 0, 2], 2], [[-1, 0, 2], 2], [[-1], 6], [[], 0], [[9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 20], [[-1, 0, 3], 0], [[-1, 0, 3], 0], [[1, 0, 0, 0, 0, 0, 1], 8], [[1], 14], [[1], 10], [[-2, 0, 1], 4], [[-1, 0, 1], 4], [[-1, 0, 1], 4], [[-2, 0, 1], 4]], [[[20], 18], [[4], 0], [[2, 0, 0, 0, 0, 0, 2], 0], [[2], 6], [[1, 0, 0, 0, 4], 6], [[1, 0, -2], 6], [[], 0], [[2, 0, -2], 0], [[], 0], [[-2], 8], [[2, 0, -1], 0], [[2, 0, -1], 0], [[2, 0, -1], 0], [[-1], 2], [[], 0], [[-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -9], 0], [[-3, 0, 1], 0], [[-3, 0, 1], 0], [[-1, 0, 0, 0, 0, 0, -1], 0], [[-1], 0], [[-1], 0], [[-1, 0, 2], 0], [[-1, 0, 1], 0], [[-1, 0, 1], 0], [[-1, 0, 2], 0]], [[[24], 42], [[8], 0], [[-6, 0, 4, 0, 0, 0, 0, 0, 2], 4], [[6], 14], [[1, 0, 0, 0, 2, 0, -4, 0, 1], 14], [[2, 0, -2, 0, 3], 14], [[], 0], [[1, 0, -4, 0, 3], 0], [[-1], 10], [[1, 0, 0, 0, 1], 18], [[-2, 0, 4], 2], [[1, 0, -3, 0, 1], 0], [[-2, 0, 2], 2], [[], 0], [[], 0], [[5, 0, 0, 0, 0, 0, -10, 0, 9], 12], [[-2, 0, 6], 0], [[-4, 0, 4], 0], [[-1, 0, 0, 0, 0, 0, 0, 0, 1], 6], [[1, 0, -3], 4], [[2, 0, -1], 4], [[2, 0, -2, 0, 1], 2], [[-1, 0, 1], 4], [[-1], 4], [[1, 0, -3, 0, 2], 2]], [[[24], 30], [[8], 0], [[2, 0, 0, 0, 0, 0, 4, 0, -6], 0], [[6], 10], [[1, 0, -4, 0, 2, 0, 0, 0, 1], 10], [[3, 0, -2, 0, 2], 10], [[], 0], [[3, 0, -4, 0, 1], 0], [[-1], 6], [[1, 0, 0, 0, 1], 10], [[4, 0, -2], 0], [[1, 0, -3, 0, 1], 0], [[2, 0, -2], 0], [[], 0], [[], 0], [[-9, 0, 10, 0, 0, 0, 0, 0, -5], 10], [[-6, 0, 2], 0], [[-4, 0, 4], 0], [[-1, 0, 0, 0, 0, 0, 0, 0, 1], 0], [[3, 0, -1], 8], [[1, 0, -2], 4], [[-1, 0, 2, 0, -2], 0], [[-1, 0, 1], 0], [[1], 2], [[-2, 0, 3, 0, -1], 0]], [[[-30], 48], [[10], 0], [[-3, 0, 4, 0, -6, 0, 0, 0, 3], 4], [[-3], 16], [[-2, 0, 0, 0, -1], 20], [[-1, 0, 0, 0, -2], 16], [[2], 24], [[1, 0, -5, 0, 4], 0], [[], 0], [[2, 0, 0, 0, -1], 20], [[1, 0, -3, 0, 3], 0], [[-3, 0, 4], 2], [[-2, 0, 3], 2], [[], 0], [[-1], 8], [[-15, 0, 9, 0, 0, 0, -5, 0, 0, 0, 0, 0, 1], 18], [[-4, 0, 6], 0], [[-3, 0, 7], 0], [[1, 0, -2, 0, 0, 0, 1], 8], [[-1, 0, 2, 0, -3, 0, 0, 0, 1], 6], [[-3, 0, 1, 0, 1], 6], [[1, 0, -4, 0, 2], 2], [[-1, 0, 1], 4], [[-1, 0, 1], 4], [[2, 0, -3, 0, 2], 2]], [[[-30], 24], [[10], 0], [[3, 0, 0, 0, -6, 0, 4, 0, -3], 0], [[-3], 8], [[-1, 0, 0, 0, -2], 8], [[-2, 0, 0, 0, -1], 8], [[2], 12], [[4, 0, -5, 0, 1], 0], [[], 0], [[-1, 0, 0, 0, 2], 8], [[3, 0, -3, 0, 1], 0], [[4, 0, -3], 0], [[3, 0, -2], 0], [[], 0], [[-1], 4], [[-1, 0, 0, 0, 0, 0, 5, 0, 0, 0, -9, 0, 15], 0], [[-6, 0, 4], 0], [[-7, 0, 3], 0], [[-1, 0, 0, 0, 2, 0, -1], 0], [[-1, 0, 0, 0, 3, 0, -2, 0, 1], 0], [[-1, 0, -1, 0, 3], 0], [[-2, 0, 4, 0, -1], 0], [[-1, 0, 1], 0], [[-1, 0, 1], 0], [[-2, 0, 3, 0, -2], 0]], [[[-60], 36], [[-12], 0], [[-1, 0, 0, 0, 3, 0, -8, 0, 3, 0, 0, 0, -1], 0], [[3], 12], [[1, 0, 0, 0, 4, 0, 0, 0, 1], 12], [[1, 0, -2, 0, 1], 12], [[-4], 18], [[-3, 0, 6, 0, -3], 0], [[], 0], [[3], 16], [[-2, 0, 4, 0, -2], 0], [[-2, 0, 4, 0, -2], 0], [[-1, 0, 4, 0, -1], 0], [[], 0], [[-1], 6], [[9, 0, -5, 0, 0, 0, 0, 0, 5, 0, -9], 10], [[6, 0, -6], 0], [[6, 0, -6], 0], [[2, 0, -2], 6], [[-1, 0, 2, 0, -2, 0, 1], 4], [[-2, 0, 2], 4], [[1, 0, -3, 0, 3, 0, -1], 0], [[-1, 0, 1], 2], [[-1, 0, 1], 2], [[1, 0, -3, 0, 3, 0, -1], 0]], [[[-80], 36], [[16], 0], [[2, 0, 0, 0, -6, 0, 8, 0, -6, 0, 0, 0, 2], 0], [[10], 12], [[1, 0, -4, 0, 10, 0, -4, 0, 1], 12], [[3, 0, -8, 0, 3], 12], [[], 0], [[4, 0, -8, 0, 4], 0], [[], 0], [[-2, 0, 2, 0, -2], 14], [[2, 0, -6, 0, 2], 0], [[2, 0, -6, 0, 2], 0], [[2, 0, -4, 0, 2], 0], [[1], 4], [[], 0], [[-9, 0, 15, 0, 0, 0, 0, 0, -15, 0, 9], 10], [[-8, 0, 8], 0], [[-8, 0, 8], 0], [[2, 0, -2, 0, 2, 0, -2], 4], [[1, 0, -3, 0, 3, 0, -1], 4], [[3, 0, -3], 4], [[-1, 0, 4, 0, -4, 0, 1], 0], [[1, 0, -1], 2], [[1, 0, -1], 2], [[-1, 0, 4, 0, -4, 0, 1], 0]], [[[-90], 36], [[6], 0], [[1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1], 0], [[-9], 12], [[-1, 0, 4, 0, -6, 0, 4, 0, -1], 12], [[-3, 0, 6, 0, -3], 12], [[-2], 18], [[1, 0, -4, 0, 1], 0], [[], 0], [[2, 0, -1, 0, 2], 14], [[1, 0, -2, 0, 1], 0], [[1, 0, -2, 0, 1], 0], [[1, 0, -2, 0, 1], 0], [[], 0], [[1], 6], [[-9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9], 10], [[-3, 0, 3], 0], [[-3, 0, 3], 0], [[-1, 0, 1], 6], [[], 0], [[], 0], [[2, 0, -2], 2], [[1, 0, -1], 2], [[1, 0, -1], 2], [[2, 0, -2], 2]], [[[-60], 42], [[4], 0], [[2, 0, -6], 6], [[-6], 14], [[4, 0, -4, 0, 4, 0, -1], 16], [[-1, 0, 6, 0, -2], 14], [[], 0], [[1, 0, -2, 0, 1], 0], [[], 0], [[-4, 0, 2], 18], [[2, 0, -1], 0], [[-1, 0, 2], 2], [[-1], 2], [[], 0], [[], 0], [[-5, 0, 0, 0, 0, 0, -5], 18], [[-3, 0, 1], 0], [[-1, 0, 3], 0], [[1, 0, 1], 6], [[2, 0, -3], 8], [[-2, 0, 1], 6], [[1, 0, -1, 0, 1], 2], [[], 0], [[], 0], [[-1, 0, 1, 0, -1], 0]], [[[-60], 30], [[4], 0], [[-6, 0, 2], 4], [[-6], 10], [[-1, 0, 4, 0, -4, 0, 4], 10], [[-2, 0, 6, 0, -1], 10], [[], 0], [[1, 0, -2, 0, 1], 0], [[], 0], [[2, 0, -4], 12], [[-1, 0, 2], 2], [[2, 0, -1], 0], [[-1], 2], [[], 0], [[], 0], [[5, 0, 0, 0, 0, 0, 5], 6], [[-1, 0, 3], 0], [[-3, 0, 1], 0], [[-1, 0, -1], 6], [[3, 0, -2], 4], [[-1, 0, 2], 2], [[-1, 0, 1, 0, -1], 0], [[], 0], [[], 0], [[1, 0, -1, 0, 1], 2]], [[[64], 45], [[], 0], [[], 0], [[-8], 15], [[4, 0, -2, 0, 4, 0, -2], 17], [[-2, 0, 4, 0, -4], 15], [[], 0], [[], 0], [[-1], 9], [[-1, 0, 2, 0, -1], 19], [[], 0], [[], 0], [[], 0], [[1], 5], [[], 0], [[16], 15], [[], 0], [[], 0], [[], 0], [[-1, 0, 0, 0, -1], 5], [[-2], 5], [[], 0], [[], 0], [[1], 3], [[], 0]], [[[-64], 27], [[], 0], [[], 0], [[8], 9], [[2, 0, -4, 0, 2, 0, -4], 9], [[4, 0, -4, 0, 2], 9], [[], 0], [[], 0], [[1], 7], [[1, 0, -2, 0, 1], 9], [[], 0], [[], 0], [[], 0], [[-1], 3], [[], 0], [[16], 15], [[], 0], [[], 0], [[], 0], [[-1, 0, 0, 0, -1], 5], [[-2], 5], [[], 0], [[], 0], [[1], 3], [[], 0]], [[[81], 40], [[9], 0], [[1, 0, 0, 0, 0, 0, 4, 0, -9, 0, 0, 0, 1], 0], [[], 0], [[], 0], [[], 0], [[-3], 20], [[2, 0, -5, 0, 2], 0], [[1], 8], [[], 0], [[3, 0, -3], 0], [[-3, 0, 3], 2], [[1, 0, -2, 0, 1], 0], [[], 0], [[], 0], [[10, 0, 0, 0, 0, 0, -5, 0, 9, 0, 0, 0, -5], 12], [[-6, 0, 3], 0], [[-3, 0, 6], 0], [[1, 0, -2], 8], [[3, 0, -3], 8], [[1, 0, -2, 0, 1], 4], [[2, 0, -3, 0, 1], 2], [[1], 2], [[-1], 4], [[-1, 0, 3, 0, -2], 0]], [[[81], 32], [[9], 0], [[1, 0, 0, 0, -9, 0, 4, 0, 0, 0, 0, 0, 1], 0], [[], 0], [[], 0], [[], 0], [[-3], 16], [[2, 0, -5, 0, 2], 0], [[1], 8], [[], 0], [[-3, 0, 3], 2], [[3, 0, -3], 0], [[1, 0, -2, 0, 1], 0], [[], 0], [[], 0], [[5, 0, 0, 0, -9, 0, 5, 0, 0, 0, 0, 0, -10], 6], [[-3, 0, 6], 0], [[-6, 0, 3], 0], [[2, 0, -1], 4], [[3, 0, -3], 4], [[-1, 0, 2, 0, -1], 2], [[-1, 0, 3, 0, -2], 0], [[-1], 4], [[1], 2], [[2, 0, -3, 0, 1], 2]]])
chevieset(Symbol("2E6"), :FakeDegree, function (p, q)
        local sgns
        sgns = [1, 1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, -1, -1, -1, -1, -1, -1, -1, 1, -1, 1, 1]
        return sgns[Position(((chevieget(:E6, :CharInfo))())[:charparams], p)] * (chevieget(:E6, :FakeDegree))(p, -q)
    end)
chevieset(Symbol("2E6"), :ClassParameter, function (w,)
        local x
        if w == []
            return " "
        end
        x = Product((chevieget(Symbol("2E6"), :generators))[w]) * chevieget(Symbol("2E6"), :phi)
        return (chevieget(Symbol("2E6"), :ClassNames))[Position(chevieget(Symbol("2E6"), :cyclestructure), CycleStructurePerm(x))]
    end)
chevieset(Symbol("2E6"), :HeckeCharTable, function (param, rootparam)
        local q, v, tbl
        q = -((param[1])[1]) // (param[1])[2]
        if !(rootparam[1] !== nothing)
            v = GetRoot(q, 2, "CharTable(Hecke(2E6))")
        else
            v = rootparam[1]
        end
        tbl = Dict{Symbol, Any}(:identifier => "H(^2E6)", :text => "origin: Jean Michel, June 1996", :parameter => map((i->begin
                                [q, -1]
                            end), 1:6), :sqrtParameter => fill(0, max(0, (1 + 6) - 1)) + v, :size => 51840, :cartan => chevieget(Symbol("2E6"), :CartanMat), :irreducibles => map((i->begin
                                map((j->begin
                                            ValuePol(j[1], v) * v ^ j[2]
                                        end), i)
                            end), chevieget(Symbol("2E6"), :vpolheckeirreducibles)), :irredinfo => chevieget(Symbol("2E6"), :IrredInfo))
        Inherit(tbl, (chevieget(Symbol("2E6"), :ClassInfo))())
        tbl[:centralizers] = map((x->begin
                        tbl[:size] // x
                    end), tbl[:classes])
        tbl = ((CHEVIE[:compat])[:MakeCharacterTable])(tbl)
        ((CHEVIE[:compat])[:AdjustHeckeCharTable])(tbl, param)
        return tbl
    end)
chevieset(Symbol("2E6"), :PhiFactors, [1, -1, 1, 1, -1, 1])
chevieset(Symbol("2E6"), :UnipotentCharacters, function ()
        local uc, p, h
        uc = Dict{Symbol, Any}(:harishChandra => [Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "F", :indices => [2, 4, 5, 6], :rank => 4), :levi => [], :eigenvalue => 1, :parameterExponents => [1, 1, 2, 2], :cuspidalName => "", :charNumbers => [1, 9, 10, 2, 4, 5, 15, 16, 17, 7, 24, 25, 8, 3, 19, 6, 11, 20, 21, 12, 26, 27, 13, 14, 28]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [2], :rank => 1), :levi => [1, 3, 4, 5, 6], :eigenvalue => -1, :parameterExponents => [9], :cuspidalName => "{}^2A_5", :charNumbers => [23, 22]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:6, :eigenvalue => 1, :parameterExponents => [], :cuspidalName => "{}^2E_6[1]", :charNumbers => [18]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:6, :eigenvalue => E(3), :parameterExponents => [], :cuspidalName => "{}^2E_6[\\zeta_3]", :charNumbers => [29]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:6, :eigenvalue => E(3, 2), :parameterExponents => [], :cuspidalName => "{}^2E_6[\\zeta_3^2]", :charNumbers => [30])], :almostHarishChandra => [Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:orbit => [Dict{Symbol, Any}(:series => "E", :indices => 1:6, :rank => 6)], :twist => perm"(1,6)(3,5)"), :levi => [], :eigenvalue => 1, :cuspidalName => "", :charNumbers => [1, 2, 3, 15, 16, 6, 7, 8, 10, 9, 11, 12, 26, 27, 4, 5, 17, 18, 19, 21, 20, 22, 23, 25, 24]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:orbit => [Dict{Symbol, Any}(:series => "A", :indices => [1, 6], :rank => 2)], :twist => perm"(1,2)"), :levi => 2:5, :eigenvalue => -1, :cuspidalName => "D_4", :charNumbers => [14, 28, 13]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:6, :eigenvalue => E(3), :cuspidalName => "E_6[\\zeta_3]", :charNumbers => [29]), Dict{Symbol, Any}(:relativeType => Dict{Symbol, Any}(:series => "A", :indices => [], :rank => 0), :levi => 1:6, :eigenvalue => E(3, 2), :cuspidalName => "E_6[\\zeta_3^2]", :charNumbers => [30])], :families => [Family("C1", [1]), Family("C1", [2]), Family("C1", [15]), Family("C1", [16]), Family("C1", [11]), Family("C1", [12]), Family("C1", [26]), Family("C1", [27]), Family("C1", [21]), Family("C1", [20]), Family("C'1", [22]), Family("C'1", [23]), Family("C1", [25]), Family("C1", [24]), Family("C2", [4, 7, 10, 13], Dict{Symbol, Any}(:name => "Cd_2", :eigenvalues => [1, 1, 1, 1], :fourierMat => 1 // 2 * [[1, 1, 1, 1], [1, 1, -1, -1], [1, -1, 1, -1], [-1, 1, 1, -1]], :sh => [1, 1, 1, 1])), Family("C2", [5, 8, 9, 14], Dict{Symbol, Any}(:eigenvalues => [1, 1, 1, 1], :name => "Cc_2", :sh => [1, 1, 1, 1])), Family("S3", [18, 17, 19, 3, 6, 28, 29, 30], Dict{Symbol, Any}(:name => "S3b", :eigenvalues => [1, 1, 1, 1, 1, 1, E(3), E(3, 2)], :sh => [1, 1, 1, 1, 1, 1, E(3, 2), E(3)]))], :a => [0, 36, 7, 3, 15, 7, 3, 15, 15, 3, 2, 20, 3, 15, 1, 25, 7, 7, 7, 11, 5, 4, 13, 10, 6, 6, 12, 7, 7, 7], :A => [0, 36, 29, 21, 33, 29, 21, 33, 33, 21, 16, 34, 21, 33, 11, 35, 29, 29, 29, 31, 25, 23, 32, 30, 26, 24, 30, 29, 29, 29])
        return uc
    end)
chevieset(Symbol("2E6"), :UnipotentClasses, function (p,)
        local uc, l
        uc = deepcopy((chevieget(:E6, :UnipotentClasses))(p))
        uc[:springerSeries] = Filtered(uc[:springerSeries], (x->begin
                        x[:Z] == [1]
                    end))
        l = [["1", perm"(1,6)(3,5)"], ["A_1", perm"(1,5)(2,4)"], ["A_2", perm"(1,2)(3,4)"], ["D_4", perm"(1,2)"], ["D_5", [[-1]]], ["D_5(a_1)", [[-1]]], ["A_4{+}A_1", [[-1]]], ["A_4", [[1, 0], [0, -1]]], ["D_4(a_1)", [[-1, 0], [0, -1]]], ["A_3{+}A_1", [[1, 0], [0, -1]]], ["A_2{+}2A_1", [[1, 0], [0, -1]]], ["A_3", DiagonalMat(1, 1, -1)], ["A_2{+}A_1", [[0, 1, 0], [1, 0, 0], [0, 0, -1]]], ["3A_1", perm"(1,2)"], ["2A_1", DiagonalMat(1, 1, 1, -1)]]
        for p = l
            (First(uc[:classes], (x->(x[:name] == p[1];))))[:F] = p[2]
        end
        return uc
    end)