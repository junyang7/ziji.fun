<template>
  <div class="search">
    <input
        autofocus
        :class ="getSearchInputClass"
        @keydown.enter="onKeydownEnter"
        @focus="input.focused = true"
        @blur="input.focused = false"
        @mouseenter="input.focused = true"
        @mouseleave="input.focused = false"
        v-model="input.keyword"
    />
    <div class="search-engine">
      <img src="https://www.baidu.com/favicon.ico" alt="">
    </div>
    <div class="button-search" @click="onButtonSearchClick">
      <i class="ri-search-line"></i>
    </div>
  </div>
</template>

<script>
export default {
  name: "Search",
  data() {
    return {
      input: {
        focused: true,
        keyword: "",
      },
    };
  },
  methods: {
    onButtonSearchClick() {
      this.search();
    },
    onKeydownEnter() {
      this.search();
    },
    search() {
      window.open(`https://www.baidu.com${this.input.keyword ? "/s?ie=utf-8&word=" + this.input.keyword : ""}`);
    }
  },
  computed: {
    getSearchInputClass: function () {
      return "search-input" + (this.input.focused ? " search-input-focus" : "");
    }
  },
  mounted() {

  },
  created() {

  },
}
</script>

<style scoped>
.search {
  position: absolute;
  width: 400px;
  height: 36px;
  left: calc(50% - 200px);
  top: calc(50% - 18px);
}

.search-input {
  width: 100%;
  height: 100%;
  margin: 0;
  box-sizing: border-box;
  border-radius: 20px;
  list-style: none;
  padding: 0 40px;
  font-size: 16px;
  background-color: transparent;
  outline: none;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 0 10px 1px rgba(200, 200, 200, 0.5);
  color: rgba(255, 255, 255, 0.8);
}

.search-input-focus {
  box-shadow: 0 0 10px 1px rgba(255, 255, 255, 0.9);
}

.search-engine {
  position: absolute;
  left: 0;
  top: 0;
  width: 40px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.search img {
  height: 16px;
  width: 16px;
}

.button-search {
  position: absolute;
  right: 0;
  top: 0;
  width: 40px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.8);
}
</style>