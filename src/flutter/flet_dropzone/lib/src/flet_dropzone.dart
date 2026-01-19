import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';

class DropzoneControl extends StatefulWidget {
  final Control control;

  DropzoneControl({Key? key, required this.control})
      : super(key: key ?? ValueKey("control_${control.id}"));

  @override
  State<DropzoneControl> createState() => _DropzoneControlState();
}

class _DropzoneControlState extends State<DropzoneControl> {
  bool _dragging = false;
  List<dynamic> _allowedFileTypes = [];
  List<dynamic> _droppedFiles = [];

  @override
  void initState() {
    super.initState();
    _allowedFileTypes = widget.control.get<List>("allowed_file_types") ?? [];
  }

  void _onDragDone() {
    widget.control.triggerEvent(
      "dropped",
      {"files": _droppedFiles},
    );
  }

  void _onDragEntered() {
    widget.control.triggerEvent("entered");
  }

  void _onDragExited() {
    widget.control.triggerEvent("exited");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "DropZone build: ${widget.control.id} (${widget.control.hashCode})");
    bool disabled = widget.control.disabled;

    // Update allowed file types if changed
    _allowedFileTypes = widget.control.get<List>("allowed_file_types") ?? [];

    Widget? content = widget.control.buildWidget("content");
    Widget child = content ?? Container();

    Widget dropZone = DropTarget(
      onDragEntered: (details) {
        setState(() {
          _dragging = true;
        });
        _onDragEntered();
      },
      onDragExited: (details) {
        setState(() {
          _dragging = false;
        });
        _onDragExited();
      },
      onDragDone: (details) {
        setState(() {
          _droppedFiles =
              details.files.map((file) => file.path).where((filePath) {
            if (_allowedFileTypes.isEmpty) return true;
            final extension = filePath.split('.').last.toLowerCase();
            return _allowedFileTypes.contains(extension);
          }).toList();
          _dragging = false;
        });
        if (_droppedFiles.isNotEmpty) {
          _onDragDone();
        }
      },
      enable: !disabled,
      child: child,
    );

    return LayoutControl(control: widget.control, child: dropZone);
  }
}
