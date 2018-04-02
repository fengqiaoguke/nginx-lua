### 标签列表接口

```
GET /tag
```

### 参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| fid | int | \[可选\]标签父id |
| uid | int | \[可选\]用户id |

### 返回参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| id | int |  |
| uid | int |  |
| fid | int |  |
| name | string |  |

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
http://www.domain.com/v1/tag
```



