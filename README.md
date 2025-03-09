# Flet Dropzone control

Dropzone control for Flet integrating [super_drag_and_drop](https://pub.dev/packages/super_drag_and_drop)

## Installation

```bash
pip install flet-dropzone
```

Build the library before running the script.

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

## Example

```py
import flet as ft

import flet_dropzone as ftd


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(
        ftd.Dropzone(
            content=ft.Container(
                ft.Text("Drop here!"),
                width=500,
                height=500,
                alignment=ft.alignment.center,
                bgcolor="red",
            ),
            on_dropped=lambda e: print(f"Dropped: {e.files}"),
            on_entered=lambda e: print("Entered"),
            on_exited=lambda e: print("Exited"),
        )
    )


ft.app(main)
```

## References

- https://github.com/flet-dev/flet/pull/4441
