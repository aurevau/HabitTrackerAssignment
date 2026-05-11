# HabitTracker

> En Habit Tracker applikation byggd i SwiftUI med **offline-first gästläge** och **sömlös molnsynkronisering** via Firebase. Skapa vanor, fota dina framsteg, se var i världen du genomför dem, allt utan att tvingas registrera dig först.

---

## App Preview

https://github.com/user-attachments/assets/a258961f-66db-44a5-87c2-df99aaaae52c

## Innehållsförteckning

1. [Om projektet](#om-projektet)
2. [Funktioner](#funktioner)
3. [TechStack](#teknisk-stack)
4. [Arkitektur](#arkitektur)
5. [Mappstruktur](#mappstruktur)
6. [Gästläge med SwiftData](#gästläge-med-swiftdata)
7. [Migration: Gäst → Inloggad](#migration-gäst--inloggad)
8. [Datamodeller](#datamodeller)
9. [Firebase-integration](#firebase-integration)
11. [Notiser](#notiser)
12. [Roadmap](#roadmap)
13. [Författare & krediter](#författare--krediter)

---

## Om projektet

**HabitTracker** är en iOS-app utvecklad inom ramen för **MAPP25** (iOS-kursen). Målet med projektet är att skapa en Habit Tracker som följer modern iOS-utveckling: SwiftUI för UI, SwiftData för lokal persistens, och Firebase för molnsynk, allt med en **offline-first**-filosofi.

### Designprinciper

- **Prova innan du registrerar dig.** Användaren ska kunna gå in i appen som gäst och utforska alla funktioner utan att skapa ett konto. Först när användaren är övertygad om att appen passar tas steget till att registrera sig, och då migreras all lokal data sömlöst till molnet.
- **Visuella framsteg.** Streaks, veckovy, kartmarkeringar och foton ger användaren en rik visuell återkoppling på sina vanor.
- **Modernt Swift.** `@Observable`, async/await, `TaskGroup`, `MainActor` och SwiftData används genomgående för att hålla huvudtråden responsiv.

### Målgrupp

Personer som vill bygga och bibehålla vanor (träning, läsning, meditation, sociala medie-detox m.m.) och som motiveras av visuell statistik, platsmedvetenhet och egna foton som dokumenterar resan.

---

## Funktioner

### Habits
- Skapa, ta bort och redigera vanor
- Markera vanan som klar för dagen med ett tryck
- **Streak-räkning** med visuell indikator (🔥) i listan
- Idempotent toggle – tryck igen för att ångra dagens markering

### Geo & karta
- **Automatisk platsfångst** när en vana markeras som klar (`CLLocationUpdate.currentLocation()`)
- **Interaktiv MapKit-vy** som visar alla platser där vanor genomförts
- Platsmarkörer (annotations) med vanans namn
- Detaljsheet (`LocationDetailSheet`) för inloggade användare

### Kamera & bilder
- **Inbyggd kamera** (`CameraView`, `UIViewControllerRepresentable`) för att fota direkt vid en slutförd vana
- Bilder laddas upp till **Firebase Storage** under sökvägen `habit_images/{userId}/{habitId}/{filename}.jpg`
- Bilder kopplas till den specifika platsen via `locationId`

### Notiser
- **Lokala dagliga påminnelser** via `UNCalendarNotificationTrigger`
- Användaren väljer tid via `DatePicker` i `SettingsView`
- Tryck på notisen navigerar direkt till hemvyn via `NotificationCenter`-publishern `.navigateToHome`

### Autentisering
- **Firebase Auth** med e-post + lösenord
- **Gästläge** – fullständig funktionalitet utan att registrera sig
- Validering av e-post, lösenord (minst 6 tecken), bekräftelse av båda fälten

### Veckovy & statistik
- Horisontellt scrollbar veckovy (mån–sön, svensk kalender)
- **Slutförandeprocent per dag**
- Auto-scroll till dagens datum
- Visuell skillnad mellan slutförda och oslutförda dagar via gradient-styling

### Onboarding
- Animerad **5-stegs introduktionskarusell** för förstagångsanvändare
- Persisteras i `UserDefaults` (`hasSeenIntro`) så att den bara visas en gång
- Teman: träning, social media-detox, läsning m.m.

### Profil
- Användarnamn, e-post, registreringsdatum
- **Uppladdning av profilbild** (max 400 px, lagras i Firebase Storage)
- Inställningssida för notiser och utloggning

---

## Teknisk stack

| Område | Teknik |
|---|---|
| UI | SwiftUI 5.0, `@Observable` (Observation framework) |
| Lokal lagring | **SwiftData** (`@Model`, `ModelContainer`, `ModelContext`) |
| Molnlagring | **Firebase Firestore** |
| Auth | **Firebase Auth** (e-post/lösenord) |
| Bildlagring | **Firebase Storage** |
| Notiser | `UNUserNotificationCenter`, `UNCalendarNotificationTrigger`, Firebase Messaging |
| Karta | MapKit, CoreLocation |
| Foto | AVFoundation, PhotosUI |
| Concurrency | Swift `async/await`, `Task.detached`, `withThrowingTaskGroup`, `@MainActor` |
| Beroenden | Swift Package Manager (Firebase iOS SDK 12.12.1) |
| Mönster | **MVVM + Repository** |

---

## Arkitektur

Appen följer **MVVM + Repository**:

```
View  ←→  ViewModel  ←→  Repository  ←→  Firebase / SwiftData
```

### ViewModels (`@Observable`)

| ViewModel | Roll |
|---|---|
| `AuthViewModel` | Hanterar `authState` (loggedIn / loggedOut / guest / firstTimeUser), login/register, validering |
| `UserViewModel` | Hämtar och sparar användarprofil i Firestore, hanterar profilbild |
| `HabitViewModel` | Hanterar molnvanor (Firestore) – CRUD, toggle, platsfångst, bilduppladdning |
| `HabitLocalViewModel` | Hanterar lokala vanor (SwiftData) – CRUD, toggle, platsfångst i gästläge |

### Repositories

| Repository | Roll |
|---|---|
| `AuthRepositoryImpl` | Wrapper runt `Auth.auth()` – register, login, logout, isUserSignedIn |
| `HabitRepository` | Firestore-CRUD för vanor, Storage-uppladdning för bilder, **migration från SwiftData → Firestore** |
| `UserRepositoryImpl` | Firestore-CRUD för användarprofiler, profilbildsuppladdning |

### State-injektion

`ContentView` håller alla ViewModels som `@State` och injicerar dem via `.environment(...)` så att hela vy-hierarkin kan hämta dem med `@Environment(AuthViewModel.self)` osv.

---

## Mappstruktur

```
HabitTracker/
├── App/                          # Appens entry point
│   ├── HabitTrackerApp.swift     # @main – konfigurerar Firebase, begär plats
│   └── AppDelegate.swift         # UNUserNotificationCenter-delegate, deep-links
│
├── Auth/                         # Autentisering
│   ├── Enum/AuthState.swift      # .loggedIn / .loggedOut / .guest / .firstTimeUser
│   ├── Repositories/             # AuthRepository (protocol) + AuthRepositoryImpl
│   ├── ViewModels/AuthViewModel.swift
│   └── Views/                    # LoginView, RegisterView
│
├── Habit/                        # Kärnan – vanor
│   ├── Models/                   # Habit (Firebase), HabitLocal (@Model), HabitImage
│   ├── Repository/HabitRepository.swift
│   ├── ViewModels/               # HabitViewModel, HabitLocalViewModel
│   ├── Views/                    # AddHabitView, HabitRow, LocalHabitRow
│   └── Extensions/               # Habit+Extension, HabitLocal+Extension (streak m.m.)
│
├── Home/                         # Startskärm
│   ├── Views/HomeView.swift
│   ├── Components/               # WeekView, LocalWeekView, WeekDayView
│   └── Extensions/               # WeekViews+Extensions
│
├── Map/                          # Karta
│   ├── Models/Location.swift
│   ├── Views/                    # MapView, LocationDetailSheet
│   └── Extensions/Map+Extension
│
├── User/                         # Profil & inställningar
│   ├── Models/User.swift
│   ├── Repositories/UserRepositoryImpl.swift
│   ├── ViewModels/UserViewModel.swift
│   ├── Views/                    # ProfileView, SettingsView
│   └── Extensions/               # Notifications+Extension, User+Extension
│
├── Camera/                       # Kamera
│   └── Views/CameraView.swift    # UIViewControllerRepresentable
│
├── Intro/                        # Onboarding-karusell
│   ├── Model/IntroItem.swift
│   └── Views/IntroView.swift
│
├── Navigation/                   # Root-navigation
│   ├── Enum/TabSelection.swift
│   ├── Views/                    # ContentView, MainView, TabBarView
│   └── Extensions/ContentView+Extension.swift   ← migrations-logik
│
├── Extensions/                   # Globala Swift-extensions (Color+, Date+)
├── ViewModifiers/                # Återanvändbara modifiers (ButtonModifier, GradientCard, ...)
├── Utilities/Shapes.swift        # Custom shapes (Arc, HeadTabShape)
└── Other/
    ├── Assets.xcassets           # AppIcon, ThemeColors, imagesets
    └── GoogleService-Info.plist  # Firebase-konfiguration
```

---

## Gästläge med SwiftData

En central designidé i HabitTracker är att **användaren ska kunna testa hela appen innan hen registrerar sig**. Detta är implementerat genom SwiftData som lokal databas i gästläge.

### Flödet steg för steg

1. **Förstagångsanvändaren** öppnar appen och möts av onboarding-karusellen (`IntroView`). Den persisteras i `UserDefaults` (`hasSeenIntro = true`) när den slutförs.
2. På login-skärmen (`LoginView`) kan användaren välja **"Fortsätt som gäst"** → `AuthViewModel.continueAsGuest()` sätter `authState = .guest`.
3. `ContentView` switchar på `authState` och presenterar samma `MainView` som inloggade användare ser – men data hämtas nu från SwiftData istället för Firestore.
4. **`HabitLocalViewModel`** initialiseras med `inMemory: false` så att data persisteras till disk mellan app-starter.
5. Användaren kan skapa vanor, markera dem som klara, samla streaks, fånga GPS-platser och se sin karta – **utan att något skickas till molnet**.

### Conditional rendering i `HomeView`

`HomeView` renderar olika rader beroende på `authState`:

- `authState == .guest` → `LocalHabitRow` driven av `habitLocalViewModel.habits`
- `authState == .loggedIn` → `HabitRow` driven av `habitViewModel.habits` (Firestore)

På så vis kan exakt samma UI-komponenter återanvändas oavsett datakälla.

---

## Migration: Gäst → Inloggad

När en gäst bestämmer sig för att registrera sig (eller logga in på ett befintligt konto) **migreras all lokal SwiftData-data automatiskt till Firebase Firestore** utan att blockera huvudtråden och utan att användaren behöver göra något.

### Sekvensdiagram

```
┌────────┐   skapa vanor    ┌─────────────┐
│  Gäst  │ ───────────────► │  SwiftData  │
└────┬───┘                  │   (lokal)   │
     │                      └─────────────┘
     │ registrerar/loggar in
     ▼
┌────────────────┐
│ Firebase Auth  │
└──────┬─────────┘
       │ authState: .guest → .loggedIn
       ▼
┌────────────────────────────┐
│ ContentView.onChange       │
│   - detekterar övergången  │
│   - Task.detached (off main)│
└──────┬─────────────────────┘
       │
       ▼
┌────────────────────────────────────┐
│ migrateLocalHabits()               │
│   withThrowingTaskGroup            │
│   ┌───────┬───────┬───────┐        │
│   │ habit │ habit │ habit │ ...    │   parallell uppladdning
│   └───────┴───────┴───────┘        │
└──────┬─────────────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ Firestore                  │
│ users/{uid}/habits/{hid}   │
└──────┬─────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ Radera lokala HabitLocal   │
│ hasMigrated = true         │   (via MainActor.run)
└────────────────────────────┘
```

### 1. Trigger – `onChange` på `authState`

```swift
// Navigation/Views/ContentView.swift
.onChange(of: authViewModel.authState) { oldValue, newValue in
    if oldValue == .guest && newValue == .loggedIn && !hasMigrated {
        Task.detached {
            await migrateHabitsToFirebase(
                habitLocalViewModel: habitLocalViewModel,
                userId: authViewModel.currentUserId,
                habitViewModel: habitViewModel
            )
            await MainActor.run { hasMigrated = true }
        }
    }
    if newValue == .loggedOut || newValue == .guest {
        hasMigrated = false
    }
}
```

Notera:
- **`Task.detached`** lyfter migrationen av huvudtråden – UI:t förblir responsivt under uppladdningen.
- **`MainActor.run`** används för att uppdatera state (`hasMigrated`) tråd-säkert.
- **`hasMigrated`-flaggan** förhindrar dubbel-migration om `authState` flackar.


Viktiga detaljer:
- Lokala vanor **raderas endast om uppladdningen lyckades** – om Firestore-anropet kraschar behåller vi datan lokalt.
- Tidiga `guard`-utgång om gästen inte har skapat några vanor.

### 3. Parallell uppladdning med `TaskGroup`

Varför `withThrowingTaskGroup`?
- **Parallellitet:** alla vanor laddas upp samtidigt istället för sekventiellt – mycket snabbare för användare med många vanor.
- **Felhantering:** om en uppladdning kraschar propagerar felet uppåt och hela migrationen markeras som misslyckad (lokal data bevaras).

### 4. Vad händer vid utloggning?

`AuthViewModel.logOut()` anropar `Auth.auth().signOut()` och sätter `authState = .loggedOut`. Den lokala SwiftData-databasen rensas **inte**  Firestore-data ligger kvar i molnet och hämtas på nytt vid nästa inloggning. Flaggan `hasMigrated` återställs så att en eventuell ny gäst→inloggad-övergång åter triggar migration.


## Datamodeller

### SwiftData (lokal – gästläge)

| Modell | Fält | Typ |
|---|---|---|
| `HabitLocal` | `id` | `UUID` |
|  | `name` | `String` |
|  | `habitDescription` | `String` |
|  | `completedDates` | `[Date]` |
|  | `locations` | `[Location]` |

### Firebase Firestore (moln – inloggad)

| Modell | Fält | Typ |
|---|---|---|
| `Habit` | `id` | `String` |
|  | `name` | `String` |
|  | `description` | `String` |
|  | `completedDates` | `[Date]` |
|  | `locations` | `[Location]` |
|  | `images` | `[HabitImage]` |
| `User` | `id` | `String` (Firebase UID) |
|  | `username` | `String` |
|  | `email` | `String` |
|  | `joined` | `TimeInterval` |
|  | `profileImageUrl` | `String?` |
| `Location` | `id` | `UUID` |
|  | `name` | `String` |
|  | `latitude` / `longitude` | `Double` |
|  | `date` | `Date` |
| `HabitImage` | `id` | `UUID` |
|  | `locationId` | `UUID?` |
|  | `habitImage` | `String?` (Storage-URL) |

### Firestore-strukturen

```
users (collection)
└── {userId} (document)
    ├── username, email, joined, profileImageUrl
    └── habits (subcollection)
        └── {habitId} (document)
            ├── id, name, description
            ├── completedDates: [TimeInterval]
            ├── locations: [{id, name, latitude, longitude, date}]
            └── images:    [{id, locationId, habitImage}]
```

### Firebase Storage-paths

- **Habit-foton:** `habit_images/{userId}/{habitId}/{uuid}.jpg`
- **Profilbilder:** uppladdas via `UserRepositoryImpl` och URL:en lagras på användardokumentet

---

## Firebase-integration

| Produkt | Användning |
|---|---|
| **FirebaseCore** | Initieras i `HabitTrackerApp.init()` via `FirebaseApp.configure()` |
| **FirebaseAuth** | E-post/lösenord-registrering & login |
| **FirebaseFirestore** | Användarprofil + alla molnvanor |
| **FirebaseStorage** | Profilbilder + foton kopplade till vanor |
| **FirebaseMessaging** | Aktiverat för framtida push-notiser |

`GoogleService-Info.plist` ligger i `HabitTracker/Other/` och måste ersättas med din egen för att projektet ska köra mot ditt eget Firebase-projekt.

---

## Notiser

Lokala notiser skickas via **`UNCalendarNotificationTrigger`** definierad i `User/Extensions/Notifications+Extension.swift`.

- Användaren väljer önskad tid i `SettingsView` via en `DatePicker`.
- `requestNotificationAuthorization(date:)` ber om tillstånd och schemalägger sedan en daglig påminnelse.
- Notistitel: **"Habit Tracker"**, subtitel: **"Har du genomför dagens vanor?"**
- Tryck på notisen → `AppDelegate` postar `.navigateToHome` på `NotificationCenter` → `ContentView` lyssnar och navigerar direkt till hemvyn.

---

## Roadmap

Framtida förbättringar och kända begränsningar:

- [ ] Lägg till **unit- och UI-tester** med XCTest (täckning av repos, ViewModels och migrations-flöde)
- [ ] Externalisera svenska strängar till `Localizable.xcstrings` för **flerspråksstöd** (EN + SV)
- [ ] **Sign in with Apple** + Google Sign-In som komplement till e-post/lösenord
- [ ] **WidgetKit-widget** för dagens vanor på hemskärmen
- [ ] Offline-kö för signed-in users (skriv till SwiftData och synka när nätet kommer tillbaka)
- [ ] **Crashlytics** och **Analytics** för produktionsmonitorering
- [ ] Vanor-kategorier med custom-ikoner och färg-tagg
- [ ] Live Activities under pågående streak
- [ ] Export av vanor till CSV/JSON

---


**Aurelie Vaudan**
iOS-utvecklare under utbildning – **MAPP25** (Mobil Applikationsutveckling, 2025/2026)


---

> Byggt med ❤️ i Sverige – `HabitTracker` är ett kursprojekt med ambitionen att vara produktionsklart i framtiden.
