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

    subgraph Shared["Shared Storage"]
        AppGroup["App Group<br/>group.beerMais"]
        CoreData["Core Data<br/>BeerMais.xcdatamodeld"]
    end

    Main --> CoreData
    Main --> AppGroup
    Widget --> AppGroup
    Clip --> Main
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

        subgraph Presenters["Presenters / App Services"]
            AppP["AppP<br/>(launch, analytics, remote config)"]
            SettingsP["SettingsP<br/>(Settings.plist keys)"]
            VersionP["VersionP"]
        end
    end

    subgraph Domain["Domain Layer"]
        BeerWorker["BeerWorker<br/>(CRUD, sorting, economy calc)"]
        BeerEntity["Beer (NSManagedObject)"]
        BeerData["BeerData (DTO)"]
        CoreDataWorker["CoreDataWorker"]
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
        CD["Core Data Stack<br/>(AppDelegate.persistentContainer)"]
        UD["UserDefaults<br/>(launch flags, open count)"]
        AG["App Group UserDefaults<br/>(widget data)"]
    end

    AD --> AppP
    AD --> Firebase
    AD --> AdMob
    SD --> Launch
    Launch --> MainView
    SD --> MainView

    MainView --> Home
    MainView --> About
    Home --> BeerCard
    Home --> BeerDetail
    Home --> DeleteAll
    About --> Donate

    Home --> BeerWorker
    BeerDetail --> BeerWorker
    DeleteAll --> BeerWorker

    BeerWorker --> CoreDataWorker
    BeerWorker --> Amplitude
    BeerWorker --> WidgetKit
    BeerWorker --> AG
    CoreDataWorker --> CD
    CoreDataWorker --> AppP

    AppP --> Amplitude
    AppP --> Firebase
    AppP --> UD
    AppP --> StoreKit

    BeerDetail --> AdMob
    DeleteAll --> AdMob

    BeerWorker --> BeerEntity
    BeerWorker --> BeerData
    CoreDataWorker --> BeerEntity

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
    participant CDW as CoreDataWorker
    participant CD as Core Data
    participant AG as App Group UserDefaults
    participant WK as WidgetKit
    participant AMP as Amplitude
    participant W as Widget Extension

    UI->>VM: User action (create/edit/delete)
    VM->>BW: createBeer / edit / delete
    BW->>CDW: persist / fetch / batch delete
    CDW->>CD: NSManagedObjectContext
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
| **Domain** | `BeerMais/Domain/` | `Beer`, `BeerWorker`, `CoreDataWorker` |
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

1. **Primary pattern**: SwiftUI views + `ObservableObject` ViewModels calling `BeerWorker` directly.
2. **Legacy UIKit**: `LaunchScreenViewController` bootstraps the app before presenting `MainView` (SwiftUI).
3. **Single domain service**: `BeerWorker` owns business rules (price per ml, sorting, economy), persistence orchestration, analytics, and widget sync.
4. **Cross-target sharing**: Widget data flows through **App Group** `UserDefaults`, not Core Data directly in the widget.
5. **App Clip**: Reuses `MainView` without the launch animation wrapper.
