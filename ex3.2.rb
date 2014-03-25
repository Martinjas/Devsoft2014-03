

def fatorial arg1
a=1
copy=arg1 
	while arg1>0
		a*=arg1
		arg1-=1
	end
puts "O fatorial de #{copy} eh #{a}. "

end


fatorial 20
