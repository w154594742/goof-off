<template>
  <div class="header drag-region">
    <div class="header-title">【摸🐟办】温馨提示</div>
    <div class="header-date">「{{ formattedDate }}」</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { formatDate } from '../utils/dateUtils';

const formattedDate = ref(formatDate(new Date()));
let timer: ReturnType<typeof setInterval>;

onMounted(() => {
  timer = setInterval(() => {
    formattedDate.value = formatDate(new Date());
  }, 60000); // Update every minute
});

onUnmounted(() => {
  clearInterval(timer);
});
</script>
