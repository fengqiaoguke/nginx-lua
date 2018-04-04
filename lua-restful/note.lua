local _M = {}

-- 添加笔记
function _M:add(data)
  if data['title'] == nil then
	app:error('标题不能空')
  elseif data['content'] == nil then
	app:error('内容不能空')
  else
	--添加到hash
	local id = redis:incr('note:_id')
	local key = 'note:'..id
	redis:hset(key,'id',id)
	redis:hset(key,'title',data['title'])
	redis:hset(key,'content',data['content'])
	redis:hset(key,'tag_id',intval(data['tag_id']))
	redis:hset(key,'uid',intval(data['uid']))
    app:returnJson({['id']=id},1,'添加成功')
  end
end

--编辑笔记
function _M:edit(id,data)
  local id = intval(id)
  if id == nil then
	app:error('id不能空')
  else
	--添加到hash 
	local key = 'note:'..id
	if data['title'] ~= nil then
	  redis:hset(key,'title',data['title'])
	end
	if data['content'] ~= nil then
	  redis:hset(key,'content',data['content'])
	end
	if data['title'] ~= nil then
	  redis:hset(key,'tag_id',intval(data['tag_id']))
	end
    app:returnJson(data,1,'编辑成功')
  end  
end

-- 笔记列表
function _M:list(req)
  app:success('aaa') 
  
end

-- 获取单条信息
function _M:info(id)
  local data = {}
  local key = 'note:'..id
  data['id'] = redis:hget(key,'id')
  data['uid'] = redis:hget(key,'uid')
  data['title'] = redis:hget(key,'title')
  data['content'] = redis:hget(key,'content')
  data['tag_id'] = redis:hget(key,'tag_id')
  app:returnJson(data,1,'获取信息')
end

return _M