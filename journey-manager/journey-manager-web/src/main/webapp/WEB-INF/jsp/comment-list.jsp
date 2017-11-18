<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/11/18
  Time: 12:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="comm-toolbar">
    <div style="padding: 5px; background-color: #fff;">

        <div>
            <label>评论标题:</label>
            <input class="easyui-textbox" type="text" id="title"/>

            <label>评论类型：</label>
            <select id="comment_status" class="easyui-combobox">
                <option value="0">全部</option>
                <option value="1">酒店</option>
                <option value="2">景点</option>
                <option value="3">订单</option>
            </select>
            <button type="button" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="searchForm()">
                查询
            </button>
        </div>
        <div>

            <button onclick="down()" class="easyui-linkbutton" data-options="iconCls:'icon-down',plain:true">发布</button>
            <button onclick="up()" class="easyui-linkbutton" data-options="iconCls:'icon-up',plain:true">驳回</button>

        </div>


    </div>

</div>

<table id="tb"></table>
<script>

    function up() {
        var selections = $('#tb').datagrid('getSelections');
        //  console.log(selections);
        if (selections.length == 0) {
            //客户没有选择记录
            $.messager.alert('提示', '请至少选中一条记录！');
            return;
        }
        else{
            var ids = [];
            for (var i = 0; i < selections.length; i++) {
                //console.log(selections[i].status);
                if(selections[i].status ==1){
                    $.messager.alert('提示', '请不要选择已经发布的记录！');
                    return;
                }
                ids.push(selections[i].id);
            }
            $.post(
                //  //url:请求后台的哪个地址来进行处理，相当于url,String类型
                'comments/release',
                //data:从前台提交哪些数据给后台处理，相当于data，Object类型
                {'ids[]': ids},
                //callback:后台处理成功的回调函数，相当于success，function类型
                function (data) {
                    $("#tb").datagrid("reload");
                },
                //返回数据类型
                'json'
            );
        }


    }
    function down() {
        var selections = $('#tb').datagrid('getSelections');
        //  console.log(selections);
        if (selections.length == 0) {
            //客户没有选择记录
            $.messager.alert('提示', '请至少选中一条记录！');
            return;
        }
        else{
            var ids = [];
            for (var i = 0; i < selections.length; i++) {
                //console.log(selections[i].status);
                if(selections[i].status ==2){
                    $.messager.alert('提示', '请不要选择已经下架的记录！');
                    return;
                }
                ids.push(selections[i].id);
            }
            $.post(
                //  //url:请求后台的哪个地址来进行处理，相当于url,String类型
                'comments/reject',
                //data:从前台提交哪些数据给后台处理，相当于data，Object类型
                {'ids[]': ids},
                //callback:后台处理成功的回调函数，相当于success，function类型
                function (data) {
                    $("#tb").datagrid("reload");
                },
                //返回数据类型
                'json'
            );
        }
    }
    function searchForm(){

        $('#tb').datagrid('load',{
            title:$("#title").val(),
            status:$('#comment_status').combobox("getValue")

        });

    }

    $('#tb').datagrid({

        url: 'itemsByPage',
        multiSort: true,// 允许多列排序
        pagination: true, //分页栏显示
        striped: true,//隔行变色
        rownumbers: true,//显示第几列
        fit: true,//调整面板屏幕
        pageSize: 20, //初始分页列表大小
        pageList: [20, 30, 50],
        toolbar:'#toolbar',
        /**
         * columns 工具栏
         *
         */
        columns: [[{field: 'ck', checkbox: true},
            {field: 'id', title: '商品编号', width: 100},
            {field: 'title', title: '商品名称', width: 100, sortable: true},
            {field: 'sellPoint', title: '商品卖点', width: 100, sortable: true},
            {field: 'priceView', title: '价格', width: 100},
            {field: 'catName', title: '商品分类', width: 100},
            {
                field: 'created', title: '创建时间', width: 100, formatter: function (value, row, index) {
                return moment(value).format('LL');
            }
            },
            {
                field: 'updated', title: '更新时间', width: 100, formatter: function (value, row, index) {
                return moment(value).format('LL');
            }
            },
            {
                field: 'status', title: '商品状态(前台)', width: 100,
                formatter: function (value, row, index) {
//                    console.group();
//                    console.log(value);
//                    console.log(row);
//                    console.log(index);
//                    console.groupEnd();
                    switch (value) {
                        case 1:
                            return '正常';
                            break;
                        case 2:
                            return '下架';
                            break;
                        case 3:
                            return '删除';
                            break;
                        default:
                            return '未知';
                            break;

                    }
                }
            }

        ]]

    });
</script>
