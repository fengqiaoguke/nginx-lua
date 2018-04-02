
local app = require "RestLua.app"
redis = app:redis()
local note = require "note"

 
-- note
--[笔记列表]
app:get('/note',function(req)
  note:list(req)
 
end)

--[添加笔记]
app:post('/note',function(req)
  note:add(req.body)
end)

--[获取一条笔记]
app:get('/note/:d',function(req)
  ngx.say('get'..req.params[1]) 
end)

--[删除一条笔记]
app:delete('/note/:d',function(req)
  ngx.say('del'..req.params[1]) 
end)

--[编辑一条笔记]
app:put('/note/:d',function(req)
  ngx.say('edit'..req.params[1]) 
end)

-- end note


