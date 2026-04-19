# Reiter USA — Logistics Operations Dashboard

A Flutter web dashboard for Reiter USA (Grand Junction, CO) — a used cooking oil logistics and commodity trading company.

## What It Shows

| Widget | Description |
|--------|-------------|
| **KPI Bar** | Gallons collected today, pickups completed, active drivers, open trade volume |
| **Commodity Ticker** | Live-simulated UCO / Yellow Grease / Tallow prices in $/lb (updates every 4s) |
| **Pickup Status Panel** | 124 pickups today — filterable by Completed / In Progress / Scheduled / Missed |
| **Route Status Cards** | 12 active routes with driver status, stop progress, and gallons per route |
| **28-Day Volume Chart** | Bar chart of daily collection volumes with today highlighted |
| **Open Trades Table** | 16 buy/sell trades across UCO, Yellow Grease, and Tallow |
| **LCFS Compliance** | California Low Carbon Fuel Standard records and carbon credit estimates |

## Tech Stack

- **Flutter** (web target)
- **Provider** — state management
- **fl_chart** — bar chart
- **google_fonts** — Inter typeface
- **intl** — number/date formatting

## Getting Started

**Prerequisites:** Flutter SDK ≥ 3.0 with web support enabled.

```bash
# 1. Enable web support (once)
flutter config --enable-web

# 2. Get dependencies
flutter pub get

# 3. Run in Chrome
flutter run -d chrome

# 4. Build for production
flutter build web --release
```

## Mock Data

All data is generated in-memory by `lib/services/mock_data_service.dart` — no Firebase setup required to run the demo.

To wire up a real Firebase Firestore backend:
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add a web app and copy the config
3. Run `flutterfire configure` to generate `lib/firebase_options.dart`
4. Add `firebase_core` and `cloud_firestore` to `pubspec.yaml`
5. Replace `MockDataService` calls in `DashboardProvider` with Firestore streams

## Project Structure

```
lib/
  main.dart                   — app entry point
  theme/app_theme.dart        — colors, typography
  models/                     — Pickup, RouteModel, Trade, DailyVolume, CommodityPrice
  services/mock_data_service  — 124 pickups, 12 routes, 16 trades, 28-day volumes
  providers/dashboard_provider— ChangeNotifier, commodity price timer
  widgets/                    — all dashboard panels
  screens/dashboard_screen    — responsive layout
```

## Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#0D1B2A` | Scaffold |
| Surface | `#152233` | Cards |
| Accent | `#E8600A` | Reiter orange — KPIs, today bar, prices |
| Success | `#27AE60` | Completed, buy trades |
| Warning | `#F39C12` | Pending, break status |
| Error | `#E74C3C` | Missed, sell trades |
| Info | `#3498DB` | In-progress, chart bars |
