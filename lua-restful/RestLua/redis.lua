local redis = require "resty.redis"
local config = require "RestLua.config"
 
local _M = {}


function _M.new(self)
    local red = redis:new()
    red:set_timeout(1000) -- 1 second
    local res = red:connect(config['redis']['host'], config['redis']['port'])
    if not res then 
        return nil
    end
    if config['redis']['pass'] ~= nil then
        res = red:auth(config['redis']['pass'])
        if not res then
            return nil
        end
    end
    if config['redis']['db'] ~= nil then
		red:select(config['redis']['db'])
    end  
    red.close = close
    return red
end

function close(self)
    local sock = self.sock
    if not sock then
        return nil, "not initialized"
    end
    if self.subscribed then
        return nil, "subscribed state"
    end
    return sock:setkeepalive(10000, 50)
end

return _M