wfcreate m 1959m1 2014m09
fetch fred::indpro
fetch fred::m2real
fetch fred::pce
genr lindpro=log(indpro)
genr lpce=log(pce)
genr lm2real=log(m2real)
graph loggedseries.line lindpro lpce lm2real
loggedseries.setelem(1) axis(right)
for %series lindpro lpce lm2real
	for %det const trend
		freeze({%series}_{%det}_d0) {%series}.uroot(adf,{%det},dif=0)
		freeze({%series}_{%det}_d1) {%series}.uroot(adf,{%det},dif=1)
		freeze({%series}_{%det}_d2) {%series}.uroot(adf,{%det},dif=2)
	next
	freeze({%series}_d0) {%series}.correl
	freeze({%series}_d1) d({%series},1).correl
	freeze({%series}_d2) d({%series},2).correl
next
group threeserieslogged lindpro lpce lm2real
vector(240) ranks
for !j = 1 to 240
	smpl @first+!j @last-240+!j
	var varfirstdifferences.ls 1 4 d(lpce) d(lm2real) d(lindpro)
	varfirstdifferences.laglen(12,mname=matrixlags{!j})
	!lags=matrixlags{!j}(14,5)
	freeze(vecmtable!j) threeserieslogged.coint(s,!lags)
	ranks(!j)=vecmtable!j(13,4)
next
freeze(cointegratingranks) ranks.line
smpl @all
var firstvecm
firstvecm.append(coint) b(1,3)=0
firstvecm.ec(c,1,restrict) 1 1 lpce lindpro lm2real

