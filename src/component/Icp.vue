<template>
  <div class="icp">
    <a href="https://beian.miit.gov.cn" target="_blank">京ICP备17033235号-4</a>
  </div>
</template>

<script>
export default {
  name: "Icp"
}
</script>

<style scoped>
.icp {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 100px;
  font-size: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.icp a {
  color: rgba(255, 255, 255, 0.5);
}
</style>