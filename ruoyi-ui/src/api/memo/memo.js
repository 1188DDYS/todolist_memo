import request from '@/utils/request'

// 查询memo_info列表
export function listMemo(query) {
  return request({
    url: '/memo/memo/list',
    method: 'get',
    params: query
  })
}

// 查询memo_info详细
export function getMemo(memoId) {
  return request({
    url: '/memo/memo/' + memoId,
    method: 'get'
  })
}

// 新增memo_info
export function addMemo(data) {
  return request({
    url: '/memo/memo',
    method: 'post',
    data: data
  })
}

// 修改memo_info
export function updateMemo(data) {
  return request({
    url: '/memo/memo',
    method: 'put',
    data: data
  })
}

// 删除memo_info
export function delMemo(memoId) {
  return request({
    url: '/memo/memo/' + memoId,
    method: 'delete'
  })
}
