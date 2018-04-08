local _M = {}

local function getInfo(key) 
	local data = {}
  data['id'] = redis:hget(key,'id')
  data['uid'] = redis:hget(key,'uid')
  data['name'] = redis:hget(key,'name')
  data['createtime'] = redis:hget(key,'createtime')
  data['updatetime'] = redis:hget(key,'updatetime')
	return data

end

-- 添加分类
function _M:add(data)
  if data['name'] == nil then
		app:error('名称不能空')
  else
	--添加到hash
	local id = redis:incr('sys:category:_id')
	local uid = intval(UID)
	local key = 'u'..uid..':note:'..id
	if uid <= 0 then
		app:error('请先登录')
	end
	redis:multi()
	redis:hset(key,'id',id)
	redis:hset(key,'name',data['name']) 
	redis:hset(key,'uid',uid)
	redis:hset(key,'createtime',os.date("%Y-%m-%d %H:%M:%S",os.time()))
	--列表
	redis:zadd('u'..uid..':category:list',os.time(),key) 
	redis:exec()
    app:returnJson({['id']=id},1,'添加成功')
  end
end

--编辑分类
function _M:edit(id,data)
  local id = intval(id)
  if id == nil then
		app:error('id不能空')
  elseif UID <= 0 then
		app:error('请先登录')
	else
		--添加到hash 
		local key = 'u'..UID..':category:'..id
		if data['name'] ~= nil then
			redis:hset(key,'name',data['name'])
		end
		redis:hset(key,'updatetime',os.date("%Y-%m-%d %H:%M:%S",os.time()))
    app:returnJson(data,1,'编辑成功')
  end  
end

-- 分类列表
function _M:listData(page)
  local uid = intval(UID) or 0
  local pageSize = 50
  local startNum = 0
  local endNum = pageSize
  local page = page or 1
	
	if uid<=0 then
		app:error('请先登录',-401)
	end
  
  if page == nil or page<=0 then
		page = 1
  end 
  local key = 'u'..uid..':category:list'
  
  local totalNum = redis:zcard(key)
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
  local rs = redis:zRevRange(key, startNum, endNum)
	local result = {}
	local items= {}
	for i,v in ipairs(rs) do
		items[i] = getInfo(v)
	end	 
	result['list'] = items
  result['total_num'] = totalNum;
  result['total_page'] = totalPage;
  result['next_page'] = nextPage;
  app:returnJson(result,1,'分类列表')
end

-- 获取单条信息
function _M:info(id)
	if UID <= 0 then
		app:error('uid不能空')
	end
	local key = 'u'..UID..':category:'..id
  local data = getInfo(key)
  app:returnJson(data,1,'获取信息')
end


return _M