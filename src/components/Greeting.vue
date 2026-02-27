<template>
  <div class="greeting">
    <span class="greeting-highlight">{{ greeting }}摸鱼人！</span>摸鱼才是自己赚的钱，努力工作得到的是报酬！有事儿没事儿起身走走，别总在工位上坐着，钱是老板的，但健康是自己的。
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { getGreeting } from '../utils/dateUtils';

const greeting = ref(getGreeting(new Date()));
let timer: ReturnType<typeof setInterval>;

onMounted(() => {
  timer = setInterval(() => {
    greeting.value = getGreeting(new Date());
  }, 60000);
});

onUnmounted(() => {
  clearInterval(timer);
});
</script>
