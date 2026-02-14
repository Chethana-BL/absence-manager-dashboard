# Absence Manager Dashboard

The Absence Manager is a cross-platform Flutter application designed for company owners, HR managers, and team leads to efficiently manage employee absences including vacations and sick leave. The application emphasizes clean architecture, responsive design, and exceptional user experience across mobile, tablet, and desktop platforms.

------------------------------------------------------------------------

## Overview

The app is built using a feature-first structure with clear separation
of concerns:

-   **Presentation Layer:** Flutter UI widgets and pages
-   **Business Logic Layer:** BLoC pattern for state management
-   **Data Layer:** Repository pattern with DataSource abstraction
-   **Networking:** http package
-   **Deployment:** GitHub Actions + GitHub Pages

🔍 See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed insights into the
app's structure and data flow.

------------------------------------------------------------------------

## Features

-   Display paginated absences (10 items per page)
-   Show total number of absences
-   View detailed absence information:
    -   👤 Employee name
    -   📂 Absence type
    -   📆 Period (from -- to)
    -   🗒️ Member note (optional)
    -   ✅ Status: Requested, Confirmed, Rejected
    -   📝 Admitter note (optional)
-   Filter by:
    -   Employee (search)
    -   Type
    -   Status
    -   Date range
-   Clear filters with state reset
-   iCal export of filtered absences
-   Proper UI states:
    -   Loading
    -   Error with retry
    -   Empty results view
-   Mock API support (json-server)
-   CI with analyze + tests
-   GitHub Pages deployment via release branches

------------------------------------------------------------------------

## 🌐 Live Demo

Access the deployed app here:  
🔗 [https://chethana-bl.github.io/absence-manager-dashboard/](https://chethana-bl.github.io/absence-manager-dashboard/)

*Note:* The app might take a few seconds to load initially

------------------------------------------------------------------------

## ⚙️ Setup Instructions

### Prerequisites

-   Flutter 3.35.4
-   Node.js (for mock API)

### Install Dependencies

``` bash
flutter pub get
```

### Run Mock API

``` bash
cd mock_api
npm install
npm run mock-api
```

Default API base URL: http://localhost:3001

### Run the App

``` bash
flutter run -d chrome
```

------------------------------------------------------------------------

## 🌐 Deployment

-   CI runs on main
-   Deployment triggered on release/\*\* branch push
-   Web build published to gh-pages branch
-   Hosted via GitHub Pages

------------------------------------------------------------------------

## 📂 Branching Strategy

-   main → development + CI
-   release/\*\* → deployment branch pattern
   
For more details on branch naming conventions and workflow, see the [branching strategy](BRANCHING.md).  
Following this helps keep development organized and easy to manage.

------------------------------------------------------------------------

## 🚀 Potential Improvements

-   Improve overall test coverage (data + widget tests)
-   Implement server-side pagination and filtering
-   Add role-based access control

------------------------------------------------------------------------