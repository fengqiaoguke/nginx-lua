local cjson = require "cjson"
local config = require "RestLua.config"
local redis = require "RestLua.redis"
local http = require "resty.http" 
local ruleNum = 0


local _M = {}

local get = {}
local post = {}
local request = {
	query = {},
	body = {},
	params ={}
}

--get
local arg = ngx.req.get_uri_args()
for k,v in pairs(arg) do
	get[k] = v 
end 
request.query = get

-- 解析post传值
ngx.req.read_body() 
local arg = ngx.req.get_post_args()
for k,v in pairs(arg) do
	request.body = cjson.decode(k)
end 
 
--get方法
function _M:get(rule,func)
	runMethod('get',rule,func)
end

--post方法
function _M:post(rule,func)	 
	runMethod('post',rule,func)
end

--delete方法
function _M:delete(rule,func)
	runMethod('delete',rule,func)
end

--patch方法
function _M:patch(rule,func)
	runMethod('patch',rule,func)
end

--put方法
function _M:put(rule,func)
	runMethod('put',rule,func)
end

--格式化json
function _M:json(data,code,message)
	local data = {
		data = data,
		code = code,
		msg = message
	}
	return cjson.encode(data)
end

--输出json
function _M:returnJson(data,code,message)
  ngx.say(_M:json(data,code,message))
end

--输出错误
function _M:error(message,code)
  if code == nil or code >0 then
		code = -1
  end
  ngx.say(_M:json('',code,message))
	ngx.exit(500)
end

--输出成功
function _M:success(message,code)
  if code == nil or code < 0 then
	code = 0
  end
  ngx.say(_M:json('',code,message))
end

--redis
function _M:redis()
	local rs = redis:new()
	if rs then
		return rs
	else
		_M:returnJson('',-1,'redis连接失败')
		ngx.exit(200)
	end
end 

function sendPost(url, body, timeout, ssl_verify)
		local httpc = http.new()

		timeout = timeout or 30000
		httpc:set_timeout(timeout)
		local res, err_ = httpc:request_uri(url, {
						ssl_verify = ssl_verify or false,
						method = "POST",
						body = body,
						headers = {
								["Content-Type"] = "application/x-www-form-urlencoded",
						}
		})

   if not res then
        return nil, err_
   else
      if res.status == 200 then
                return res.body, err_
           else
                return nil, err_
           end
    end

end


function sendGet(url, body, timeout, ssl_verify)
		local httpc = http.new()

		timeout = timeout or 30000
		httpc:set_timeout(timeout)
		local res, err_ = httpc:request_uri(url, {
						ssl_verify = ssl_verify or false,
						method = "GET",
						body = body,
						headers = {
							["Content-Type"] = "text/html",
					}
		})

   if not res then
        return nil, err_
   else
      if res.status == 200 then
                return res.body, err_
           else
                return nil, err_
           end
    end

end


--字符串转table
function StrToTable(str)
    if str == nil or type(str) ~= "string" then
        return
    end
    
    return loadstring("return " .. str)()
end

--打印table
function printTable( tbl , level, filteDefault)
  local msg = ""
  filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
  level = level or 1
  local indent_str = ""
  for i = 1, level do
    indent_str = indent_str.."  "
  end

  ngx.say(indent_str .. "<pre>{")
  for k,v in pairs(tbl) do
    if filteDefault then
      if k ~= "_class_type" and k ~= "DeleteMe" then
        local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
        ngx.say(item_str)
        if type(v) == "table" then
          printTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      ngx.say(item_str)
      if type(v) == "table" then
        printTable(v, level + 1)
      end
    end
  end
  ngx.say(indent_str .. "}")
end

-- 执行rest
function runMethod(method,rule,func)
	ruleNum  = ruleNum+1 
	
	local _uri = string.lower(ngx.var.uri)  
  
    local _rule1 = string.gsub(rule, ':d','%%d+') 
	local _rule1 = string.gsub(_rule1, ':w','%%w+')
	local _rule1 = string.gsub(_rule1, ':a','%%a+')
 
	if  string.match(_uri,_rule1) == _uri and string.lower(ngx.var.request_method) == method then 
		request.debug = {['rule_num']=ruleNum}
		--统计参数个数
		_,num = string.gsub(rule, ':','')
		if num >0 then
			local str = "{"
			for i=1,num do
			  str = str.."["..i.."]='%"..i.."',"
			end
			str = string.sub(str, 1, -2)..'}'
			--把uri参数输出table格式
			local _rule = string.gsub(rule, ':d','(%%d+)')
			local _rule = string.gsub(_rule, ':w','(%%w+)')
			local _rule = string.gsub(_rule, ':a','(%%a+)')
			local _table = string.gsub(_uri,_rule,str)
			request.params = StrToTable(_table)
		end
	 
		if func then
			func(request)
		end
		ngx.exit(200);
	end
end

-- 转换成整型
function intval(x)
	x = tonumber(x) or 0
  if x == nil then
		x = 0
  elseif x <= 0 then
		return tonumber(math.ceil(x))
  end

  if math.ceil(x) == x then
	 x = math.ceil(x);
  else
	 x = math.ceil(x) - 1
  end
  return tonumber(x)
end

return _M