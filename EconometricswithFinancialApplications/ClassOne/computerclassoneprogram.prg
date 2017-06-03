getstocks(a,freq=3,i=2, start=2000/01/01, end=2014/12/01) gs jpm
graph serieslevels.line gs_adjclose jpm_adjclose
graph seriesdlog.line dlog(gs_adjclose) dlog(jpm_adjclose)
!sig=1
!maxp=20
for %series gs_adjclose jpm_adjclose
	smpl @first 2014m12
	freeze(temptb) log({%series}).uroot(kpss)
	!lm = @val(temptb(7,5))
	!crit = @val(temptb(8+!sig,5))
	delete temptb
	if !lm>!crit then
		!diff=1
	else
		!diff=0
	endif
	!aic=999999999999999999999999999999999
	vector(!maxp) {%series}_storeaic
	for !p = 1 to !maxp
		equation eq{!p}.ls dlog({%series},!diff) c ar(1 to !p)
		{%series}_storeaic(!p)=eq{!p}.@aic
		if eq{!p}.@aic<!aic then
			!aic =eq{!p}.@aic
			!bestp=!p
		endif
		delete eq{!p}
	next
	equation besteq_{%series}.ls dlog({%series},!diff) c ar(1 to !bestp)
	pagestruct(freq=m,start=2000m1,end=2015m12)
	smpl 2015m1 2015m12
	besteq_{%series}.forecast(f=na) {%series}_f
next


