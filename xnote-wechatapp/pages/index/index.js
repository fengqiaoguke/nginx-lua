var util = require('../../utils/util.js');
const app = getApp()

Page({
  data: {
    userInfo: {},
    loginUrl:''
  },
  onLoad: function () {
    var that = this
    var userInfo = util.isLogin()
    this.setData({ userInfo: userInfo })
  },

  login: function (rs) {
    var userInfo = rs.detail.userInfo
    var that = this
    console.log(rs)
    util.getOpenId(function (openid) {

      var username = userInfo.nickName
      var avatar = userInfo.avatarUrl

      wx.request({
        url: util.apiHost + '/session/wechat',
        data: {
          openid: openid,
          username: username,
          avatar: avatar
        },
        method: 'POST',
        header: {
          'content-type': 'application/json' // 默认值
        },
        success: function (res) {
          if (res.data.code >= 0) {
            var data = { utoken: res.data.data.utoken, avatar: avatar, username: username }
            console.log(avatar)
            wx.setStorageSync('userinfo', JSON.stringify(data))
            that.setData({ userInfo: data })
          }
        }
      })

    })
  },
  scan() {
    var that = this
    wx.scanCode({
      onlyFromCamera: true,
      success: (res) => {
        var url = res.result+that.data.userInfo.utoken
        that.setData({loginUrl:url})
      }
    })
  },
  loginWeb(){
    var that = this
    if (!that.data.loginUrl){
      util.error('请重新扫码')
      return
    }
    wx.request({
      url: that.data.loginUrl,
      success: function (res) {
        if (res.data.code >= 0) {
          that.setData({loginUrl:''})
        }
      }
    })
  },
  logout() {
    wx.removeStorageSync('userinfo')
    this.setData({ userInfo: {} })
  }
})
