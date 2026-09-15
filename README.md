# beerMais-ios

Beer Mais — compare beer prices by cost per ml and find the best value.

[App Store](https://apps.apple.com/br/app/beer-mais/id1450659497)

## High-level targets

The project has three app targets plus shared data via an App Group:

```mermaid
flowchart TB
    subgraph Targets["App Targets"]
        Main["BeerMais<br/>(Main App)"]
        Widget["BeerMais widget<br/>(Widget Extension)"]
        Clip["BeerMais Clip<br/>(App Clip)"]
    end

    subgraph Storage["Target-local storage"]
        MainCoreData["Main app<br/>Core Data store"]
        ClipCoreData["App Clip<br/>Core Data store"]
    end

    subgraph Shared["Shared storage"]
        AppGroup["App Group<br/>group.beerMais"]
    end

    Main --> MainCoreData
    Main --> AppGroup
    Widget --> AppGroup
    Clip --> ClipCoreData
```

## Layer architecture (main app)

The app uses a **hybrid UIKit + SwiftUI** setup with a **Domain layer** for beer logic and persistence.

```mermaid
flowchart TB
    subgraph Presentation["Presentation Layer"]
        direction TB

        subgraph UIKit["UIKit (legacy / bootstrap)"]
            AD["AppDelegate"]
            SD["SceneDelegate"]
            Launch["LaunchScreenViewController<br/>(Lottie animation)"]
        end

        subgraph SwiftUI["SwiftUI (primary UI)"]
            MainView["MainView<br/>(TabView)"]
            Home["HomeView + ViewModel"]
            About["AboutView"]
            BeerDetail["BeerDetailView + ViewModel"]
            DeleteAll["DeleteAllView"]
            BeerCard["BeerView + ViewModel"]
            Donate["DonateView + ViewModel"]
        end

        subgraph Composition["Composition"]
            Dependencies["AppDependencies<br/>(SwiftUI environment)"]
            Persistence["PersistenceController"]
            Repository["BeerRepository /<br/>CoreDataBeerRepository"]
        end

        subgraph Presenters["Presenters / App Services"]
            AppP["AppP<br/>(launch, analytics, remote config)"]
            SettingsP["SettingsP<br/>(Settings.plist keys)"]
            VersionP["VersionP"]
        end
    end

    subgraph Domain["Domain Layer"]
        BeerWorker["BeerWorker<br/>(CRUD orchestration,<br/>sorting, economy calc)"]
        BeerEntity["Beer (NSManagedObject)"]
        BeerData["BeerData (DTO)"]
    end

    subgraph Infrastructure["Infrastructure / External"]
        Firebase["Firebase<br/>(Core, Messaging, Remote Config)"]
        AdMob["Google Mobile Ads<br/>(Banner, Rewarded)"]
        Amplitude["Amplitude"]
        StoreKit["StoreKit<br/>(Donations, Review)"]
        WidgetKit["WidgetKit"]
        Lottie["Lottie"]
        BasicsKit["BasicsKit"]
    end

    subgraph Storage["Persistence"]
        CD["Core Data store"]
        UD["UserDefaults<br/>(launch flags, open count)"]
        AG["App Group UserDefaults<br/>(widget data)"]
    end

    AD --> AppP
    AD --> Firebase
    AD --> AdMob
    SD --> Launch
    Launch --> MainView
    SD --> MainView

    SD --> Dependencies
    Dependencies --> Persistence
    Dependencies --> Repository
    Dependencies --> BeerWorker
    Persistence --> CD
    Repository --> Persistence
    MainView --> Home
    MainView --> About
    Home --> BeerCard
    Home --> BeerDetail
    Home --> DeleteAll
    About --> Donate

    MainView --> Dependencies
    Home --> BeerWorker
    BeerDetail --> BeerWorker
    DeleteAll --> BeerWorker

    BeerWorker --> Repository
    BeerWorker --> Amplitude
    BeerWorker --> WidgetKit
    BeerWorker --> AG
    AppP --> Amplitude
    AppP --> Firebase
    AppP --> UD
    AppP --> StoreKit

    BeerDetail --> AdMob
    DeleteAll --> AdMob

    BeerWorker --> BeerEntity
    BeerWorker --> BeerData
    Repository --> BeerEntity

    SettingsP --> AdMob
    SettingsP --> Amplitude
```

## Navigation & screen flow

```mermaid
flowchart LR
    Start([App Launch]) --> AD[AppDelegate]
    AD --> SD[SceneDelegate]
    SD --> Launch[LaunchScreenViewController]
    Launch --> Main[MainView]

    Main --> TabHome[Tab: Calculadora]
    Main --> TabAbout[Tab: Sobre]

    TabHome --> Home[HomeView]
    Home --> Highlight[Highlighted BeerView<br/>(best value)]
    Home --> Grid[Beer grid<br/>(BeerView cards)]
    Home -->|"+"| Create[BeerDetailView<br/>(create sheet)]
    Home -->|tap beer| Edit[BeerDetailView<br/>(edit sheet)]
    Home -->|trash| Delete[DeleteAllView<br/>(confirm sheet)]

    TabAbout --> About[AboutView]
    About --> Donate[DonateView<br/>(StoreKit tip jar)]
```

## Data flow (beer CRUD → widget)

```mermaid
sequenceDiagram
    participant UI as SwiftUI Views
    participant VM as ViewModels / Presenter
    participant BW as BeerWorker
    participant BR as BeerRepository
    participant PC as PersistenceController
    participant CD as Core Data
    participant AG as App Group UserDefaults
    participant WK as WidgetKit
    participant AMP as Amplitude
    participant W as Widget Extension

    UI->>VM: User action (create/edit/delete)
    VM->>BW: createBeer / edit / delete
    BW->>BR: persist / fetch / batch delete
    BR->>PC: use view context
    PC->>CD: NSManagedObjectContext
    BW->>AMP: track event (beer_created, etc.)
    BW->>BW: calculateMostValuableBeer()
    BW->>AG: write BRAND, AMOUNT, VALUE, ECONOMY...
    BW->>WK: reloadAllTimelines()
    W->>AG: read widget snapshot
    W->>W: render BeerMais_widgetEntryView
```

## Folder structure

| Layer | Path | Responsibility |
|---|---|---|
| **Config** | `BeerMais/Config/` | `AppDelegate`, `SceneDelegate`, assets, entitlements, Core Data model |
| **Views** | `BeerMais/Views/` | SwiftUI screens (`MainView`, `HomeView`, `BeerDetailView`, etc.) |
| **Scenes** | `BeerMais/Scenes/` | UIKit launch screen |
| **Domain** | `BeerMais/Domain/` | `Beer`, `BeerWorker`, `PersistenceController`, `BeerRepository`, `AppDependencies` |
| **Presenters** | `BeerMais/Presenters/` | App-wide services (`AppP`, `SettingsP`, `VersionP`) |
| **Common** | `BeerMais/Common/` | Reusable UI, ads, extensions |
| **Libraries** | `BeerMais/Libraries/` | Firebase Remote Config abstractions |
| **Strings** | `BeerMais/Strings/` | Localization (en, pt-BR, es) |
| **Widget** | `BeerMais widget/` | Home screen widget |
| **Clip** | `BeerMais Clip/` | Lightweight App Clip entry → `MainView` |

## External dependencies (SPM)

| Package | Used for |
|---|---|
| **firebase-ios-sdk** | Firebase Core, Messaging, Remote Config |
| **swift-package-manager-google-mobile-ads** | Banner & rewarded ads |
| **Amplitude-Swift** | Analytics & error tracking |
| **lottie-spm** | Launch animation |
| **BasicsKit** | Shared utilities (string/number parsing) |
| **StoreKit** | In-app tips (donations) & review prompts |

## Architecture notes

1. **Primary pattern**: `SceneDelegate` builds `AppDependencies` and injects it into `MainView` through SwiftUI environment; feature ViewModels receive the configured `BeerWorker` explicitly.
2. **Persistence boundary**: `PersistenceController` owns each target's Core Data container. `CoreDataBeerRepository` performs CRUD and batch-delete work; `BeerWorker` retains comparison rules and coordinates analytics/widget updates.
3. **Legacy UIKit**: `LaunchScreenViewController` bootstraps the main app before presenting `MainView` (SwiftUI).
4. **Cross-target sharing**: Widget data flows through **App Group** `UserDefaults`, not Core Data directly in the widget.
5. **App Clip**: Reuses `MainView` with its own dependency container and target-local Core Data store; it does not share the main app's Core Data database.
