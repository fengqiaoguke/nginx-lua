local app = require ("app")

ngx.say(string.lower(ngx.var.request_method)  )

app:post('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a)
	ngx.say(request.body.a)
	ngx.say(request.body.b)
end)

app:get('/a/:d/b/:d/c/:d/d/:a/:w',function(request)
	 ngx.say('1')
end)

app:get('/blog/:d',function(request)
	  ngx.say('blog')
	  ngx.say(request.params[1])
end)