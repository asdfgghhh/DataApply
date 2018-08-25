<%--
  Created by IntelliJ IDEA.
  User: pangbo
  Date: 2015/11/17
  Time: 22:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>menu</title>
  <script type="text/javascript" src="jquery-1.8.2.js"></script>
  <script type="text/javascript" src="jquery.ztree.all-3.5.js"></script>
  <link href="zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css">
  <%
      //防止用户非法访问当前页面
      Map user = (Map) session.getAttribute("userSessionInfo");
      if(user == null)
      {
        //重定向方式待查
        response.sendRedirect("http://192.168.7.234:8080/MapTest/js/login/login.jsp");
      }
  %>
  <style>
    html,body{ height:100%;margin:0}
    div{margin: 0;padding:0}
    div#menuDiv{
      background-color: #9bc6ff;
      width: 25%;
      height: 100%;
      overflow: scroll;
      float: left;
    }
    div#menuContainer{
      background-color: #00B83F;
      width: 100%;
      height: 100%;

    }
    IFRAME#contentIframe{
      background-color: gray;
      width: 75%;
      height: 100%;
      Float:left;
      overflow: scroll;
    }
    div#clear{
      clear: both;
    }
    div#tree{
        font-size: 30px;
    }
    div.ztree li a{text-decoration:none;}
  </style>
  <script type="text/javascript">
    var serviceUrl = "http://192.168.7.234:8080/MapTest/";
    $(document).ready(function () {

      var setting = {
        view: {
          dblClickExpand: false,
          showLine: true,
          selectedMulti: false
        },
        data: {
          simpleData: {
            enable: true,
            idKey: "id",
            pIdKey: "pId",
            rootPId: ""
          }
        },
        callback: {
          onClick: zTreeOnClick
        }
      };

      /*var zNodes = [
       { id: 1, pId: 0, name: "[core] 基本功能 演示" },
       { id: 101, pId: 1, name: "最简单的树 --  标准 JSON 数据" },
       { id: 102, pId: 1, name: "最简单的树 --  简单 JSON 数据" },
       { id: 1021, pId: 102, name: "hello pangbo" ,isLeaf:"1"},
       { id: 103, pId: 1, name: "不显示 连接线" },
       { id: 104, pId: 1, name: "不显示 节点 图标" },
       { id: 105, pId: 1, name: "自定义图标 --  icon 属性" },
       { id: 106, pId: 1, name: "自定义图标 --  iconSkin 属性" },
       { id: 107, pId: 1, name: "自定义字体" },
       { id: 115, pId: 1, name: "超链接演示" },
       { id: 108, pId: 1, name: "异步加载 节点数据" },
       { id: 109, pId: 1, name: "用 zTree 方法 异步加载 节点数据" },
       { id: 110, pId: 1, name: "用 zTree 方法 更新 节点数据" },
       { id: 111, pId: 1, name: "单击 节点 控制" },
       { id: 112, pId: 1, name: "展开 / 折叠 父节点 控制" },
       { id: 113, pId: 1, name: "根据 参数 查找 节点" },
       { id: 114, pId: 1, name: "其他 鼠标 事件监听" },

       { id: 2, pId: 0, name: "[excheck] 复/单选框功能 演示" },
       { id: 201, pId: 2, name: "Checkbox 勾选操作" },
       { id: 206, pId: 2, name: "Checkbox nocheck 演示" },
       { id: 207, pId: 2, name: "Checkbox chkDisabled 演示" },
       { id: 208, pId: 2, name: "Checkbox halfCheck 演示" },
       { id: 202, pId: 2, name: "Checkbox 勾选统计" },
       { id: 203, pId: 2, name: "用 zTree 方法 勾选 Checkbox" },
       { id: 204, pId: 2, name: "Radio 勾选操作" },
       { id: 209, pId: 2, name: "Radio nocheck 演示" },
       { id: 210, pId: 2, name: "Radio chkDisabled 演示" },
       { id: 211, pId: 2, name: "Radio halfCheck 演示" },
       { id: 205, pId: 2, name: "用 zTree 方法 勾选 Radio" },

       { id: 3, pId: 0, name: "[exedit] 编辑功能 演示", open: false },
       { id: 301, pId: 3, name: "拖拽 节点 基本控制", file: "exedit/drag" },
       { id: 302, pId: 3, name: "拖拽 节点 高级控制", file: "exedit/drag_super" },
       { id: 303, pId: 3, name: "用 zTree 方法 移动 / 复制 节点", file: "exedit/drag_fun" },
       { id: 304, pId: 3, name: "基本 增 / 删 / 改 节点", file: "exedit/edit" },
       { id: 305, pId: 3, name: "高级 增 / 删 / 改 节点", file: "exedit/edit_super" },
       { id: 306, pId: 3, name: "用 zTree 方法 增 / 删 / 改 节点", file: "exedit/edit_fun" },
       { id: 307, pId: 3, name: "异步加载 & 编辑功能 共存", file: "exedit/async_edit" },
       { id: 308, pId: 3, name: "多棵树之间 的 数据交互", file: "exedit/multiTree" },

       { id: 4, pId: 0, name: "大数据量 演示", open: false },
       { id: 401, pId: 4, name: "一次性加载大数据量", file: "bigdata/common" },
       { id: 402, pId: 4, name: "分批异步加载大数据量", file: "bigdata/diy_async" },
       { id: 403, pId: 4, name: "分批异步加载大数据量", file: "bigdata/page" },

       { id: 5, pId: 0, name: "组合功能 演示", open: false },
       { id: 501, pId: 5, name: "冻结根节点", file: "super/oneroot" },
       { id: 502, pId: 5, name: "单击展开/折叠节点", file: "super/oneclick" },
       { id: 503, pId: 5, name: "保持展开单一路径", file: "super/singlepath" },
       { id: 504, pId: 5, name: "添加 自定义控件", file: "super/diydom" },
       { id: 505, pId: 5, name: "checkbox / radio 共存", file: "super/checkbox_radio" },
       { id: 506, pId: 5, name: "左侧菜单", file: "super/left_menu" },
       { id: 513, pId: 5, name: "OutLook 样式的左侧菜单", file: "super/left_menuForOutLook" },
       { id: 507, pId: 5, name: "下拉菜单", file: "super/select_menu" },
       { id: 509, pId: 5, name: "带 checkbox 的多选下拉菜单", file: "super/select_menu_checkbox" },
       { id: 510, pId: 5, name: "带 radio 的单选下拉菜单", file: "super/select_menu_radio" },
       { id: 508, pId: 5, name: "右键菜单 的 实现", file: "super/rightClickMenu" },
       { id: 511, pId: 5, name: "与其他 DOM 拖拽互动", file: "super/dragWithOther" },
       { id: 512, pId: 5, name: "异步加载模式下全部展开", file: "super/asyncForAll" },

       { id: 6, pId: 0, name: "其他扩展功能 演示", open: false ,url:"http://www.baidu.com"},
       { id: 601, pId: 6, name: "隐藏普通节点", file: "exhide/common" },
       { id: 602, pId: 6, name: "配合 checkbox 的隐藏", file: "exhide/checkbox" },
       { id: 603, pId: 6, name: "配合 radio 的隐藏", file: "exhide/radio" }
       ];*/
      var zNodes;
      $.ajax({
        async : false,
        cache:false,
        type: 'POST',
        dataType : "json",
        url: serviceUrl + "getPrivilegeTree.action",//请求的action路径
        error: function () {//请求失败处理函数
          alert('请求失败');
        },
        success:function(data){ //请求成功后处理函数。
          zNodes = data;   //把后台封装好的简单Json格式赋给treeNodes
        }
      });
      var t = $("#tree");
      t = $.fn.zTree.init(t, setting, zNodes);


    })//end document.ready
    function zTreeOnClick(event, treeId, treeNode) {
      if(treeNode.isFunNode == true) {
        //alert(treeNode.tId + ", " + treeNode.name);
        $("#contentIframe").attr("SRC",treeNode.linkedPage);
      }
    };
  </script>

</head>
<body>
<div id="menuContainer">
  <div id="menuDiv">
    <ul id="tree" class="ztree"></ul>
  </div>
  <IFRAME id="contentIframe" Name="testIframe" FRAMEBORDER=0   SRC="">
  </IFRAME>
  <div id="clear">
  </div>
</div>

</body>
</html>
