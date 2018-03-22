# 基于openresty的restful接口开发框架
### 最近打算研究 lua+redis开发restful风格的接口,网上找了一圈发现没有合适的,结合这两天收集的资料,自己封装了个lua的路由,支持restful

### 例子
```lua
local app = require ("app")

ngx.say(string.lower(ngx.var.request_method)  )

app:get('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a)
end)

app:post('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a)
	ngx.say(request.body.a)
	ngx.say(request.body.b)
end)

app:delete('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a) 
end)

app:put('/user/[a-z0-9]+',function(request)
	ngx.say(request.query.a) 
end)
```
### 参数说明 request
``` lua
1. request.query : 这是一个table，指的是url解析后的query string，比如”/find/user?id=1&name=sumory&year=2016”被解析后会生成对象req.query,它的值为：
2. request.body : 这是一个table，指的是form表单提交上来的数据。
3. request.params:这是一个table，指的是uri解析后的参数,支持:d(数字)、:w(数字+字母)、:a(字母)。例如:/blog/:d对应的是ngx.say(request.params[1])
```
 ### 这只是一个路由,以后有时间再完善这个框架,下一步把redis和json的封装一下.