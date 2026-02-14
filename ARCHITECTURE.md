# Architecture Overview

This document outlines the architecture of the Absence Manager Dashboard
Flutter Web application.

------------------------------------------------------------------------

## ⚙️ Key Technologies


| Area               | Technology / Approach                  |
|--------------------|----------------------------------------|
| State Management   | `flutter_bloc`                         |
| UI Framework       | `Flutter`                              |
| API Communication  | `http`                                 |
| Code Quality       | `flutter_lints`, `make check`, `test`  |
| Testing            | `flutter_test`, `bloc_test`            |
| Deployment         | GitHub Actions + Pages                 |

------------------------------------------------------------------------

## 🧱 Layered Structure

The project follows a feature-first modular architecture:

```
├── features
│   └── absence_management
│       ├── data
│       │   ├── absence_repository_provider.dart
│       │   ├── datasources
│       │   │   ├── absence_data_source.dart
│       │   │   ├── absence_local_data_source.dart
│       │   │   └── absence_remote_data_source.dart
│       │   ├── models
│       │   │   ├── absence_model.dart
│       │   │   ├── api_response.dart
│       │   │   └── member_model.dart
│       │   └── repositories
│       │       └── absence_repository_impl.dart
│       ├── domain
│       │   ├── entities
│       │   │   ├── absence.dart
│       │   │   └── member.dart
│       │   ├── enums
│       │   │   ├── absence_status.dart
│       │   │   ├── absence_type.dart
│       │   │   └── data_source_type.dart
│       │   └── repositories
│       │       └── absence_repository.dart
│       └── presentation
│           ├── bloc
│           │   ├── absence_list_bloc.dart
│           │   ├── absence_list_event.dart
│           │   └── absence_list_state.dart
│           ├── pages
│           │   └── absence_list_page.dart
│           ├── view_models
│           │   └── absence_list_item_vm.dart
│           └── widgets
│               ├── absence_filter_bar.dart
│               └── absence_table.dart

```

### 1️⃣ Presentation Layer

-   Pages and reusable widgets
-   BLoC state listeners/builders
-   Loading, error, and empty states
-   Clear filters integration

### 2️⃣ Business Logic Layer

-   AbsenceListBloc
-   Event-driven state transitions
-   Client-side filtering and pagination
-   Immutable state management

### 3️⃣ Data Layer

-   Repository abstraction
-   Single DataSource interface
-   Remote (HTTP) and Local implementations
-   Model → Entity mapping

------------------------------------------------------------------------

## 🔁 Data Flow

1.  UI dispatches an event
2.  BLoC processes event
3.  Repository delegates to DataSource
4.  DataSource fetches data
5.  Repository maps models to entities
6.  BLoC emits new state
7.  UI rebuilds

------------------------------------------------------------------------

## 🧪 Testing Strategy

-   Bloc unit tests (load, filter, clear filters, pagination, error)
-   Data source parsing and exception tests
-   Repository mapping tests

------------------------------------------------------------------------

## 📦 Design Principles

-   Separation of concerns
-   Dependency direction: Presentation → Domain → Data
-   No dependency injection framework (manual provider wiring)
-   Testable and extensible architecture
