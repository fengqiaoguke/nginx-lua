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
function _M:get(uri,func)
	local _uri = string.lower(ngx.var.uri)
	
	if  string.match(_uri,uri) == _uri and string.lower(ngx.var.request_method) == 'get' then 
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

return _M