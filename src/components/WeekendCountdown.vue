<template>
  <div class="section">
    <div class="section-title">🎉 周末倒计时</div>
    <div class="countdown-list">
      <div class="countdown-row">
        <span class="countdown-label">距离 【<span class="countdown-name">周　六</span>】 还有：</span>
        <span class="countdown-value" :class="{ today: saturday === 0, soon: saturday <= 1 && saturday > 0 }">
          {{ saturday === 0 ? '🎉 今天' : `${String(saturday).padStart(2, '0')} 天` }}
        </span>
      </div>
      <div class="countdown-row">
        <span class="countdown-label">距离 【<span class="countdown-name">周　日</span>】 还有：</span>
        <span class="countdown-value" :class="{ today: sunday === 0, soon: sunday <= 1 && sunday > 0 }">
          {{ sunday === 0 ? '🎉 今天' : `${String(sunday).padStart(2, '0')} 天` }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { getDaysUntilWeekday } from '../utils/dateUtils';

function calcWeekend() {
  const today = new Date();
  const dow = today.getDay();
  
  if (dow === 6) return { saturday: 0, sunday: 1 };
  if (dow === 0) return { saturday: 6, sunday: 0 };
  
  return {
    saturday: getDaysUntilWeekday(today, 6),
    sunday: getDaysUntilWeekday(today, 0),
  };
}

const { saturday: satInit, sunday: sunInit } = calcWeekend();
const saturday = ref(satInit);
const sunday = ref(sunInit);
let timer: ReturnType<typeof setInterval>;

onMounted(() => {
  timer = setInterval(() => {
    const { saturday: s, sunday: su } = calcWeekend();
    saturday.value = s;
    sunday.value = su;
  }, 60000);
});

onUnmounted(() => {
  clearInterval(timer);
});
</script>
