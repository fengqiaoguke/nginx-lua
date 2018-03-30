local app = require ("RestLua.app")
 

a = app.redis()
 
ngx.say(a:get(1))
 
app:get('/blog/:d',function(request)
	local id = request.params[1]
	 
	ngx.say(id)
end)



app:get('/article/[0-9]+',function(request)
	  ngx.say('this is article') 
end)