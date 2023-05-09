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

  </div>
</template>

<script>
import Background from "@/component/Background.vue";
import Icp from "@/component/Icp.vue";

export default {
  name: "Index",
  components: {Icp, Background}
}
</script>

<style scoped>

</style>