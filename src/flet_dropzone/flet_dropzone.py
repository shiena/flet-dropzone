from dataclasses import dataclass, field
from typing import Generic, Optional, Union

from flet.controls.adaptive_control import AdaptiveControl
from flet.controls.base_control import control
from flet.controls.control import Control
from flet.controls.control_event import (
    ControlEventHandler,
    Event,
    EventControlType,
    EventHandler,
)
from flet.controls.layout_control import LayoutControl

__all__ = ["Dropzone", "DropzoneEvent", "DropzoneFile"]


@dataclass
class DropzoneFile:
    """A file dropped onto the Dropzone."""

    name: str = ""
    """File name including extension, e.g. `photo.png`."""

    path: str = ""
    """
    Full file path on desktop platforms.
    On web there is no real path, only a temporary `blob:` URL;
    use `Dropzone.read_bytes()` to get the file content.
    """


@dataclass(kw_only=True)
class DropzoneEvent(Event[EventControlType], Generic[EventControlType]):
    """Event triggered when files are dropped onto the Dropzone."""

    files: list[DropzoneFile] = field(default_factory=list)
    """List of files that were dropped."""


@control("flet_dropzone")
class Dropzone(LayoutControl, AdaptiveControl):
    """
    Dropzone Control.

    A control that allows users to drag and drop files from the desktop.
    """

    content: Optional[Control] = None
    """
    A child Control contained by the dropzone.
    """

    allowed_file_types: list[str] = field(default_factory=list)
    """
    List of allowed file extensions (without the dot).
    If empty, all file types are allowed.
    Example: ["pdf", "png", "jpg"]
    """

    on_dropped: Optional[EventHandler[DropzoneEvent["Dropzone"]]] = None
    """
    Called when files are dropped onto the dropzone.
    The event contains a `files` property with a list of `DropzoneFile` items.
    """

    on_entered: Optional[ControlEventHandler["Dropzone"]] = None
    """
    Called when a drag operation enters the dropzone area.
    """

    on_exited: Optional[ControlEventHandler["Dropzone"]] = None
    """
    Called when a drag operation exits the dropzone area.
    """

    async def read_bytes(
        self,
        file: Union[DropzoneFile, str],
        timeout: Optional[float] = None,
    ) -> bytes:
        """
        Reads the content of a dropped file.

        Works on all platforms, including web, where dropped files are
        only accessible through a temporary `blob:` URL.

        Args:
            file:
                A `DropzoneFile` from `DropzoneEvent.files` or its `path` value.
            timeout:
                The maximum amount of time (in seconds) to wait for a response.

        Returns:
            The file content.
        """
        path = file.path if isinstance(file, DropzoneFile) else file
        return await self._invoke_method(
            "read_bytes", {"path": path}, timeout=timeout
        )
