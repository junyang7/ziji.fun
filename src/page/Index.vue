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
            style="border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 10px;"
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
        <div>拖动规则</div>
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
      },
      app_list: [],
      drag_rule_list: [
        {
          id: "1",
          name: "流式排序",
        },
        {
          id: "2",
          name: "绝对定位",
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
    openAppAddWindow() {
      this.app = {
        id: ((new Date()).getTime() + Math.random() * 1000000).toString().replace(".", ""),
        name: "",
        url: "",
        favicon: "",
      };
      this.showAppAddWindow = true;
      this.$forceUpdate();
    },
    confirmAppAdd() {
      this.app_list.push(JSON.parse(JSON.stringify(this.app)));
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showAppAddWindow = false;
      this.$forceUpdate();
    },
    closeAppAddWindow() {
      this.showAppAddWindow = false;
      this.$forceUpdate();
    },
    open(app) {
      window.open(app.url)
    },
    openAppSetWindow(app) {
      this.app = JSON.parse(JSON.stringify(app))
      this.showAppSetWindow = true;
      this.$forceUpdate();
    },
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
    closeAppSetWindow() {
      this.showAppSetWindow = false;
      this.$forceUpdate();
    },
    openAppDelWindow(app) {
      this.app = app;
      this.showAppDelWindow = true;
      this.$forceUpdate();
    },
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
    closeAppDelWindow() {
      this.showAppDelWindow = false;
      this.$forceUpdate();
    },
    onAppDragStart(app, event) {
      event.dataTransfer.setData("app.id", app.id);
      this.ex = event.clientX;
      this.ey = event.clientY;
      this.wx = this.$refs[`app_${app.id}`][0].offsetLeft;
      this.wy = this.$refs[`app_${app.id}`][0].offsetTop;
    },
    onAppDropStop(app, event) {

      // 来源
      let dragId, drag, dragIndex;
      dragId = event.dataTransfer.getData("app.id");
      dragIndex = 0;
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === dragId) {
          dragIndex = i;
          drag = this.app_list[i];
          break;
        }
      }

      if (app === null && this.drag_rule_selected === "2") {
        let left = event.clientX - this.ex + this.wx;
        let top = event.clientY - this.ey + this.wy;
        this.$refs[`app_${dragId}`][0].style.position = "absolute"
        this.$refs[`app_${dragId}`][0].style.left = left + "px";
        this.$refs[`app_${dragId}`][0].style.top = top + "px";
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

    save() {
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.$forceUpdate();
    },

    openSystemSetWindow() {
      this.showSystemSetWindow = true;
    },

    confirmSystemSet() {
      window.localStorage.setItem("ziji.drag_rule_selected", this.drag_rule_selected);
      this.showSystemSetWindow = false;
    },
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