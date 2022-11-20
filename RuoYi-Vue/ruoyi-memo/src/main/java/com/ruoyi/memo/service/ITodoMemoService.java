package com.ruoyi.memo.service;

import java.util.List;
import com.ruoyi.memo.domain.TodoMemo;

/**
 * memo_infoService接口
 * 
 * @author alan_li
 * @date 2022-11-19
 */
public interface ITodoMemoService 
{
    /**
     * 查询memo_info
     * 
     * @param memoId memo_info主键
     * @return memo_info
     */
    public TodoMemo selectTodoMemoByMemoId(Long memoId);

    /**
     * 查询memo_info列表
     * 
     * @param todoMemo memo_info
     * @return memo_info集合
     */
    public List<TodoMemo> selectTodoMemoList(TodoMemo todoMemo);

    /**
     * 新增memo_info
     * 
     * @param todoMemo memo_info
     * @return 结果
     */
    public int insertTodoMemo(TodoMemo todoMemo);

    /**
     * 修改memo_info
     * 
     * @param todoMemo memo_info
     * @return 结果
     */
    public int updateTodoMemo(TodoMemo todoMemo);

    /**
     * 批量删除memo_info
     * 
     * @param memoIds 需要删除的memo_info主键集合
     * @return 结果
     */
    public int deleteTodoMemoByMemoIds(Long[] memoIds);

    /**
     * 删除memo_info信息
     * 
     * @param memoId memo_info主键
     * @return 结果
     */
    public int deleteTodoMemoByMemoId(Long memoId);
}
