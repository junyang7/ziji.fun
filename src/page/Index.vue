<template>
  <div @dragover.prevent
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

    <div>
      <button @click="openAppAddWindow">添加</button>
      <button @click="openSystemSetWindow">设置</button>
    </div>

    <!--应用展示区域-->
    <div style="border: 1px solid red; display: inline-block">
      <template v-for="(a,b,c) in app_list">

        <!--应用-->
        <div
            :ref="`app_${a.id}`"
            :style="{
              'border': '1px solid red',
              'display': 'inline-block',
              'box-sizing': 'border-box',
              'padding': '10px',
              'position': a.position,
              'left': a.left,
              'top': a.top,
            }"
            draggable="true"
            @dragover.prevent
            @dragstart="onAppDragStart(a, $event)"
            @drop.stop="onAppDropStop(a, $event)"
        >
          <div
              draggable="false"
              @click="open(a)"
              style="width: 50px; height: 50px; border: 1px solid red;">
            <img
                draggable="false"
                :src="a.favicon" style="width: 100%; height: 100%;"/>
          </div>
          <div
              draggable="false"
              style="text-align: center;">{{ a.name }}
          </div>
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
    <div v-show="showSystemSetWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
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
        <button @click="confirmSystemSet">确定</button>
        <button @click="closeSystemSetWindow">取消</button>
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
      app: {
        id: 0,
        name: "",
        url: "",
        favicon: "",
        position: "",
        left: "0",
        top: "0",
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
      drag_rule_selected: "1",
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

      // 自由放置
      if (this.drag_rule_selected === "2") {
        let left = event.clientX - this.ex + this.wx;
        let top = event.clientY - this.ey + this.wy;
        this.app_list[dragIndex].position = "absolute";
        this.app_list[dragIndex].left = left + "px";
        this.app_list[dragIndex].top = top + "px";
        this.save();
        return;
      }

      if (null === app) {
        return;
      }

      let dropId = app.id;
      if (dragId === dropId) {
        // A到A，无意义的操作
        return;
      }

      // 目标
      let drop;
      let dropIndex = 0;
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === dropId) {
          dropIndex = i;
          drop = this.app_list[i];
          break;
        }
      }

      if (dragIndex > dropIndex) {
        // 向前拖动
        // 先删除，后插入，索引不变
        this.app_list.splice(dragIndex, 1);
        this.app_list.splice(dropIndex, 0, drag);

      } else {
        // 向后拖动
        // 先插入，后删除，索引不变
        this.app_list.splice(dropIndex, 0, drag);
        this.app_list.splice(dragIndex, 1);

      }

      this.save();

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
        this.save();
      }
      window.localStorage.setItem("ziji.drag_rule_selected", this.drag_rule_selected);
      this.showSystemSetWindow = false;
    },
    /**
     * 关闭系统修改窗口
     */
    closeSystemSetWindow() {
      this.showSystemSetWindow = false;
    },
  },
  created() {
    this.init();
  },
}
</script>

<style scoped>

</style>