# Frontend Data Fetching & Architecture Strategy

This document outlines the recommended approach for fetching, caching, and updating traffic incident data on the frontend mobile application. These strategies are designed to optimize mobile performance, minimize bandwidth and battery usage, and provide a seamless "live" map experience.

## 1. Core Fetching Strategy: Dynamic vs. Upfront

For a map-based mobile application, **fetching all state-wide data upfront is not recommended**. 
* **Drawbacks of Upfront Fetching:** Rendering thousands of map pins can lag the device, waste cellular data on unseen areas, and quickly become stale.
* **Recommended Approach - Dynamic Fetching:** The frontend should continuously request exactly what it needs based on the user's current context (map view or planned route). Heavy spatial processing should remain on the backend.

---

## 2. Dynamic Query Types

The backend `/incidents` endpoint should ideally support different query modes depending on what screen the user is viewing.

### A. Viewport / Bounding Box Queries (For the Map Screen)
When the user is freely panning the map, the app should request data based on the visible screen bounds.
* **Mechanism:** The frontend sends the Northeast and Southwest coordinates of the visible map area to the backend.
* **Endpoint Example:** `GET /incidents?ne_lat=40.0&ne_lon=-82.5&sw_lat=39.5&sw_lon=-83.0`
* **Benefit:** Keeps the map highly responsive and prevents loading hidden data.

### B. Route-Based Queries (For Navigation)
When navigating, computing which incidents intersect a route is computationally heavy and should be handled by the backend (e.g., PostGIS spatial querying).
* **Mechanism:** The frontend sends a route polyline (or waypoints) to the backend. The backend returns only incidents directly affecting that path.
* **Endpoint Example:** `POST /incidents/route` (Route data in body)

---

## 3. Handling Live Updates (Partially Live Data)

To keep the map updated without redrawing the entire screen or causing flickering, we utilize **Delta Updates** combined with our local state management (BLoC).

### Step 1: Initial Fetch & Baseline Cache
* The app requests the initial route or map view.
* The backend returns the incidents and a `sync_timestamp` indicating when this snapshot was taken.
* The frontend stores these incidents in a local cache (e.g., in `IncidentsBloc` state) and draws the initial map pins.

### Step 2: Delta Fetching (Polling)
* Every 2-3 minutes (standard for traffic APIs like OHGO), the app asks the backend for changes.
* **Endpoint Example:** `GET /incidents/updates?route_id=123&since=<sync_timestamp>`
* The backend returns a small "Delta" payload of *only* what changed:
  ```json
  {
    "new_timestamp": 1718047500,
    "added_or_updated": [{ /* New crash data */ }],
    "resolved_or_removed": ["incident_1234"]
  }
  ```

### Step 3: Local Merge & Reactive UI
* **Remove:** The frontend deletes any IDs listed in `resolved_or_removed` from the local cache.
* **Add/Update:** The frontend adds or updates the items in `added_or_updated`.
* **State Emission:** `IncidentsBloc` emits the newly merged state.
* **UI Update:** The Map widget reactively updates. The cleared incident pin vanishes, and the new incident pin pops up seamlessly.

### Connection Protocol: Polling vs. WebSockets
* **Smart Polling:** Highly recommended. Requesting delta updates every few minutes via REST is highly reliable on spotty cellular networks and battery-friendly.
* **WebSockets/SSE:** Allows the backend to instantly push updates to the app. While truly "live", it drains more battery and is generally overkill for traffic data which naturally only updates periodically.

