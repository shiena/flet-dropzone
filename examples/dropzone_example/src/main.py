import flet as ft

import dropzone as ftd


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
