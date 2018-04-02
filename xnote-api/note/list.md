### 笔记列表接口

```
GET /note
```

### 参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| tag_id | int | \[可选\]标签id |
| uid | int | \[可选\]用户id |



### 返回参数

| **参数** | **类型** | **描述** |
| :--- | :--- | :--- |
| title| string | 标题 |
| uid | int | 用户id |
| content | text | 笔记内容 |
| tag_id | int |  标签id |



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
http://www.domain.com/v1/user/login
```



