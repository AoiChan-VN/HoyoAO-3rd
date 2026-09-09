# ENGINE MAPPING — HoyoAO-3rd
Owner: CTO / Master Architect | Version: 1.0 | Phase 0 — Structure Freeze
Law: BẢO TOÀN KIẾN TRÚC > TỐC ĐỘ CODE

## 1. NGUYÊN TẮC TRUNG LẬP ENGINE
- Source of Truth duy nhất: `native/aoi-cpp` (logic) + `data/` (nội dung).
- Mọi thứ trong `engines/*` là ADAPTER hoặc PRESENTER — không chứa authority.
- File trong `defs/`, `cfg/`, `locales/`, `content/manifests/` của engine là
  GENERATED bởi `tools/data_compiler` — CẤM SỬA TAY.
- Save sealed container do C++ Save Vault ghi → format engine-neutral,
  portable giữa Godot/Unity/Unreal.

## 2. BẢNG MAP LOGICAL MODULE → ENGINE PATH
| Logical Module | Source of Truth | Godot 4.7.2 (ACTIVE)        | Unity (RESERVED)                  | Unreal (RESERVED)              |
|----------------|-----------------|-----------------------------|-----------------------------------|--------------------------------|
| App lifecycle  | —               | res://app                   | Assets/Runtime/App                | GameInstance + Source/App      |
| Sys/Bridge     | native          | res://sys (GDExtension)     | Assets/Runtime/Sys (C# P/Invoke)  | Source/Sys (DLL module)        |
| Defs (DDA)     | data/defs_src   | res://defs (.tres, gen)     | ScriptableObject (gen)            | UDataAsset (gen)               |
| Content/Pkg    | data/content    | res://content               | Addressables manifest             | Pak + manifest                 |
| Gameplay view  | —               | res://gameplay              | Assets/Runtime/Gameplay           | Source/Gameplay                |
| Combat view    | —               | res://combat                | Assets/Runtime/Combat             | Source/Combat                  |
| Char assets    | —               | res://char                  | Assets/Art/Char                   | Content/Char                   |
| FX             | —               | res://fx                    | Assets/Art/FX (VFX Graph)         | Content/FX (Niagara)           |
| UI             | —               | res://ui                    | Assets/UI (UI Toolkit)            | Content/UI (UMG)               |
| Save UI        | native (vault)  | res://save                  | PersistentDataPath (UI only)      | SaveGames (UI only)            |
| Locales        | data/locales    | res://locales               | Localization package              | Localization plugin            |
| Quality cfg    | data/cfg        | res://cfg + Quality Governor| Quality settings + Governor bridge| Scalability + Governor bridge  |

## 3. ADAPTER ROADMAP
- Godot:   `src/gdext_boundary/`  — GDExtension, expose class AoiBridge duy nhất. (Phase 1)
- Unity:   `src/unity_bridge/`    — extern "C" ABI + C# P/Invoke.                (RESERVED)
- Unreal:  `src/unreal_bridge/`   — link static/DLL module.                      (RESERVED)
- Core (`aoi_core`) KHÔNG thay đổi khi thêm adapter.

## 4. NAMING FIREWALL (MỌI ENGINE)
Cấm: Node, Object, Resource, Variant, Vector3, SceneTree, Engine, ClassDB.
Chuẩn: ctx, mgr, svc, def, repo, sys, bus, gov, vault, cmd. Prefix native: Aoi/aoi_. 
