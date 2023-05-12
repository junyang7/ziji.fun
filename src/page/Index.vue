<template>
  <div>

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
    </div>

    <!--应用展示区域-->
    <div>
      <template v-for="(a,b,c) in app_list">

        <!--应用-->
        <div
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
      app: {
        id: 0,
        name: "",
        url: "",
        favicon: "",
      },
      app_list: [],
    };
  },
  methods: {
    init() {
      this.app_list = JSON.parse(window.localStorage.getItem("ziji.app_list")) || [];
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
    },
    onAppDropStop(app, event) {

      let dragId = event.dataTransfer.getData("app.id");
      let dropId = app.id;
      if (dragId === dropId) {
        // A到A，无意义的操作
        return;
      }

      // 来源
      let drag;
      let dragIndex = 0;
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === dragId) {
          dragIndex = i;
          drag = this.app_list[i];
          break;
        }
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

  },
  created() {
    this.init();
  },
}
</script>

<style scoped>

</style>