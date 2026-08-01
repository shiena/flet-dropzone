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
