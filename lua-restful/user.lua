local _M = {}
 

local head = ngx.req.get_headers()
 
--  
function _M:checkToken() 
	local utoken = 1 
	local timestamp = head['timestamp'] or ''
	local sign = ngx.md5(ngx.var.request_uri .. '@'.. utoken ..'#'..timestamp)
	if head['sign'] ~= sign then
		app:error('签名错误',-403)
	end
	return tonumber(head['uid']) or 0
end
 

return _M