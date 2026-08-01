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
  List<DropItem> _droppedFiles = [];

  @override
  void initState() {
    super.initState();
    _allowedFileTypes = widget.control.get<List>("allowed_file_types") ?? [];
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "read_bytes":
        String path = args["path"];
        // On web a dropped file is only reachable through its original
        // XFile (a temporary blob: URL), so look it up first and fall
        // back to reading from the path directly on desktop platforms.
        final file = _droppedFiles
            .cast<DropItem?>()
            .firstWhere((f) => f!.path == path, orElse: () => null);
        return (file ?? DropItemFile(path)).readAsBytes();
      default:
        throw Exception("Unknown Dropzone method: $name");
    }
  }

  void _onDragDone() {
    widget.control.triggerEvent(
      "dropped",
      {
        "files": _droppedFiles
            .map((file) => {"name": file.name, "path": file.path})
            .toList(),
      },
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
          // Filter by file name, not path: on web the path is a blob: URL
          // without an extension.
          _droppedFiles = details.files.where((file) {
            if (_allowedFileTypes.isEmpty) return true;
            final extension = file.name.split('.').last.toLowerCase();
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
