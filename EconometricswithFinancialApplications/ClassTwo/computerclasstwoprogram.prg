wfcreate m 2000m1 2014m9
copy fred::gdpdef untitled::gdpdef
copy fred::nzlsacrmismei untitled::nzcarreg
graph linegraph1.line log(gdpdef) log(nzcarreg)
linegraph1.setelem(2) axis(right)
graph linegraph2.line dlog(gdpdef) dlog(nzcarreg)
linegraph2.setelem(2) axis(right)
for %series gdpdef nzcarreg
	for %test adf kpss
		for %det const trend
			freeze({%series}_{%det}_{%test}_d0)	{%series}.uroot({%test},{%det},dif=0)
			freeze({%series}_{%det}_{%test}_d1)	{%series}.uroot({%test},{%det},dif=1)
			freeze({%series}_{%det}_{%test}_d2)	{%series}.uroot({%test},{%det},dif=2)
		next
	next
	freeze({%series}_d0) {%series}.correl
	freeze({%series}_d1) d({%series},1).correl
	freeze({%series}_d2) d({%series},2).correl
next
equation eq1.ls log(gdpdef) c @trend log(nzcarreg)
equation eq2.ls dlog(gdpdef) c @trend dlog(nzcarreg)

