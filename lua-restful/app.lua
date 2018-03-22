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
 
-- post
ngx.req.read_body() 
local arg = ngx.req.get_post_args()
for k,v in pairs(arg) do
   post[k] = v
end
request.body = post


--get方法
function _M:get(rule,func)
	local _uri = string.lower(ngx.var.uri) 
	

    local _rule1 = string.gsub(rule, ':d','%%d+') 
	local _rule1 = string.gsub(_rule1, ':w','%%w+')
	local _rule1 = string.gsub(_rule1, ':a','%%a+')
	if  string.match(_uri,_rule1) == _uri and string.lower(ngx.var.request_method) == 'get' then 
	
		--统计参数个数
		_,num = string.gsub(rule, ':','')
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
	 
		if func then
			func(request)
		end
	end
end

--post方法
function _M:post(uri,func)
	local _uri = string.lower(ngx.var.uri)
	if  string.match(_uri,uri) == _uri and string.lower(ngx.var.request_method) == 'post' then 
		if func then
			func(request)
		end
	end
end

--delete方法
function _M:delete(uri,func)
	local _uri = string.lower(ngx.var.uri)
	if  string.match(_uri,uri) == _uri and string.lower(ngx.var.request_method) == 'delete' then 
		if func then
			func(request)
		end
	end
end

--patch方法
function _M:patch(uri,func)
	local _uri = string.lower(ngx.var.uri)
	if  string.match(_uri,uri) == _uri and string.lower(ngx.var.request_method) == 'patch' then 
		if func then
			func(request)
		end
	end
end

--put方法
function _M:put(uri,func)
	local _uri = string.lower(ngx.var.uri)
	if  string.match(_uri,uri) == _uri and string.lower(ngx.var.request_method) == 'put' then 
		if func then
			func(request)
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
function PrintTable( tbl , level, filteDefault)
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
          PrintTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      ngx.say(item_str)
      if type(v) == "table" then
        PrintTable(v, level + 1)
      end
    end
  end
  ngx.say(indent_str .. "}")
end

return _M