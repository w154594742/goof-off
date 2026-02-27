export interface Holiday {
  name: string;
  date: string; // YYYY-MM-DD
}

// Fallback holiday data for 2025-2027
const FALLBACK_HOLIDAYS: Record<number, Holiday[]> = {
  2025: [
    { name: '清明节', date: '2025-04-04' },
    { name: '劳动节', date: '2025-05-01' },
    { name: '端午节', date: '2025-05-31' },
    { name: '中秋节', date: '2025-10-06' },
    { name: '国庆节', date: '2025-10-01' },
  ],
  2026: [
    { name: '清明节', date: '2026-04-05' },
    { name: '劳动节', date: '2026-05-01' },
    { name: '端午节', date: '2026-06-19' },
    { name: '中秋节', date: '2026-09-25' },
    { name: '国庆节', date: '2026-10-01' },
  ],
  2027: [
    { name: '清明节', date: '2027-04-05' },
    { name: '劳动节', date: '2027-05-01' },
    { name: '端午节', date: '2027-06-09' },
    { name: '中秋节', date: '2027-09-15' },
    { name: '国庆节', date: '2027-10-01' },
  ],
};

// Cross-year holidays (元旦 and 春节 always refer to the NEXT occurrence)
function getCrossYearHolidays(year: number): Holiday[] {
  const springFestival: Record<number, string> = {
    2025: '2025-01-29',
    2026: '2026-02-17',
    2027: '2027-02-06',
    2028: '2028-01-26',
  };

  const holidays: Holiday[] = [
    { name: '元旦节', date: `${year + 1}-01-01` },
  ];

  if (springFestival[year + 1]) {
    holidays.push({ name: '春　节', date: springFestival[year + 1] });
  }

  return holidays;
}

interface CachedData {
  holidays: Holiday[];
  fetchedAt: number;
  year: number;
}

const CACHE_KEY = 'holidays_cache';
const CACHE_DURATION_MS = 30 * 24 * 60 * 60 * 1000; // 30 days

async function loadCache(): Promise<CachedData | null> {
  try {
    const { load } = await import('@tauri-apps/plugin-store');
    const store = await load('settings.json', { autoSave: true });
    const cached = await store.get<CachedData>(CACHE_KEY);
    return cached || null;
  } catch {
    return null;
  }
}

async function saveCache(data: CachedData): Promise<void> {
  try {
    const { load } = await import('@tauri-apps/plugin-store');
    const store = await load('settings.json', { autoSave: true });
    await store.set(CACHE_KEY, data);
    await store.save();
  } catch {
    // Silently fail cache save
  }
}

// Fetch holidays from the Chinese holiday API
// API: https://timor.tech/api/holiday/year/{year}
async function fetchHolidaysFromAPI(year: number): Promise<Holiday[] | null> {
  try {
    const response = await fetch(`https://timor.tech/api/holiday/year/${year}/`);
    if (!response.ok) return null;
    
    const data = await response.json();
    if (data.code !== 0 || !data.holiday) return null;

    const holidays: Holiday[] = [];
    const holidayMap = data.holiday as Record<string, {
      holiday: boolean;
      name: string;
      date: string;
    }>;

    // Group by holiday name, take the first date of each holiday
    const seen = new Set<string>();
    for (const key of Object.keys(holidayMap).sort()) {
      const item = holidayMap[key];
      if (item.holiday && !seen.has(item.name)) {
        seen.add(item.name);
        holidays.push({
          name: item.name,
          date: item.date,
        });
      }
    }

    return holidays.length > 0 ? holidays : null;
  } catch {
    return null;
  }
}

export async function getHolidays(year: number): Promise<Holiday[]> {
  // 1. Check cache
  const cached = await loadCache();
  if (
    cached &&
    cached.year === year &&
    Date.now() - cached.fetchedAt < CACHE_DURATION_MS
  ) {
    return [...cached.holidays, ...getCrossYearHolidays(year)];
  }

  // 2. Try API
  const apiHolidays = await fetchHolidaysFromAPI(year);
  if (apiHolidays) {
    await saveCache({
      holidays: apiHolidays,
      fetchedAt: Date.now(),
      year,
    });
    return [...apiHolidays, ...getCrossYearHolidays(year)];
  }

  // 3. Fallback to built-in data
  const fallback = FALLBACK_HOLIDAYS[year] || FALLBACK_HOLIDAYS[2026] || [];
  return [...fallback, ...getCrossYearHolidays(year)];
}
