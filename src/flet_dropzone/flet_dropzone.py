from dataclasses import dataclass, field
from typing import Generic, Optional

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

__all__ = ["Dropzone", "DropzoneEvent"]


@dataclass(kw_only=True)
class DropzoneEvent(Event[EventControlType], Generic[EventControlType]):
    """Event triggered when files are dropped onto the Dropzone."""

    files: list[str] = field(default_factory=list)
    """List of file paths that were dropped."""


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
    The event contains a `files` property with a list of file paths.
    """

    on_entered: Optional[ControlEventHandler["Dropzone"]] = None
    """
    Called when a drag operation enters the dropzone area.
    """

    on_exited: Optional[ControlEventHandler["Dropzone"]] = None
    """
    Called when a drag operation exits the dropzone area.
    """
