ngx.header["Access-Control-Allow-Origin"] = "*"
ngx.header["Access-Control-Allow-Headers"] = "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range, userid, agent, brandid, language, uid,timestamp,token,sign"

if ngx.var.request_method == "OPTIONS" then
    ngx.header["Access-Control-Max-Age"] = "1728000"
    ngx.header["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS, PUT, DELETE"
    ngx.header["Content-Length"] = "0"
    --ngx.header["Content-Type"] = "text/plain, charset=utf-8"
	ngx.exit(200)
end

app = require "RestLua.app"
local user = require "user"
local note = require "note" 
local wechat = require "wechat" 

redis = app:redis()

--[微信登录]
app:post('/session/wechat',function(req)
	user:loginWechat(req.body['openid'],req.body['username'])
end)

--[生成登录二维码]
app:post('/session/qr',function(req)
  user:buildQR(req.body['rand'])
end)

--[扫码登录]
app:get('/session/qr/login',function(req)
  user:loginRQ(req.query['code'],req.query['utoken'])
end)

--[检查是否扫二维码]
app:get('/session/qr',function(req)
  user:checkQR(req.query['code'])
end)

--check sign
UID = user:checkSign() or 0

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

-- category
local category = require "category" 
--[分类列表]
app:get('/category',function(req)
  category:listData(req.query['page'])
end)

--[添加分类]
app:post('/category',function(req)
  category:add(req.body)
end)

--[获取一条分类]
app:get('/category/:d',function(req) 
  category:info(req.params[1])
end)

--[删除一条分类]
app:delete('/category/:d',function(req)
  category:delete(req.params[1])
end)

--[编辑一条分类]
app:put('/category/:d',function(req)
  category:edit(req.params[1],req.body)
end)


--[获取微信openid]
app:get('/wechat/openid',function(req)
  wechat:getOpenId('061kAAC4257AzN0WRiE42KaQC42kAAC8')
end)

-- end category


