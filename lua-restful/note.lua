local cjson = require "cjson"
local _M = {}

local function getInfo(key) 
	local data = {}
  data['id'] = redis:hget(key,'id')
  data['uid'] = redis:hget(key,'uid')
  data['title'] = redis:hget(key,'title')
  data['content'] = redis:hget(key,'content')
  data['tag_id'] = redis:hget(key,'tag_id')
  data['type'] = redis:hget(key,'type')
	local head = redis:hget(key,'head') or '[]'
  data['head'] = cjson.decode(head)
	local tab = redis:hget(key,'table') or '[]'
  data['table'] = cjson.decode(tab)
  data['createtime'] = redis:hget(key,'createtime')
  data['updatetime'] = redis:hget(key,'updatetime')
	return data

end

-- 添加笔记
function _M:add(data)
  if data['title'] == nil then
		app:error('标题不能空')
  elseif data['content'] == nil then
		app:error('内容不能空')
  else
		--添加到hash
		local id = redis:incr('sys:note:_id') 
		local tagid = intval(data['tag_id'])
		local uid = intval(UID)
		local key = 'note:u'..uid..':'..id
		if uid <= 0 then
			app:error('请先登录')
		end
		redis:multi()
		redis:hset(key,'id',id)
		redis:hset(key,'title',data['title'])
		redis:hset(key,'content',data['content'])
		redis:hset(key,'tag_id',tagid)
		redis:hset(key,'uid',uid)
		redis:hset(key,'type',data['type'] or '')
		redis:hset(key,'table',cjson.encode(data['table']))
		redis:hset(key,'head',cjson.encode(data['head'])) 
		redis:hset(key,'createtime',os.date("%Y-%m-%d %H:%M:%S",os.time()))
		--列表
		redis:zadd('note:u'..uid..':list',os.time(),key)
		if tagid ~= nil and tagid >0 then 
			redis:zadd('note:u'..uid..':tag'..tagid..':list',os.time(),key)
		end
		redis:exec()
    app:returnJson({['id']=id},1,'添加成功')
  end
end

--编辑笔记
function _M:edit(id,data)
  local id = intval(id)
  if id == nil then
		app:error('id不能空')
  elseif UID <= 0 then
		app:error('请先登录')
	else
		--添加到hash 
		local key = 'note:u'..UID..':'..id
		if data['title'] ~= nil then
			redis:hset(key,'title',data['title'])
		end
		if data['content'] ~= nil then
			redis:hset(key,'content',data['content'])
		end
		if data['table'] ~= nil then
			redis:hset(key,'table',cjson.encode(data['table']))
		end
		if data['tag_id'] ~= nil then
			redis:hset(key,'tag_id',intval(data['tag_id']))
		end
		redis:hset(key,'updatetime',os.date("%Y-%m-%d %H:%M:%S",os.time()))
    app:returnJson(data,1,'编辑成功')
  end  
end

-- 笔记列表
function _M:listData(tagId,page)
  local uid = intval(UID) or 0
  local pageSize = 20
  local startNum = 0
  local endNum = pageSize
  local page = page or 1
  local tagId = tonumber(tagId) or 0
	
	if uid<=0 then
		app:error('请先登录',-401)
	end
  
  if page == nil or page<=0 then
	page = 1
  end 
  
  local key = 'note:u'..uid..':list'
  
  if tagId >0 then
	key = 'note:u'..uid..':tag'..tagId..':list'
  end  
  
  local totalNum = redis:zcard(key) or 0
  local totalPage = math.ceil(totalNum/pageSize)
  local nextPage = ""
 
  if page < totalPage then
		nextPage = page + 1
		startNum = (page - 1) * pageSize
		endNum = page * pageSize
  else  
		nextPage = ""
		startNum = (totalPage - 1) * pageSize
		endNum = totalPage * pageSize
  end
  
  endNum = endNum - 1
  local rs = redis:zRevRange(key, startNum, endNum) or {}
	local result = {}
	local items= {}
	for i,v in ipairs(rs) do
		items[i] = getInfo(v)
	end	 
	result['list'] = items
  result['total_num'] = totalNum;
  result['total_page'] = totalPage;
  result['next_page'] = nextPage;
  app:returnJson(result,1,'笔记列表')
end

-- 获取单条信息
function _M:info(id)
	if UID <= 0 then
		app:error('uid不能空')
	end
	local key = 'note:u'..UID..':'..id
  local data = getInfo(key)
  app:returnJson(data,1,'获取信息')
end


return _M