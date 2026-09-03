```txt
res://
├── project.godot
├── export_presets.cfg
│
├── App/
│   ├── Bootstrap/          # Main.tscn, AutoLoad initializers, Network Gate flow
│   ├── Runtime/            # Global state managers, session runners, game loop orchestrators
│   ├── Application/        # Use-cases, app-level logic (e.g., StartGameUseCase)
│   ├── Domain/             # Pure gameplay rules, definitions, entities (TUYỆT ĐỐI KHÔNG phụ thuộc SceneTree/UI/Godot Nodes)
│   ├── Systems/            # ECS or system managers (CombatSystem, ProgressionSystem)
│   ├── Services/           # Interfaces/Contracts (INetworkService, ISaveService)
│   ├── Infrastructure/     # Implementations of Services (HTTP clients, File I/O)
│   ├── Platform/           # OS abstractions (Android vs PC specific adapters)
│   ├── Network/            # Connectivity checks, WebSockets, REST APIs
│   ├── Storage/            # Save files, local DB, cache management (user:// paths)
│   ├── Presentation/       # Scene controllers, Camera managers, World environments
│   ├── UI/                 # HUD, Menus, ViewModels, UI components
│   ├── Input/              # Input Adapters (Touch, Controller, KB/M) -> Semantic Actions
│   ├── Rendering/          # Custom shaders, rendering configs, post-processing
│   ├── Audio/              # Audio buses, sound managers, streaming setups
│   ├── Animation/          # Animation trees, state machines
│   ├── VFX/                # Particle systems, GPU particles
│   ├── Data/               # JSON/CSV parsers, data tables, definitions
│   ├── Resources/          # .tres files (ItemDefinition, CharacterDefinition)
│   ├── Assets/             # Raw imported assets (Models, Textures, Audio files)
│   ├── Config/             # Game balance, settings, .cfg files
│   ├── Localization/       # .po / .csv translation files
│   ├── Security/           # Integrity checks, manifest validation, anti-tamper
│   ├── Tools/              # Editor plugins, debug tools, GM commands
│   ├── Testing/            # GUT / Unit tests scenes & scripts
│   └── Editor/             # Custom Godot Editor plugins (@tool scripts)
│
└── Native/                 # Nơi chứa output build từ repo `aoi-cpp`
    ├── Core/               # Native core logic binaries
    ├── Performance/        # Native batch processing, math libraries
    ├── Algorithms/         # Pathfinding, procedural generation (C++)
    ├── Platform/           # Android JNI / Native platform hooks
    ├── Android/            # Android specific .so / .aar plugins
    └── GDExtension/        # File `.gdextension` và các file `.so` / `.dll` được build từ C++ 
    ```
