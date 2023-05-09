<template>
  <div>
    <div class="bg"></div>
    <div class="bg bg2"></div>
    <div class="bg bg3"></div>
  </div>
</template>

<script>
export default {
  name: "Background"
}
</script>

<style scoped>
.bg {
  animation: slide 10s ease-in-out infinite alternate;
  background-image: linear-gradient(-45deg, #66cc33 50%, #0099ff 50%);
  bottom: 0;
  left: -50%;
  opacity: .5;
  position: fixed;
  right: -50%;
  top: 0;
  z-index: -1;
}

.bg2 {
  animation-direction: alternate-reverse;
  animation-duration: 60s;
}

.bg3 {
  animation-duration: 60s;
}

@keyframes slide {
  0% {
    transform: translateX(-25%);
  }
  100% {
    transform: translateX(25%);
  }
}
</style>