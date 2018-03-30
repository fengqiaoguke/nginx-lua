local app = require ("RestLua.app")
 
local redis = app.redis()

if redis ~= nil then
	redis:get(1)

end

 
app:get('/blog/:d',function(request)
	local id = request.params[1]
	 
	ngx.say(id)
end)



app:get('/article/[0-9]+',function(request)
	  ngx.say('this is article') 
end)