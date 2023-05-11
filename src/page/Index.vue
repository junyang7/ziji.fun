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
      <button @click="openAddWindow">添加</button>
    </div>


    <div>
      <template v-for="(a,b,c) in app_list">
        <div v-if="a"
             style="border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 10px;">
          <div
              @click="open(a)"
              style="width: 50px; height: 50px; border: 1px solid red;">
            <img :src="a.favicon" style="width: 100%; height: 100%;"/>
          </div>
          <div style="text-align: center;">{{ a.name }}</div>
          <div>
            <div>
              <button @click="openSetWindow(a)">修改</button>
            </div>
            <div>
              <button @click="openDelWindow(a)">删除</button>
            </div>
          </div>
        </div>
      </template>
    </div>

    <!--弹框-->
    <!--添加-->
    <div v-show="showAddWindow"
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
        <button @click="confirmAdd">添加</button>
        <button @click="closeAddWindow">取消</button>
      </div>
    </div>
    <!--修改-->
    <div v-show="showSetWindow"
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
        <button @click="confirmSet(app)">修改</button>
        <button @click="closeSetWindow">取消</button>
      </div>
    </div>
    <!--删除-->
    <div v-show="showDelWindow"
         style="position: fixed; border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 36px; background-color: #ffffff;">
      <div>
        您真的要删除「<span style="color: red;">{{ app.name }}</span>」吗？
      </div>
      <div>
        <button @click="confirmDel(app)">删除</button>
        <button @click="closeDelWindow">取消</button>
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
      showAddWindow: false,
      showSetWindow: false,
      showDelWindow: false,
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
    openAddWindow() {
      this.app = {
        id: ((new Date()).getTime() + Math.random() * 1000000).toString().replace(".", ""),
        name: "",
        url: "",
        favicon: "",
      };
      this.showAddWindow = true;
      this.$forceUpdate();
    },
    confirmAdd() {
      this.app_list.push(JSON.parse(JSON.stringify(this.app)));
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showAddWindow = false;
      this.$forceUpdate();
    },
    closeAddWindow() {
      this.showAddWindow = false;
      this.$forceUpdate();
    },
    open(app) {
      window.open(app.url)
    },
    openSetWindow(app) {
      this.app = JSON.parse(JSON.stringify(app))
      this.showSetWindow = true;
      this.$forceUpdate();
    },
    confirmSet(app) {
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i].id === app.id) {
          this.app_list[i] = app;
        }
      }
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showSetWindow = false;
      this.$forceUpdate();
    },
    closeSetWindow() {
      this.showSetWindow = false;
      this.$forceUpdate();
    },
    openDelWindow(app) {
      this.app = app;
      this.showDelWindow = true;
      this.$forceUpdate();
    },
    confirmDel(app) {
      for (let i = 0; i < this.app_list.length; i++) {
        if (this.app_list[i]) {
          if (this.app_list[i].id === app.id) {
            this.app_list.splice(i, 1);
            break;
          }
        }
      }
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.showDelWindow = false;
      this.$forceUpdate();
    },
    closeDelWindow() {
      this.showDelWindow = false;
      this.$forceUpdate();
    }

  },
  created() {
    this.init();
  },
}
</script>

<style scoped>

</style>