local _M = {} 
local cjson = require "cjson"
local app = require "RestLua.app"
local head = ngx.req.get_headers()
 
-- 验证签名有效性 
function _M:checkSign() 
	local utoken = head['utoken'] or ''
	local uid = tonumber(redis:get('utoken:'..utoken)) or 0
	local timestamp = head['timestamp'] or ''
	local sign = ngx.md5(ngx.var.request_uri .. '@'.. uid ..'#'..timestamp)
	if head['sign'] ~= sign then
		app:error('签名错误',-4003)
	end
	return uid
end

-- 微信登录
function _M:loginWechat(openid,username)
	if openid == nil or username == nil then
		app.error('openid和username不能空')
	end
	--判断是否绑定小程序
	local hkey = 'openid:'..openid
	local uid = redis:hget(hkey,'uid')
	uid = tonumber(uid) or 0
	local oldUtoken = redis:hget(hkey,'utoken')
	-- 注册新用户并绑定openid
	if uid == 0 then
		uid = redis:incr('sys:user:_uid')
		local key = 'user:'..uid
		redis:multi()
		redis:hset(key,'uid',uid)
		redis:hset(key,'username',username)
		redis:hset(key,'createtime',os.date("%Y-%m-%d %H:%M:%S",os.time()))
		-- 加入用户列表
		redis:zadd('user:list',os.time(),uid) 
		redis:exec()
	end
	-- 删除旧utoken  
	if type(oldUtoken) == "string" and oldUtoken ~= nil then
		redis:del('utoken:'..oldUtoken)
	end
	
	-- 生成utoken
	local utoken = ngx.md5(os.time()..uid)
	redis:multi()
	redis:hset(hkey,'uid',uid)
	redis:hset(hkey,'username',username)
	redis:hset(hkey,'utoken',utoken)
	redis:setex('utoken:'..utoken,24*30*365, uid)
	redis:exec()
	local data = {
		utoken = utoken,
		uid = uid
	}
	app:returnJson(data,200,'登录成功')
end

-- 生成登录二维码
function _M:buildQR(rand)
	local rs =  ngx.md5(rand..head['user-agent']..os.time())
	redis:setex('qr:'..rs,3600,'')
	app:returnJson(rs,200,'请用小程序/app扫码登录')
end

-- 检查是否扫二维码
function _M:checkQR(code)
	if code == nil then
		app:error('code不能空')
	end
	local utoken = redis:get('qr:'..code)
	if utoken ~= nil and utoken ~= '' then
		local key = 'utoken:'..utoken
		local uid = redis:get(key) or 0
		
		if tonumber(uid) > 0 then
			local data = {
				utoken = utoken,
				uid = uid,
				username = redis:hget('user:'..uid,'username')
			}
			app:returnJson(data,200,'登录成功')
		else
			app:returnJson(data,-401,'登录信息无效'..key)
		end
	else
		app:returnJson(data,-401,'未登录')
	end
end

-- 扫码登录
function _M:loginRQ(code,utoken)
	if code ~= nil and utoken ~= nil then
		local key = 'qr:'..code
		-- 判断code是否有效
		if redis:exists(key) == 0 then
			app:error('code不存在')
		end
		-- 判断utoken是否有效
		if redis:exists('utoken:'..utoken) == 0 then
			app:error('utoken不存在')
		end
		redis:set(key,utoken)
		app:returnJson(rs,200,'允许web登录')
	else
		app:error('code和utoken不能空')
	end
end

 

return _M