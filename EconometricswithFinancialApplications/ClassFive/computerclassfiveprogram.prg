wfopen C:\<insertfilepath>\fxdata.csv
for %series belize kazahk kenya mexico usd
	genr pc_{%series}=@pc({%series})
	graph {%series}_g.line pc_{%series}
next
graph all_g.merge belize_g kazahk_g kenya_g mexico_g usd_g
for %series belize kazahk kenya mexico usd
	!schwarz=999999999999999999999999
	for !p = 1 to 10
		equation {%series}_eq{!p}.ls pc_{%series} c ar(1 to !p)
		if {%series}_eq{!p}.@schwarz<!schwarz then
			!schwarz={%series}_eq{!p}.@schwarz
			!bestlag=!p
		endif
	next
	equation {%series}_eq_bestlag.ls pc_{%series} c ar(1 to !bestlag)
	freeze(archtest_{%series}) {%series}_eq_bestlag.archtest(4)
	equation garch_{%series}.arch pc_{%series} c ar(1 to !bestlag)
	freeze(garch_{%series}_cond_std_g) garch_{%series}.garch
	freeze(garch_{%series}_cond_var_g) garch_{%series}.garch(v)
	garch_{%series}.makegarch garch_{%series}_cond_v
	graph garch_{%series}_cond_var_g1.line garch_{%series}_cond_v
	freeze(garch_{%series}_hist) garch_{%series}.hist
	freeze(garch_{%series}_archtest) garch_{%series}.archtest(4)
	garch_{%series}.forecast garch_{%series}_fm garch_{%series}_fse garch_{%series}_fgarch
	equation	{%series}_eq_egarch.arch(1,1,egarch) pc_{%series} c ar(1 to !bestlag)
next


