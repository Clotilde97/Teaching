import c:\wgmacro
!maxvarlags=4
matrix(3,!maxvarlags) ic_mat
graph tsplot1.line consumption income investment
graph tsplot2.line lconsumption lincome linvestment
graph tsplot3.line dlconsumption dlincome dlinvestment
rename dlconsumption dlcons
rename dlincome dlinc
rename dlinvestment dlinv 'rename due to EViews 24 character limit
for %series dlcons dlinc dlinv	
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
!aic = 999999999999999999999
!schwarz=99999999999999999
!hq=9999999999999999999999
for !p = 1 to !maxvarlags	
	var var{!p}.ls 1 !p dlcons dlinc dlinv
	!iccounter=1
	for %IC aic schwarz hq
		ic_mat(!iccounter,!p)=var1.@{%IC}
		if var{!p}.@{%IC}<!{%IC} then
			!bestlag{%IC}=!p
			!{%IC}=var{!p}.@{%IC}
		endif
	!iccounter=+!iccounter+1
	next	
next
var varaic.ls 1 !bestlagaic dlcons dlinc dlinv
var varschwarz.ls 1 !bestlagschwarz dlcons dlinc dlinv
var varhq.ls 1 !bestlaghq dlcons dlinc dlinv
varaic.laglen(8)
varaic.testexog
varaic.makesystem(n=varsystem)
varsystem.ls
varsystem.wald c(3)=c(4)=0	'granger causality test
varsystem.wald c(3)=c(4)=c(5)=c(6)=0 'block exogeneity test
varaic.impulse(10,m,a,se=a) dlcons dlinc dlinv @ dlcons dlinc dlinv


