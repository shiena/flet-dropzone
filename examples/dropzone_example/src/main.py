import flet as ft

from dropzone import Dropzone


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(

                ft.Container(height=150, width=300, alignment = ft.alignment.center, bgcolor=ft.Colors.PURPLE_200, content=Dropzone(
                    tooltip="My new Dropzone Control tooltip",
                    value = "My new Dropzone Flet Control", 
                ),),

    )


ft.app(main)
