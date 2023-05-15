<template>
  <div
      @dragover.prevent
      @drop.stop="onAppDropStop(null, $event)">
    <!--背景-->
    <div>
      <Background></Background>
    </div>

    <!--备案-->
    <div>
      <Icp></Icp>
    </div>

    <!--搜索-->
    <div>
      <Search></Search>
    </div>

    <!--应用展示区域-->
    <div style="display: flex;">
      <template v-for="(a,b,c) in app_list">

        <!--应用-->
        <div
            :style="{
                  'position': a.position,
                  'left': a.left,
                  'top': a.top,
                  'width': '64px',
                }"
            :ref="`app_${a.id}`"
            :title="a.name"
            draggable="true"
            @dragover.prevent
            @dragstart="onAppDragStart(a, $event)"
            @contextmenu.stop="onAppContextmenu(a, $event)"
            @click="open(a)"
        >

          <div style="position: relative">
            <div style="height: 64px; width: 64px; display: flex; justify-content: center; align-items: center;">
              <!--图标-->
              <div
                  style="width: 54px; height: 54px; border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.2); box-shadow: 0 0 10px 1px rgba(200, 200, 200, 0.5);">
                <img
                    draggable="false"
                    :src="a.favicon" style="height: 100%; width: 100%; display: block; border-radius: 12px;"/>
              </div>
            </div>
            <div
                v-show="'1' === app_title_control_saved"
                style="height: 24px; width: 64px; display: flex; justify-content: center; align-items: baseline;">
              <!--名称-->
              <div
                  style="width: 48px; font-size: 12px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; text-align: center;">
                {{ a.name }}
              </div>
            </div>

            <!--管理-->
            <div
                v-show="a.showContextMenu"
                style="z-index: 1; position: absolute; top: 0px; left: 50px; background-color: red; white-space: nowrap">
              <div draggable="false">
                <div draggable="false">
                  <button
                      draggable="false"
                      @click="openAppSetWindow(a)">修改
                  </button>
                </div>
                <div
                    draggable="false">
                  <button
                      draggable="false"
                      @click="openAppDelWindow(a)">删除
                  </button>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!--拖动排序坑点-->
        <div
            :ref="`space-${b}`"
            @dragenter="dragEnter(b)"
            @dragleave="dragLeave(b)"
            @drop.stop="dropAppInSpace(b, a, $event)"
            style="width: 8px;">
          <div style="height: 64px; width: 64px; display: flex; justify-content: center; align-items: center;"></div>
          <div
              v-show="'1' === app_title_control_saved"
              style="height: 24px; width: 64px; display: flex; justify-content: center; align-items: baseline;"></div>
        </div>

      </template>
    </div>


    <!--弹框-->
    <!--添加-->
    <div v-show="showAppAddWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        <div>名称</div>
        <input v-model="app.name"/>
      </div>
      <div>
        <div>网址</div>
        <input v-model="app.url"/>
      </div>
      <div>
        <div>图标链接</div>
        <input v-model="app.favicon"/>
      </div>
      <div>
        <button @click="confirmAppAdd">添加</button>
        <button @click="closeAppAddWindow">取消</button>
      </div>
    </div>
    <!--修改-->
    <div v-show="showAppSetWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        <div>名称</div>
        <input v-model="app.name"/>
      </div>
      <div>
        <div>网址</div>
        <input v-model="app.url"/>
      </div>
      <div>
        <div>图标链接</div>
        <input v-model="app.favicon"/>
      </div>
      <div>
        <button @click="confirmAppSet(app)">修改</button>
        <button @click="closeAppSetWindow">取消</button>
      </div>
    </div>
    <!--删除-->
    <div v-show="showAppDelWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        您真的要删除「<span style="color: red;">{{ app.name }}</span>」吗？
      </div>
      <div>
        <button @click="confirmAppDel(app)">删除</button>
        <button @click="closeAppDelWindow">取消</button>
      </div>
    </div>
    <!--系统设置-->
    <div
        v-show="showSystemSetWindow"
        style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        <div>
          <div>图标排列规则</div>
          <select v-model="drag_rule_selected">
            <option
                v-for="(a, b, c) in drag_rule_list"
                :value="a.id"
                :key=b
            >{{ a.name }}
            </option>
          </select>
        </div>
        <div>
          <div>名称处理方案</div>
          <select v-model="app_title_control_selected">
            <option
                v-for="(a, b, c) in app_title_control_list"
                :value="a.id"
                :key=b
            >{{ a.name }}
            </option>
          </select>
        </div>
      </div>
      <div>
        <button @click="confirmSystemSet">确定</button>
        <button @click="closeSystemSetWindow">取消</button>
      </div>
    </div>
    <!--右键-->
    <div
        v-show="contextMenu.show"
        :style="{
          'top': contextMenu.display.top,
          'left': contextMenu.display.left,
        }"
        ref="context-menu"
        class="context-menu">
      <div draggable="false">
        <div draggable="false">
          <button @click="openAppAddWindow">添加应用</button>
        </div>
        <div>
          <button @click="openFolderAddWindow">添加文件夹</button>
        </div>
        <div>
          <button @click="openSystemSetWindow">系统设置</button>
        </div>
      </div>
    </div>
    <!--添加文件夹-->
    <div v-show="showFolderAddWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        <div>名称</div>
        <input v-model="folder.name"/>
      </div>
      <div>
        <button @click="confirmFolderAdd">添加</button>
        <button @click="closeFolderAWindow">取消</button>
      </div>
    </div>


  </div>
</template>

<script>
import Background from "@/component/Background.vue";
import Icp from "@/component/Icp.vue";
import Search from "@/component/Search.vue";

export default {
  name: "Index",
  components: {Search, Icp, Background},
  data() {
    return {
      showAppAddWindow: false,
      showAppSetWindow: false,
      showAppDelWindow: false,
      showSystemSetWindow: false,
      showAppRightClickWindow: false,
      showFolderAddWindow: false,

      contextMenu: {
        show: false,
        display: {
          top: "0px",
          left: "0px",
        },
      },

      folder: {
        id: 0,
        name: "",
        url: "",
        favicon: "",
        position: "",
        left: "0",
        top: "0",
        showContextMenu: false,
        type: 2, // 文件夹
      },

      app: {
        id: 0,
        name: "",
        url: "",
        favicon: "",
        position: "",
        left: "0",
        top: "0",
        showContextMenu: false,
        type: 1, // 应用
      },
      app_list: [],
      drag_rule_list: [
        {
          id: "1",
          name: "自动排列",
        },
        {
          id: "2",
          name: "自由放置",
        },
      ],
      app_title_control_list: [
        {
          id: "1",
          name: "展示",
        },
        {
          id: "2",
          name: "隐藏",
        },
      ],
      drag_rule_selected: "1",
      app_title_control_selected: "1",
      app_title_control_saved: "1",
      ex: 0,
      ey: 0,
      wx: 0,
      wy: 0,
    };
  },
  methods: {
    init() {
      this.app_list = JSON.parse(window.localStorage.getItem("ziji.app_list")) || [];
      this.drag_rule_selected = window.localStorage.getItem("ziji.drag_rule_selected") || "1";
      this.app_title_control_selected = this.app_title_control_saved = window.localStorage.getItem("ziji.app_title_control_saved") || "1";
      window.onclick = (event) => {
        event.preventDefault();
        event.stopPropagation();
        this.setAllAppShowContextMenuFalse();
        this.contextMenu.show = false;
      }
      window.oncontextmenu = (event) => {
        event.preventDefault();
        event.stopPropagation();
        this.setAllAppShowContextMenuFalse();
        this.contextMenu.display.top = event.clientY + "px";
        this.contextMenu.display.left = event.clientX + "px";
        this.contextMenu.show = true;
      }
    },
    open(app) {
      window.open(app.url)
    },
    save() {
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.$forceUpdate();
    },
    /**
     * 当应用被拖动开始时
     * @param app
     * @param event
     */
    onAppDragStart(app, event) {
      event.dataTransfer.setData("app.id", app.id);
      this.ex = event.clientX;
      this.ey = event.clientY;
      this.wx = this.$refs[`app_${app.id}`][0].offsetLeft;
      this.wy = this.$refs[`app_${app.id}`][0].offsetTop;
    },
    /**
     * 当应用被拖动结束时（拖放）
     * @param app
     * @param event
     */
    onAppDropStop(app, event) {

      // 自由放置
      if (this.drag_rule_selected !== "2") {
        return;
      }

      // 来源
      let dragId = ""
          , drag = null
          , dragIndex = 0
      ;
      dragId = event.dataTransfer.getData("app.id");
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === dragId) {
          dragIndex = i;
          drag = this.app_list[i];
          break;
        }
      }


      let left = event.clientX - this.ex + this.wx;
      let top = event.clientY - this.ey + this.wy;
      this.app_list[dragIndex].position = "absolute";
      this.app_list[dragIndex].left = left + "px";
      this.app_list[dragIndex].top = top + "px";
      this.save();

      //
      // if (null === app) {
      //   return;
      // }
      //
      // let dropId = app.id;
      // if (dragId === dropId) {
      //   // A到A，无意义的操作
      //   return;
      // }
      //
      // // 目标
      // let drop;
      // let dropIndex = 0;
      // for (let i = 0; i < this.app_list.length; i++) {
      //   if (this.app_list[i].id === dropId) {
      //     dropIndex = i;
      //     drop = this.app_list[i];
      //     break;
      //   }
      // }
      //
      // if (dragIndex > dropIndex) {
      //   // 向前拖动
      //   // 先删除，后插入，索引不变
      //   this.app_list.splice(dragIndex, 1);
      //   this.app_list.splice(dropIndex, 0, drag);
      //
      // } else {
      //   // 向后拖动
      //   // 先插入，后删除，索引不变
      //   this.app_list.splice(dropIndex, 0, drag);
      //   this.app_list.splice(dragIndex, 1);
      //
      // }

      // this.save();

    },
    /**
     * 打开添加应用窗口
     */
    openAppAddWindow() {
      this.app = {
        id: ((new Date()).getTime() + Math.random() * 1000000).toString().replace(".", ""),
        name: "",
        url: "",
        favicon: "",
        position: "",
        left: "0",
        top: "0",
        showContextMenu: false,
        type: 1, // 应用
      };
      this.showAppAddWindow = true;
      this.$forceUpdate();
    },
    /**
     * 确定添加应用
     */
    confirmAppAdd() {
      this.app_list.push(JSON.parse(JSON.stringify(this.app)));
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showAppAddWindow = false;
      this.$forceUpdate();
    },
    /**
     * 关闭添加应用窗口
     */
    closeAppAddWindow() {
      this.showAppAddWindow = false;
      this.$forceUpdate();
    },
    /**
     * 打开修改应用窗口
     * @param app
     */
    openAppSetWindow(app) {
      this.app = JSON.parse(JSON.stringify(app))
      this.showAppSetWindow = true;
      this.$forceUpdate();
    },
    /**
     * 确认修改应用
     * @param app
     */
    confirmAppSet(app) {
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === app.id) {
          this.app_list[i] = app;
        }
      }
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showAppSetWindow = false;
      this.$forceUpdate();
    },
    /**
     * 关闭修改应用窗口
     */
    closeAppSetWindow() {
      this.showAppSetWindow = false;
      this.$forceUpdate();
    },
    /**
     * 打开删除应用窗口
     * @param app
     */
    openAppDelWindow(app) {
      this.app = app;
      this.showAppDelWindow = true;
      this.$forceUpdate();
    },
    /**
     * 确认删除应用
     * @param app
     */
    confirmAppDel(app) {
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i]) {
          if (this.app_list[i].id === app.id) {
            this.app_list.splice(i, 1);
            break;
          }
        }
      }
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showAppDelWindow = false;
      this.$forceUpdate();
    },
    /**
     * 关闭删除应用窗口
     */
    closeAppDelWindow() {
      this.showAppDelWindow = false;
      this.$forceUpdate();
    },
    /**
     * 打开修改系统窗口
     */
    openSystemSetWindow() {
      this.showSystemSetWindow = true;
    },
    /**
     * 确认修改系统
     */
    confirmSystemSet() {
      if (this.drag_rule_selected === "1") {
        this.app_list.forEach((app) => {
          app.position = "";
          app.left = "";
          app.top = "";
        });
      }
      this.app_title_control_saved = this.app_title_control_selected;
      window.localStorage.setItem("ziji.drag_rule_selected", this.drag_rule_selected);
      window.localStorage.setItem("ziji.app_title_control_saved", this.app_title_control_saved);
      this.showSystemSetWindow = false;
      this.save();
    },
    /**
     * 关闭系统修改窗口
     */
    closeSystemSetWindow() {
      this.showSystemSetWindow = false;
    },
    onAppContextmenu(app, event) {
      event.preventDefault();
      for (let i = 0; i < this.app_list.length; i++) {
        if (app.id === this.app_list[i].id) {
          this.app_list[i].showContextMenu = true;
        } else {
          this.app_list[i].showContextMenu = false;
        }
      }
      this.$forceUpdate();
    },
    setAllAppShowContextMenuFalse() {
      for (let i = 0; i < this.app_list.length; i++) {
        this.app_list[i].showContextMenu = false;
      }
      this.$forceUpdate();
    },
    openFolderAddWindow() {
      this.folder = {
        id: ((new Date()).getTime() + Math.random() * 1000000).toString().replace(".", ""),
        name: "未命名",
        url: "",
        favicon: "",
        position: "",
        left: "0",
        top: "0",
        showContextMenu: false,
        type: 2,
      };
      this.showFolderAddWindow = true;
    },
    confirmFolderAdd() {
      this.app_list.push(JSON.parse(JSON.stringify(this.folder)));
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showFolderAddWindow = false;
      this.$forceUpdate();
    },
    closeFolderAWindow() {
      this.showFolderAddWindow = false;
    },
    dragEnter(index) {
      if (this.drag_rule_selected === "2") {
        return;
      }
      this.$refs[`space-${index}`][0].style.width = "64px"
    },
    dragLeave(index) {
      this.$refs[`space-${index}`][0].style.width = "8px"
    },

    /**
     * 将APP放置到空隙上
     * @param index
     * @param app
     * @param event
     */
    dropAppInSpace(dropIndex, app, event) {

      if (this.drag_rule_selected === "2") {
        this.onAppDropStop(app, event);
        return;
      }

      this.$refs[`space-${dropIndex}`][0].style.width = "8px";

      // 来源
      let dragId = ""
          , drag = null
          , dragIndex = 0
      ;
      dragId = event.dataTransfer.getData("app.id");
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === dragId) {
          dragIndex = i;
          drag = this.app_list[i];
          break;
        }
      }

      if (dragIndex === dropIndex) {
        return;
      }

      // 目标
      let drop = this.app_list[dropIndex];

      if (dragIndex > dropIndex) {
        // 向前拖动
        // 先删除，后插入，索引不变
        this.app_list.splice(dragIndex, 1);
        this.app_list.splice(dropIndex + 1, 0, drag);

      } else {
        // 向后拖动
        // 先插入，后删除，索引不变
        this.app_list.splice(dropIndex + 1, 0, drag);
        this.app_list.splice(dragIndex, 1);

      }

      this.save();

    },
  },
  created() {
    this.init();
  },
}
</script>

<style scoped>
.app {
  width: 70px;
  height: 90px;
  border: 1px solid red;
  justify-content: center;
}

.app .favicon {
  z-index: 0;
  width: 50px;
  height: 50px;
  border: 1px solid red;
  border-radius: 10px;
}

.app-space {
  display: block;
  width: 70px;
  height: 90px;
  background-color: red;
}


.context-menu {
  z-index: 1;
  position: absolute;
  background-color: red;
  white-space: nowrap;
}

.folder {

}
</style>