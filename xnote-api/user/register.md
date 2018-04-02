### 用户注册接口

```
POST /user
```

### 参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| username | string | 3~50个字母、数字和中文 |
| password | string | 8~50个字符串 |

### 返回参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| uid | int |  |
| username | string |  |

### 返回格式

```js
HTTP/1.1 200 OK
{
"code": "0",
"msg": "提示信息",
"data":{}
}
```

### 例子

```js
http://www.domain.com/v1/user
```



