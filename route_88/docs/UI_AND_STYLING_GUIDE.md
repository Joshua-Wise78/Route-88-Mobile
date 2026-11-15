# Route 88 Mobile — UI, Styling, and Feature Handoff Guide

This document is a reference guide for frontend developers extending or restyling the Route 88 mobile application. It outlines the exact locations of colors, icons, markers, and UI components, along with instructions for modifying and extending them.

---

## 1. Central Design System & Theme Colors

All primary UI and map colors are centralized in a single file:
**File:** [`lib/features/home/utils/map_theme.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/utils/map_theme.dart)

| Theme Constant | Hex Code | Default Role |
| :--- | :--- | :--- |
| `MapTheme.primary` | `0xFF123B66` | App bar, buttons, brand blue, search circle border |
| `MapTheme.background` | `0xFFF5F7FA` | Off-white background, sheet surfaces |
| `MapTheme.incident` | `0xFFC33C3C` | Accidents, road closures, destination flags |
| `MapTheme.slowdown` | `0xFFD97706` | Congestion, traffic delays |
| `MapTheme.construction` | `0xFFE68A2E` | Work zones, lane restrictions |
| `MapTheme.success` | `0xFF2E7D32` | "All Clear" status, route origin marker |
| `MapTheme.route` | `0xFF1976D2` | Active route driving polyline, user GPS pin |
| `MapTheme.routeBorder` | `0xFF0D47A1` | High-contrast polyline border casing |

> **To change colors:** Edit the static constants in [`map_theme.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/utils/map_theme.dart). Any change automatically cascades across the map, bottom sheets, filter badges, and cards.

---

## 2. Map Marker & Icon Registry

All map markers and event visual builders are centralized in:
**File:** [`lib/features/home/widgets/map_marker_builder.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart)

### Event & Hazard Pins
| Element | Method | Icon | Color | Line Reference |
| :--- | :--- | :--- | :--- | :--- |
| **Incidents / Accidents** | `fromIncident()` | `Icons.warning_amber_rounded` | `MapTheme.incident` | [`L66-L80`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L66-L80) |
| **Traffic Slowdowns** | `fromSlowdown()` | `Icons.speed` | `MapTheme.slowdown` | [`L82-L96`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L82-L96) |
| **Construction / Work Zones**| `fromConstruction()` | `Icons.construction` | `MapTheme.construction` | [`L98-L123`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L98-L123) |
| **Route Corridor Hazard** | `fromRouteHazard()` | Dynamic based on type | Matching severity color | [`L125-L162`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L125-L162) |
| **Route Start Endpoint** | `routeEndpoint(isStart: true)` | `Icons.play_circle_fill` | `MapTheme.success` | [`L186-L198`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L186-L198) |
| **Route Destination** | `routeEndpoint(isStart: false)` | `Icons.flag_circle` | `MapTheme.incident` | [`L186-L198`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L186-L198) |
| **User GPS Location Dot** | `userLocation()` | Pulsing circle dot | `MapTheme.route` | [`L164-L184`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/map_marker_builder.dart#L164-L184) |

> **To swap to custom SVG or Asset images:** In `buildEventMarker()` or `routeEndpoint()`, replace the `Icon(...)` child widget with `SvgPicture.asset('assets/...')` or `Image.asset('assets/...')`.

---

## 3. UI Buttons, Controls & Inputs

### Floating Action Buttons (FABs) on the Map
**File:** [`lib/features/home/view/map_page.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/view/map_page.dart)

- **Commute / Route Check (`bottom: 24, left: 16`)**:
  - Widget: `FloatingActionButton.extended`
  - Icon: `Icons.alt_route`
  - Action: Opens the `CommutePickerSheet`.
  - Code: [`map_page.dart` lines 324–343](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/view/map_page.dart#L324-L343)
- **My Location (`bottom: 24, right: 16`)**:
  - Widget: `FloatingActionButton.small`
  - Icon: `Icons.my_location`
  - Action: Triggers `_resolveUserLocation()` and animates camera back to user coordinates.
  - Code: [`map_page.dart` lines 353–370](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/view/map_page.dart#L353-L370)
- **Map Filters (`bottom: 24, right: 16`)**:
  - Widget: `FloatingActionButton.small`
  - Icon: `Icons.tune`
  - Action: Opens `MapFiltersSheet` to toggle Incidents, Slowdowns, or Construction layers.
  - Code: [`map_page.dart` lines 372–402](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/view/map_page.dart#L372-L402)

---

## 4. Route Clearance Sheet (2-Point Inputs & Presets)

**File:** [`lib/features/home/widgets/commute_picker_sheet.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/commute_picker_sheet.dart)

### Features:
1. **Custom Route Tab**:
   - **Start Location Input**: Uses [`PlaceSearchInput`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/place_search_input.dart) with `Icons.trip_origin` (green).
   - **"Use Current Location" Chip**: One-tap button that sets the start location to device GPS coordinates.
   - **Swap Button**: `Icons.swap_vert` toggles origin and destination.
   - **Destination Input**: Uses [`PlaceSearchInput`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/place_search_input.dart) with `Icons.location_on` (red).
   - **"Check Route Hazards" Button**: Disabled until both locations are set. Submits `CommuteCheckRequested(start, end, bufferMiles: 0.31)` to backend `/route/check`.
2. **Corridors Tab (Presets)**:
   - Defined in `CommutePickerSheet.presets` ([`lines 21–50`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/commute_picker_sheet.dart#L21-L50)).
   - To add a new preset highway corridor, add a new tuple to the list:
   ```dart
   (
     name: 'Toledo ➔ Cleveland (I-80/I-90 E)',
     start: Coordinate(lat: 41.6528, lng: -83.5379),
     end: Coordinate(lat: 41.4993, lng: -81.6944),
     subtitle: 'Via Ohio Turnpike • ~115 miles • 500m buffer',
   )
   ```

---

## 5. Address Autocomplete & Search

**File:** [`lib/features/home/widgets/place_search_input.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/place_search_input.dart)

- **Debounce**: 350 milliseconds (prevents excess API traffic).
- **Backend Endpoint**: Calls self-hosted Nominatim search `/api/route/autocomplete` via [`RoutingRepository.searchPlaces`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/routing/repositories/routing_repository.dart#L14).
- **Direct Coordinate Parsing**: Automatically parses comma-separated coordinates if entered directly (e.g., `41.4993, -81.6944`).

---

## 6. Route Summary Status Card

**File:** [`lib/features/home/widgets/commute_summary_card.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/features/home/widgets/commute_summary_card.dart)

Floats at the top of the map when a route is active:
- **Status Pills**:
  - `All Clear`: Green (`MapTheme.success`), `Icons.check_circle_outline`.
  - `Minor Delays`: Amber (`MapTheme.slowdown`), `Icons.info_outline`.
  - `Hazards on Route`: Red (`MapTheme.incident`), `Icons.warning_amber_rounded`.
- **Metrics Display**: Formatted driving distance (e.g., `106.4 mi`) and driving duration (e.g., `2 hr 4 min`).
- **Hazard Badges**: Chips indicating count of incidents, slowdowns, and work zones within 500m.
- **Clear Button**: `Icons.close` calls `ClearCommuteRequested` to dismiss the route and return to regular map view.

---

## 7. Device Geolocation Service

**File:** [`lib/core/utils/location_service.dart`](file:///home/joshua/repos/Route-88-Mobile/route_88/lib/core/utils/location_service.dart)

- Uses `geolocator: ^14.1.1`.
- Requests runtime permissions (`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`).
- Timeout is set to 5 seconds with an instant fallback to `getLastKnownPosition()`.
- If GPS services are disabled or permissions are denied, it defaults to Columbus, OH (`39.9612, -83.0019`).
- Android permissions: [`android/app/src/main/AndroidManifest.xml`](file:///home/joshua/repos/Route-88-Mobile/route_88/android/app/src/main/AndroidManifest.xml#L46-L47)
- iOS permissions: [`ios/Runner/Info.plist`](file:///home/joshua/repos/Route-88-Mobile/route_88/ios/Runner/Info.plist#L53-L54)

---

## 8. State Management Architecture

```
[UI Components]
  ├── MapPage (FlutterMap + Markers)
  ├── CommutePickerSheet (Start & End Inputs)
  └── CommuteSummaryCard (Top Status Bar)
         │
         ▼
[RoutingBloc] (lib/features/routing/bloc/)
  ├── AutocompleteAddressRequested ──► RoutingRepository.searchPlaces()
  ├── CommuteCheckRequested        ──► RoutingRepository.checkCommuteRoute()
  └── ClearCommuteRequested        ──► Resets commute state
         │
         ▼
[Backend Route-88 API]
  ├── GET /api/route/autocomplete?query=...
  └── GET/POST /api/mobile/route/check?startLat=...&startLon=...&endLat=...&endLon=...&bufferMiles=0.31
```
