local app = require ("app")
 
 
app:get('/blog/:d',function(request)
	  ngx.say('this is blog, id=')
	  ngx.say(request.params[1])
end)

app:get('/article/[0-9]+',function(request)
	  ngx.say('this is article') 
end)