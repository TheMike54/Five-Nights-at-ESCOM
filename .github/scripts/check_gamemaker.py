"""Verificaciones estaticas del proyecto GameMaker (la CI no puede compilar el juego).

1. Todos los .yyp y .yy se pueden leer (formato JSON de GameMaker, con comas finales).
2. Cada recurso listado en el .yyp apunta a un archivo .yy que existe.
3. Cada .yy de primer nivel en una carpeta de recursos esta registrado en el .yyp.
4. En cada objeto, cada evento del eventList tiene su archivo .gml y cada .gml tiene su evento.
5. Cada instancia de cada room apunta a un objeto que existe.
6. El .resource_order (si existe) se puede leer.

Uso: python check_gamemaker.py [raiz_del_repo]
"""
import re
import sys
from pathlib import Path

import json5

RESOURCE_DIRS = (
    "objects", "sprites", "sounds", "rooms", "scripts", "sequences",
    "fonts", "paths", "shaders", "tilesets", "timelines", "animcurves",
    "extensions", "notes", "particles",
)

# eventType de GameMaker -> prefijo del archivo .gml
EVENT_PREFIX = {
    0: "Create", 1: "Destroy", 2: "Alarm", 3: "Step", 4: "Collision",
    5: "Keyboard", 6: "Mouse", 7: "Other", 8: "Draw", 9: "KeyPress",
    10: "KeyRelease", 11: "Trigger", 12: "CleanUp", 13: "Gesture",
}
GML_NAME = re.compile(r"^(Create|Destroy|Alarm|Step|Collision|Keyboard|Mouse|Other|Draw|KeyPress|KeyRelease|Trigger|CleanUp|Gesture)_(\d+)\.gml$")


def load(path: Path):
    return json5.loads(path.read_text(encoding="utf-8-sig"))


def check_object_events(obj_yy: Path, root: Path, errors: list[str]) -> None:
    data = load(obj_yy)
    folder = obj_yy.parent
    rel = folder.relative_to(root).as_posix()
    expected = set()
    for ev in data.get("eventList", []):
        etype, enum = ev.get("eventType"), ev.get("eventNum")
        prefix = EVENT_PREFIX.get(etype)
        if prefix is None:
            errors.append(f"{rel}: eventType desconocido {etype}")
            continue
        if etype == 4:  # Collision_<objeto>.gml
            target = (ev.get("collisionObjectId") or {}).get("name", "")
            name = f"Collision_{target}.gml"
        else:
            name = f"{prefix}_{enum}.gml"
        expected.add(name)
        if not (folder / name).is_file():
            if ev.get("isDnD"):
                # El IDE no escribe .gml para un evento Drag and Drop sin acciones
                # (pasa en el proyecto original: obj_Bat Create, obj_ButtonUp Alarm 0).
                print(f"aviso: {rel}: el evento DnD {name[:-4]} no tiene {name} (evento vacio)")
            else:
                errors.append(f"{rel}: el evento GML {name[:-4]} esta en el .yy pero falta {name}")
    for gml in folder.glob("*.gml"):
        m = GML_NAME.match(gml.name)
        if m and gml.name not in expected:
            errors.append(f"{rel}: {gml.name} existe pero el evento no esta en {obj_yy.name} (agregalo desde el IDE)")


def check_room_instances(room_yy: Path, root: Path, errors: list[str]) -> None:
    data = load(room_yy)
    rel = room_yy.relative_to(root).as_posix()

    def walk(layers):
        for layer in layers or []:
            for inst in layer.get("instances", []) or []:
                obj = inst.get("objectId") or {}
                path = (obj.get("path") or "").replace("\\", "/")
                if not path or not (root / path).is_file():
                    errors.append(f"{rel}: la instancia '{inst.get('name')}' apunta a '{obj.get('name')}' ({path}) y ese objeto no existe")
            walk(layer.get("layers"))

    walk(data.get("layers"))


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    errors: list[str] = []

    yyps = list(root.glob("*.yyp"))
    if len(yyps) != 1:
        print(f"ERROR: se esperaba un .yyp en la raiz y hay {len(yyps)}")
        return 1
    yyp_path = yyps[0]

    try:
        project = load(yyp_path)
    except Exception as exc:  # noqa: BLE001
        print(f"ERROR: {yyp_path.name} no se puede leer: {exc}")
        return 1

    registered = set()
    for res in project.get("resources", []):
        rel = res["id"]["path"].replace("\\", "/")
        registered.add(rel)
        if not (root / rel).is_file():
            errors.append(f"{yyp_path.name} lista '{rel}' pero el archivo no existe")

    readable: list[Path] = []
    for yy in root.rglob("*.yy"):
        if ".git" in yy.parts:
            continue
        try:
            load(yy)
            readable.append(yy)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{yy.relative_to(root)} no se puede leer: {exc}")

    for folder in RESOURCE_DIRS:
        base = root / folder
        if not base.is_dir():
            continue
        for yy in base.glob("*/*.yy"):
            rel = yy.relative_to(root).as_posix()
            if rel not in registered:
                errors.append(f"'{rel}' existe pero no esta registrado en {yyp_path.name}")

    objects_checked = rooms_checked = 0
    for yy in readable:
        parts = yy.relative_to(root).parts
        if len(parts) == 3 and parts[0] == "objects":
            check_object_events(yy, root, errors)
            objects_checked += 1
        elif len(parts) == 3 and parts[0] == "rooms":
            check_room_instances(yy, root, errors)
            rooms_checked += 1

    for order in root.glob("*.resource_order"):
        try:
            load(order)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{order.name} no se puede leer: {exc}")

    if errors:
        print(f"{len(errors)} problema(s) en el proyecto GameMaker:")
        for e in errors:
            print(f"  - {e}")
        return 1

    print(f"OK: {yyp_path.name}, {len(registered)} recursos, {objects_checked} objetos con sus eventos y {rooms_checked} rooms verificados")
    return 0


if __name__ == "__main__":
    sys.exit(main())
