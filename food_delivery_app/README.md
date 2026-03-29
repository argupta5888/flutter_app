# 🍔 FoodRush - Flutter Food Delivery App (BLoC)

A beautiful, production-grade food delivery app built with Flutter using **BLoC** state management.

## Features
- **User Login** — email/password auth via AuthBloc with BlocListener navigation
- **Food Listing** — 8 items, category filter + search via FoodBloc
- **Cart** — add/remove/delete items via CartBloc with order summary
- **Distance** — Haversine formula in LocationBloc state, shown on every card and detail screen

## State Management: BLoC Pattern

| BLoC | Events | States |
|------|--------|--------|
| `AuthBloc` | `AuthLoginRequested`, `AuthLogoutRequested` | `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthUnauthenticated`, `AuthFailure` |
| `FoodBloc` | `FoodInitialized`, `FoodCategorySelected`, `FoodSearched` | `FoodState` |
| `CartBloc` | `CartItemAdded`, `CartItemDecremented`, `CartItemDeleted`, `CartCleared` | `CartState` |
| `LocationBloc` | `LocationFetchRequested` | `LocationState` |

## Project Structure

```
lib/
├── main.dart                        # MultiBlocProvider setup
├── utils/app_theme.dart             # Design system
├── models/food_model.dart           # FoodItem, CartItem, sample data
├── blocs/
│   ├── auth/
│   │   ├── auth_bloc.dart           # AuthBloc
│   │   ├── auth_event.dart          # AuthLoginRequested, AuthLogoutRequested
│   │   └── auth_state.dart          # AuthAuthenticated, AuthFailure, etc.
│   ├── cart/
│   │   ├── cart_bloc.dart           # CartBloc
│   │   ├── cart_event.dart          # CartItemAdded, CartItemDecremented, etc.
│   │   └── cart_state.dart          # CartState with computed totals
│   ├── food/
│   │   ├── food_bloc.dart           # FoodBloc
│   │   ├── food_event.dart          # FoodInitialized, FoodCategorySelected, FoodSearched
│   │   └── food_state.dart          # FoodState with filteredFoods getter
│   └── location/
│       ├── location_bloc.dart       # LocationBloc
│       ├── location_event.dart      # LocationFetchRequested
│       └── location_state.dart      # LocationState with Haversine helpers
└── screens/
    ├── splash_screen.dart           # Triggers FoodInitialized + LocationFetchRequested
    ├── login_screen.dart            # BlocListener for nav + BlocBuilder for UI
    ├── home_screen.dart             # BlocBuilder for food grid + categories
    ├── food_detail_screen.dart      # BlocBuilder for cart/location state
    └── cart_screen.dart             # BlocBuilder for cart items + summary
```

## Setup & Run

```bash
flutter pub get
flutter run
```

Demo credentials: `demo@foodrush.com` / `password123`

## Dependencies
- `flutter_bloc: ^8.1.5`
- `equatable: ^2.0.5`
