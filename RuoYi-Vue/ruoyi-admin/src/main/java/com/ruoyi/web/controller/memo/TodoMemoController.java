package com.ruoyi.web.controller.memo;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.memo.domain.TodoMemo;
import com.ruoyi.memo.service.ITodoMemoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * memo_infoController
 *
 * @author alan_li
 * @date 2022-11-19
 */
@RestController
@RequestMapping("/memo/memo")
public class TodoMemoController extends BaseController
{
    @Autowired
    private ITodoMemoService todoMemoService;

    /**
     * 查询memo_info列表
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:list')")
    @GetMapping("/list")
    public TableDataInfo list(TodoMemo todoMemo)
    {
        startPage();
        List<TodoMemo> list = todoMemoService.selectTodoMemoList(todoMemo);
        return getDataTable(list);
    }

    /**
     * 导出memo_info列表
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:export')")
    @Log(title = "memo_info", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TodoMemo todoMemo)
    {
        List<TodoMemo> list = todoMemoService.selectTodoMemoList(todoMemo);
        ExcelUtil<TodoMemo> util = new ExcelUtil<TodoMemo>(TodoMemo.class);
        util.exportExcel(response, list, "memo_info数据");
    }

    /**
     * 获取memo_info详细信息
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:query')")
    @GetMapping(value = "/{memoId}")
    public AjaxResult getInfo(@PathVariable("memoId") Long memoId)
    {
        return success(todoMemoService.selectTodoMemoByMemoId(memoId));
    }

    /**
     * 新增memo_info
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:add')")
    @Log(title = "memo_info", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TodoMemo todoMemo)
    {
        return toAjax(todoMemoService.insertTodoMemo(todoMemo));
    }

    /**
     * 修改memo_info
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:edit')")
    @Log(title = "memo_info", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TodoMemo todoMemo)
    {
        return toAjax(todoMemoService.updateTodoMemo(todoMemo));
    }

    /**
     * 删除memo_info
     */
    @PreAuthorize("@ss.hasPermi('memo:memo:remove')")
    @Log(title = "memo_info", businessType = BusinessType.DELETE)
	@DeleteMapping("/{memoIds}")
    public AjaxResult remove(@PathVariable Long[] memoIds)
    {
        return toAjax(todoMemoService.deleteTodoMemoByMemoIds(memoIds));
    }
}
