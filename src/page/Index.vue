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
      <button @click="add">添加</button>
    </div>

    <div v-show="show"
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
        <button @click="save">保存</button>
        <button @click="cancel">取消</button>
      </div>
    </div>

    <div>
      <template v-for="(a,b,c) in app_list">
        <div
            @click="open(a)"
            style="border: 1px solid red; display: inline-block; box-sizing: border-box; padding: 10px; cursor: pointer;">
          <div style="width: 50px; height: 50px; border: 1px solid red;">
            <img :src="a.favicon" style="width: 100%; height: 100%;"/>
          </div>
          <div style="text-align: center;">{{ a.name }}</div>
        </div>
      </template>
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
      show: false,
      app: {
        name: "",
        url: "",
        favicon: "",
      },
      app_list: [
        {
          name: "微博",
          url: "https://weibo.com",
          favicon: "https://weibo.com/favicon.ico",
        },
        {
          name: "百度",
          url: "https://baidu.com",
          favicon: "https://baidu.com/favicon.ico",
        },
      ],
    };
  },
  methods: {
    init() {
      this.app_list = JSON.parse(window.localStorage.getItem("ziji.app_list")) || [];
    },
    add() {
      console.log("add");
      this.app = {
        name: "",
        url: "",
        favicon: "",
      };
      this.show = true;
    },
    save() {
      console.log("save")
      console.log(this.app)
      this.app_list.push(JSON.parse(JSON.stringify(this.app)));
      console.log(this.app_list);
      window.localStorage.setItem("ziji.app_list", JSON.stringify(this.app_list));
      this.show = false;
    },
    cancel() {
      this.show = false;
    },
    open(app) {
      window.open(app.url)
    },
  },
  created() {
    this.init();
  },
}
</script>

<style scoped>

</style>