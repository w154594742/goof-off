<template>
  <div class="section">
    <div class="section-title">🏖️ 节假日倒计时</div>
    <div class="countdown-list">
      <div
        v-for="item in holidayList"
        :key="item.name"
        class="countdown-row"
      >
        <span class="countdown-label">距离 【<span class="countdown-name">{{ item.displayName }}</span>】 还有：</span>
        <span
          class="countdown-value"
          :class="{ today: item.daysLeft === 0, soon: item.daysLeft <= 3 && item.daysLeft > 0 }"
        >
          {{ item.daysLeft === 0 ? '🎉 今天' : `${String(item.daysLeft).padStart(3, '0')} 天` }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { daysBetween } from '../utils/dateUtils';
import { getHolidays, type Holiday } from '../utils/holidays';

interface HolidayDisplay {
  name: string;
  displayName: string;
  daysLeft: number;
}

const holidayList = ref<HolidayDisplay[]>([]);
let timer: ReturnType<typeof setInterval>;

// Pad name to 3 chars with full-width space for alignment
function padName(name: string): string {
  const chars = [...name];
  if (chars.length === 2) {
    return chars[0] + '　' + chars[1];
  }
  return name;
}

async function loadHolidays() {
  const today = new Date();
  const year = today.getFullYear();
  const holidays = await getHolidays(year);

  const list: HolidayDisplay[] = holidays
    .map((h: Holiday) => {
      const target = new Date(h.date + 'T00:00:00');
      const daysLeft = daysBetween(today, target);
      return {
        name: h.name,
        displayName: padName(h.name),
        daysLeft,
      };
    })
    .filter((h: HolidayDisplay) => h.daysLeft >= 0)
    .sort((a: HolidayDisplay, b: HolidayDisplay) => a.daysLeft - b.daysLeft);

  holidayList.value = list;
}

onMounted(() => {
  loadHolidays();
  timer = setInterval(loadHolidays, 3600000); // Refresh every hour
});

onUnmounted(() => {
  clearInterval(timer);
});
</script>
