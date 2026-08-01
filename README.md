# Flet Dropzone control

Dropzone control for [Flet](https://flet.dev/) integrating [desktop_drop](https://pub.dev/packages/desktop_drop)

## Installation

```bash
pip install flet-dropzone
```

**⚠️ Please build once before running.**<br>
**⚠️ Please build once before running.**<br>
**⚠️ Please build once before running.**<br>

for windows user:

```bash
flet build windows -v
```

for macOS user:

```bash
flet build macos -v
```

for linux user:

```bash
flet build linux -v
```

for web user:

```bash
flet build web -v
```

## Example

```py
import flet as ft

import flet_dropzone as ftd


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    async def on_dropped(e: ftd.DropzoneEvent):
        for file in e.files:
            data = await e.control.read_bytes(file)
            print(f"Dropped: {file.name} ({len(data)} bytes) from {file.path}")

    page.add(
        ftd.Dropzone(
            content=ft.Container(
                ft.Text("Drop here!"),
                width=500,
                height=500,
                alignment=ft.Alignment.CENTER,
                bgcolor="red",
            ),
            on_dropped=on_dropped,
            on_entered=lambda e: print("Entered"),
            on_exited=lambda e: print("Exited"),
        )
    )


ft.run(main)
```

`DropzoneEvent.files` is a list of `DropzoneFile` objects with `name` and `path`
properties. On desktop platforms `path` is a real file path, while on web it is
a temporary `blob:` URL — use `Dropzone.read_bytes()` to get the file content on
any platform.

## References

- https://github.com/flet-dev/flet/pull/4441
