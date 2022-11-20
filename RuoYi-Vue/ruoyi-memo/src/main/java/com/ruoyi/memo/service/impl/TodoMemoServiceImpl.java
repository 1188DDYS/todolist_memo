package com.ruoyi.memo.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.memo.mapper.TodoMemoMapper;
import com.ruoyi.memo.domain.TodoMemo;
import com.ruoyi.memo.service.ITodoMemoService;

/**
 * memo_infoService业务层处理
 * 
 * @author alan_li
 * @date 2022-11-19
 */
@Service
public class TodoMemoServiceImpl implements ITodoMemoService 
{
    @Autowired
    private TodoMemoMapper todoMemoMapper;

    /**
     * 查询memo_info
     * 
     * @param memoId memo_info主键
     * @return memo_info
     */
    @Override
    public TodoMemo selectTodoMemoByMemoId(Long memoId)
    {
        return todoMemoMapper.selectTodoMemoByMemoId(memoId);
    }

    /**
     * 查询memo_info列表
     * 
     * @param todoMemo memo_info
     * @return memo_info
     */
    @Override
    public List<TodoMemo> selectTodoMemoList(TodoMemo todoMemo)
    {
        return todoMemoMapper.selectTodoMemoList(todoMemo);
    }

    /**
     * 新增memo_info
     * 
     * @param todoMemo memo_info
     * @return 结果
     */
    @Override
    public int insertTodoMemo(TodoMemo todoMemo)
    {
        todoMemo.setCreateTime(DateUtils.getNowDate());
        return todoMemoMapper.insertTodoMemo(todoMemo);
    }

    /**
     * 修改memo_info
     * 
     * @param todoMemo memo_info
     * @return 结果
     */
    @Override
    public int updateTodoMemo(TodoMemo todoMemo)
    {
        todoMemo.setUpdateTime(DateUtils.getNowDate());
        return todoMemoMapper.updateTodoMemo(todoMemo);
    }

    /**
     * 批量删除memo_info
     * 
     * @param memoIds 需要删除的memo_info主键
     * @return 结果
     */
    @Override
    public int deleteTodoMemoByMemoIds(Long[] memoIds)
    {
        return todoMemoMapper.deleteTodoMemoByMemoIds(memoIds);
    }

    /**
     * 删除memo_info信息
     * 
     * @param memoId memo_info主键
     * @return 结果
     */
    @Override
    public int deleteTodoMemoByMemoId(Long memoId)
    {
        return todoMemoMapper.deleteTodoMemoByMemoId(memoId);
    }
}
