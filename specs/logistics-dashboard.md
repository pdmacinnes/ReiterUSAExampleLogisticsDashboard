# Reiter USA — Logistics Dashboard Spec

## Company Context

Reiter USA (Grand Junction, CO) operates in three divisions:
- **Reiter Trading**: buys/sells used cooking oil (UCO) and yellow grease across North America
- **Reiter Software (C.O.S.T.)**: route optimization and collection management SaaS for UCO collectors
- **Reiter Consulting**: advisory for UCO/grease trap businesses

Their core logistics loop: drivers run collection routes, picking up UCO from restaurants and food processors, recording volumes at each stop, with supervisors monitoring in real-time. Collected oil is then sold as a commodity (UCO/yellow grease) to biodiesel producers.

---

## Requirements & Goals

Build a Flutter + Firebase logistics dashboard that demonstrates Reiter USA's internal operational visibility. The dashboard is a **web-capable Flutter app** targeting desktop/tablet layout, seeded with realistic mock data.

The goal is to show a hiring manager / prospective intern candidate exactly what kind of internal tooling the role would produce.

---

## Screens & Widgets

### 1. Top KPI Bar (always visible)
| Metric | Description |
|--------|-------------|
| Gallons Collected Today | Running total across all active routes |
| Pickups Completed | e.g. 47 / 62 scheduled |
| Active Drivers | Drivers currently on route |
| Open Trades (lbs) | Volume committed in open commodity trades |

### 2. Pickup Status Panel
- Table/list of today's pickups with columns:
  - Location name, address/city
  - Scheduled time
  - Status badge: `Scheduled` / `In Progress` / `Completed` / `Missed`
  - Gallons collected (filled in on completion)
  - Driver name
  - Route name
- Filterable by status and route
- Color-coded rows (green = completed, yellow = in progress, red = missed, grey = scheduled)

### 3. Volume Trend Chart
- Bar chart: daily gallons collected over the past 14 days
- Secondary line overlay: 14-day rolling average
- Built with `fl_chart`

### 4. Route Status Cards
- One card per active route showing:
  - Route name & driver
  - Stops completed / total stops
  - Gallons collected so far on this route
  - Driver status: `On Route` / `Break` / `Returning`
  - Progress bar

### 5. Commodity Ticker
- Strip at top or side showing current UCO/yellow grease prices (mock data simulating market feed):
  - UCO $/lb, Yellow Grease $/lb, Tallow $/lb
  - Last updated timestamp

### 6. Open Trades Table
- Columns: Trade ID, Type (Buy/Sell), Commodity, Volume (lbs), Price ($/lb), Counterparty, Status, Trade Date
- Status: `Open` / `Pending Settlement` / `Settled`

### 7. Compliance Snapshot (small widget)
- LCFS cradle-to-grave records status: records submitted vs. required this month
- Useful for showing the regulatory dimension of their business

---

## Data Model (Firestore collections)

```
/pickups/{id}
  locationName: string
  address: string
  city: string
  scheduledTime: timestamp
  completedTime: timestamp | null
  status: 'scheduled' | 'in_progress' | 'completed' | 'missed'
  volumeGallons: number | null
  driverName: string
  routeId: string
  routeName: string

/routes/{id}
  name: string
  driverName: string
  driverStatus: 'on_route' | 'break' | 'returning' | 'off_duty'
  totalStops: number
  completedStops: number
  gallonsCollected: number

/trades/{id}
  tradeId: string
  type: 'buy' | 'sell'
  commodity: 'UCO' | 'Yellow Grease' | 'Tallow'
  volumeLbs: number
  pricePerlb: number
  counterparty: string
  status: 'open' | 'pending_settlement' | 'settled'
  tradeDate: timestamp

/dailyVolumes/{date}
  date: string (YYYY-MM-DD)
  gallons: number
```

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Frontend | Flutter (web + desktop target) |
| Backend / DB | Firebase Firestore |
| Charts | `fl_chart` |
| Fonts | `google_fonts` (Inter) |
| State management | `provider` or `riverpod` |
| Mock data | Dart seeder script that writes to Firestore on first run |

---

## Theme & Branding

- Color palette: deep navy (`#0D1B2A`) background, Reiter orange accent (`#E8600A`), white text
- Card-based layout with subtle elevation
- Professional / B2B aesthetic — not consumer-facing

---

## Mock Data Scope

- 6 routes, 6 drivers
- 62 pickups today across all routes (mix of statuses)
- 14 days of historical daily volumes (realistic range: 800–2,400 gallons/day)
- 8 open/recent trades

---

## Acceptance Criteria

- [ ] App runs with `flutter run -d chrome` (web target)
- [ ] All 7 widgets render with mock data
- [ ] Pickup list filters by status correctly
- [ ] Volume chart renders 14 bars with rolling average line
- [ ] Route cards show accurate progress bar (stops completed / total)
- [ ] Commodity ticker updates on a simulated interval (mock price drift)
- [ ] Firebase Firestore integration present (reads live from DB)
- [ ] Mock data seeder populates Firestore on first run if collections are empty
- [ ] App is responsive at 1280px+ width (dashboard layout)
- [ ] No hardcoded secrets — Firebase config via environment or `firebase_options.dart`
