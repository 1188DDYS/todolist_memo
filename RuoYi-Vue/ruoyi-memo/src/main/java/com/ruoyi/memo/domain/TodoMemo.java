package com.ruoyi.memo.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * memo_info对象 todo_memo
 * 
 * @author alan_li
 * @date 2022-11-19
 */
public class TodoMemo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long memoId;

    /** name */
    @Excel(name = "name")
    private String memoName;

    /** description */
    @Excel(name = "description")
    private String description;

    /** contact */
    @Excel(name = "contact")
    private String contact;

    /** phone */
    @Excel(name = "phone")
    private String phone;

    /** type */
    @Excel(name = "type")
    private String memoType;

    /** status */
    @Excel(name = "status")
    private String status;

    /** due_time */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "due_time", width = 30, dateFormat = "yyyy-MM-dd")
    private Date dueTime;

    public void setMemoId(Long memoId) 
    {
        this.memoId = memoId;
    }

    public Long getMemoId() 
    {
        return memoId;
    }
    public void setMemoName(String memoName) 
    {
        this.memoName = memoName;
    }

    public String getMemoName() 
    {
        return memoName;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setContact(String contact) 
    {
        this.contact = contact;
    }

    public String getContact() 
    {
        return contact;
    }
    public void setPhone(String phone) 
    {
        this.phone = phone;
    }

    public String getPhone() 
    {
        return phone;
    }
    public void setMemoType(String memoType) 
    {
        this.memoType = memoType;
    }

    public String getMemoType() 
    {
        return memoType;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setDueTime(Date dueTime) 
    {
        this.dueTime = dueTime;
    }

    public Date getDueTime() 
    {
        return dueTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("memoId", getMemoId())
            .append("memoName", getMemoName())
            .append("description", getDescription())
            .append("contact", getContact())
            .append("phone", getPhone())
            .append("memoType", getMemoType())
            .append("status", getStatus())
            .append("dueTime", getDueTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
