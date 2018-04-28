var apiWechatHost = 'https://www.xueyanshe.com/todolist/public/index.php';
var apiHost = 'http://47.52.145.61'
apiHost = 'http://localhost:81'

function error(msg) {
  wx.showToast({
    title: msg,
    image: '/static/img/error.png',
    duration: 3000
  })
}

function success(msg) {
  wx.showToast({
    title: msg,
    icon: 'success',
    duration: 3000
  })
}

function isLogin(){
  try {
    var value = wx.getStorageSync('userinfo')
    if (value) {
       return JSON.parse(value)
    }else{
      return false
    }
  } catch (e) {
    console.log('getStorageSync err')
  }
}

function getOpenId(callback) {
  var openid = wx.getStorageSync('openid');
  if (openid) {
    if (callback) {
      callback(openid)
    }
    return openid;
  } else {
    wx.login({
      success: function (res) {

        if (res.code) {
          //发起网络请求 
          wx.request({
            url: apiWechatHost + '?s=/index/index/getOpenid&code=' + res.code,
            header: {
              'content-type': 'application/json'
            },
            success: function (rs) {
              var openid = rs.data.openid;
              if (callback) {
                callback(openid)
              }
              wx.setStorageSync('openid', openid)
            },
            fail: function (rs) {
              error(rs.errMsg)
            }
          })
        } else {
          error('用户信息获取失败')
        }
      }
    });
  }
}

module.exports = {
  apiHost: apiHost,
  error: error,
  success: success,
  getOpenId: getOpenId,
  isLogin: isLogin
}

Date.prototype.Format = function (fmt) { //author: meizz 
  var o = {
    "M+": this.getMonth() + 1, //月份 
    "d+": this.getDate(), //日 
    "h+": this.getHours(), //小时 
    "m+": this.getMinutes(), //分 
    "s+": this.getSeconds(), //秒 
    "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
    "S": this.getMilliseconds() //毫秒 
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
  return fmt;
}