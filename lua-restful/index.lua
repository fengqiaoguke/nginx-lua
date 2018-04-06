
app = require "RestLua.app"
user = require "user"
local note = require "note" 

ngx.header["Access-Control-Allow-Origin"] = "*"
ngx.header["Access-Control-Allow-Headers"] = "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range, userid, agent, brandid, language, uid,timestamp,token"

if ngx.var.request_method == "OPTIONS" then
    ngx.header["Access-Control-Max-Age"] = "1728000"
    ngx.header["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS, PUT, DELETE"
    ngx.header["Content-Length"] = "0"
    ngx.header["Content-Type"] = "text/plain, charset=utf-8"
	ngx.exit(200)
end

redis = app:redis()

--check token
UID = user:checkToken() or 0

-- note
--[笔记列表]
app:get('/note',function(req)
  note:listData(req.query['tag_id'],req.query['page'])
end)

--[添加笔记]
app:post('/note',function(req)
  note:add(req.body)
end)

--[获取一条笔记]
app:get('/note/:d',function(req) 
  note:info(req.params[1])
end)

--[删除一条笔记]
app:delete('/note/:d',function(req)
  note:delete(req.params[1])
end)

--[编辑一条笔记]
app:put('/note/:d',function(req)
  note:edit(req.params[1],req.body)
end)

-- end note


