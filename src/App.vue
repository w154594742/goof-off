<template>
  <div
    class="app-container"
    :style="{ opacity: appOpacity }"
    @mousedown="startDrag"
  >
    <!-- Title bar with close/minimize buttons -->
    <div class="title-bar">
      <button class="title-bar-btn" @mousedown.stop @click="hideWindow" title="最小化到托盘">─</button>
      <button class="title-bar-btn close" @mousedown.stop @click="hideWindow" title="隐藏到托盘">✕</button>
    </div>

    <!-- Scrollable content -->
    <div class="content">
      <Header />
      <Greeting />
      <PaydayCountdown />
      <div class="divider"></div>
      <WeekendCountdown />
      <div class="divider"></div>
      <HolidayCountdown />
    </div>

    <!-- Footer -->
    <div class="footer">
      摸鱼办 v0.1.0 · 今天也要好好摸鱼哦 🐟
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import { getCurrentWindow } from '@tauri-apps/api/window';
import { listen, type UnlistenFn } from '@tauri-apps/api/event';
import Header from './components/Header.vue';
import Greeting from './components/Greeting.vue';
import PaydayCountdown from './components/PaydayCountdown.vue';
import WeekendCountdown from './components/WeekendCountdown.vue';
import HolidayCountdown from './components/HolidayCountdown.vue';

const appWindow = getCurrentWindow();
const appOpacity = ref(1.0);
let unlisten: UnlistenFn | null = null;

function hideWindow() {
  appWindow.hide();
}

async function startDrag(e: MouseEvent) {
  // Only drag on left button, and not on interactive elements
  if (e.button !== 0) return;
  const target = e.target as HTMLElement;
  if (target.closest('button, input, select, a, .no-drag')) return;
  await appWindow.startDragging();
}

onMounted(async () => {
  unlisten = await listen<number>('set-opacity', (event) => {
    appOpacity.value = event.payload;
  });
});

onUnmounted(() => {
  if (unlisten) unlisten();
});
</script>