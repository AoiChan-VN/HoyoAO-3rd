#!/usr/bin/env python3
import os

APP_DIRS = [
    "Bootstrap", "Runtime", "Application", "Domain", "Systems", "Services",
    "Infrastructure", "Platform", "Network", "Storage", "Presentation", "UI",
    "Input", "Rendering", "Audio", "Animation", "VFX", "Data", "Resources",
    "Assets", "Config", "Localization", "Security", "Tools", "Testing", "Editor"
]

NATIVE_DIRS = [
    "Core", "Performance", "Algorithms", "Platform", "Android", "GDExtension"
]

def create_structure():
    # App Folders
    for d in APP_DIRS:
        path = os.path.join("App", d)
        os.makedirs(path, exist_ok=True)
        keep_file = os.path.join(path, ".gdkeep")
        if not os.path.exists(keep_file):
            open(keep_file, 'a').close()
            
    # Native Folders
    for d in NATIVE_DIRS:
        path = os.path.join("Native", d)
        os.makedirs(path, exist_ok=True)
        keep_file = os.path.join(path, ".gdkeep")
        if not os.path.exists(keep_file):
            open(keep_file, 'a').close()
            
    # Root directories
    os.makedirs("bin", exist_ok=True)
    with open(os.path.join("bin", ".gdkeep"), 'a') as f: pass
    
    print("Project structure generated successfully.")

if __name__ == "__main__":
    create_structure() 
