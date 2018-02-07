local app = require ("app")

ngx.say(string.lower(ngx.var.request_method)  )

app:post('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a)
	ngx.say(request.body.a)
	ngx.say(request.body.b)
end)