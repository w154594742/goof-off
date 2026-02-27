<template>
  <div class="section">
    <div class="section-title">💰 发薪日倒计时</div>
    <div class="payday-text">
      距离【领工资】天数，<template v-for="(item, index) in paydays" :key="item.day"><span class="payday-days">{{ String(item.daysLeft).padStart(2, '0') }}</span> 天({{ item.day }}号)<template v-if="index < paydays.length - 1">，</template></template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { getNextPaydays } from '../utils/dateUtils';

const paydays = ref(getNextPaydays(new Date()));
let timer: ReturnType<typeof setInterval>;

onMounted(() => {
  timer = setInterval(() => {
    paydays.value = getNextPaydays(new Date());
  }, 60000);
});

onUnmounted(() => {
  clearInterval(timer);
});
</script>
