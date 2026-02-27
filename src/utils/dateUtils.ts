const WEEKDAY_NAMES = ['日', '一', '二', '三', '四', '五', '六'];

export function formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const weekday = WEEKDAY_NAMES[date.getDay()];
    return `${year}年${month}月${day}日 星期${weekday}`;
}

export function getGreeting(date: Date): string {
    const hour = date.getHours();
    if (hour < 6) return '夜深了！';
    if (hour < 9) return '早上好！';
    if (hour < 12) return '上午好！';
    if (hour < 14) return '中午好！';
    if (hour < 18) return '下午好！';
    if (hour < 22) return '晚上好！';
    return '夜深了！';
}

export function daysBetween(from: Date, to: Date): number {
    const fromDate = new Date(from.getFullYear(), from.getMonth(), from.getDate());
    const toDate = new Date(to.getFullYear(), to.getMonth(), to.getDate());
    const diff = toDate.getTime() - fromDate.getTime();
    return Math.ceil(diff / (1000 * 60 * 60 * 24));
}

export function getNextPaydays(
    today: Date,
    payDays: number[] = [5, 10, 15, 20, 25, 28]
): { day: number; daysLeft: number }[] {
    const year = today.getFullYear();
    const month = today.getMonth();
    const currentDay = today.getDate();

    const results: { day: number; daysLeft: number }[] = [];

    for (const day of payDays) {
        // Try current month first
        let payDate = new Date(year, month, day);
        let daysLeft = daysBetween(today, payDate);

        if (daysLeft <= 0) {
            // Already passed this month, try next month
            payDate = new Date(year, month + 1, day);
            daysLeft = daysBetween(today, payDate);
        }

        results.push({ day, daysLeft });
    }

    return results;
}

export function getWeekendCountdown(today: Date): {
    saturday: number;
    sunday: number;
} {
    const dayOfWeek = today.getDay(); // 0=Sun, 6=Sat
    let saturday = 6 - dayOfWeek;
    let sunday = 7 - dayOfWeek;

    if (saturday <= 0) saturday += 7;
    if (sunday <= 0 || dayOfWeek === 0) sunday = dayOfWeek === 0 ? 0 : sunday;

    // Edge case: if today is Sunday
    if (dayOfWeek === 0) {
        saturday = 6;
        sunday = 7;
    }
    // If today is Saturday
    if (dayOfWeek === 6) {
        saturday = 0;
        sunday = 1;
    }

    return { saturday, sunday };
}

// Recalculate more simply
export function getDaysUntilWeekday(today: Date, targetDay: number): number {
    const currentDay = today.getDay();
    let diff = targetDay - currentDay;
    if (diff <= 0) diff += 7;
    return diff;
}
