local _M = {}
 
 
 
-- 验证签名有效性 
function _M:getOpenId(code) 
	local url = 'https://api.weixin.qq.com/sns/jscode2session?appid=wxc38a6e8d3188faf2&secret=290b9a212a53c6b8b3a4afbe25de5f44&js_code='..code..'&grant_type=authorization_code'
	local rs,err = sendGet(url)
	ngx.say(err)
	ngx.say(url)
end
 

return _M