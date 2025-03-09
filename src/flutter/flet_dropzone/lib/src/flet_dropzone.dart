import 'dart:convert';

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DropzoneControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final FletControlBackend backend;

  const DropzoneControl({
    super.key,
    required this.parent,
    required this.control,
	required this.children,
	required this.parentDisabled,
	required this.parentAdaptive,
	required this.backend,
  });

  @override
  State<DropzoneControl> createState() => _DropzoneControlState();
}

class _DropzoneControlState extends State<DropzoneControl> with FletStoreMixin {
	bool _dragging = false;
	List<dynamic> _allowedFileTypes = [];
	List<dynamic> _droppedFiles = [];

	@override
	void initState() {
		super.initState();
		_allowedFileTypes = widget.control.attrList("allowedFileTypes") ?? [];
	}

	void onDragDone() {
		widget.backend.triggerControlEvent(
			widget.control.id,
			"dropped",
			jsonEncode({
				"files": _droppedFiles,
			}),
		);
	}

	void onDragEntered() {
		widget.backend.triggerControlEvent(
			widget.control.id,
			"entered",
			""
		);
	}

	void onDragExited() {
		widget.backend.triggerControlEvent(
			widget.control.id,
			"exited",
			""
		);
	}

	@override
	Widget build(BuildContext context) {
		debugPrint("DropZone build: ${widget.control.id} (${widget.control.hashCode})");
		bool disabled = widget.control.isDisabled || widget.parentDisabled;

		var contentCtrls = widget.children.where((c) => c.name == "content" && c.isVisible);

		Widget child = contentCtrls.isNotEmpty
			? createControl(widget.control, contentCtrls.first.id, disabled)
			: Container();

		return withPageArgs((context, pageArgs) {
			Widget? dropRegion;

			dropRegion = DropRegion(
				formats: Formats.standardFormats,
				hitTestBehavior: HitTestBehavior.opaque,
				onDropEnter: (event) {
					setState(() {
						_dragging = true;
					});
					onDragEntered();
				},
				onDropLeave: (event) {
					setState(() {
						_dragging = false;
					});
					onDragExited();
				},
				onDropOver: (event) {
					final item = event.session.items.first;
					if (event.session.allowedOperations.contains(DropOperation.copy)) {
						return DropOperation.copy;
					} else {
						return DropOperation.none;
					}
				},
				onPerformDrop: (event) async {
					List<dynamic> droppedFiles = [];
					for (final item in event.session.items) {
						final name = await item.dataReader?.getSuggestedName();
						if (name == null) {
							continue;
						}
						droppedFiles.add(name);
					}
					if (_allowedFileTypes.isNotEmpty) {
						droppedFiles = droppedFiles.where((filePath) {
							final extension = filePath.split('.').last.toLowerCase();
							return _allowedFileTypes.contains(extension);
						}).toList();
					}
					setState(() {
						_droppedFiles = droppedFiles;
						_dragging = false;
					});
					if (_droppedFiles.isNotEmpty) {
						onDragDone();
					}
				},
				child: child,
			);
			return constrainedControl(context, dropRegion, widget.parent, widget.control);
		});
	}
}
