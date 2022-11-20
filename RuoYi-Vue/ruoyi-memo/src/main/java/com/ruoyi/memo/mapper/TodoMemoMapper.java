package com.ruoyi.memo.mapper;

import java.util.List;
import com.ruoyi.memo.domain.TodoMemo;

/**
 * memo_infoMapper接口
 * 
 * @author alan_li
 * @date 2022-11-19
 */
public interface TodoMemoMapper 
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
     * 删除memo_info
     * 
     * @param memoId memo_info主键
     * @return 结果
     */
    public int deleteTodoMemoByMemoId(Long memoId);

    /**
     * 批量删除memo_info
     * 
     * @param memoIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTodoMemoByMemoIds(Long[] memoIds);
}
