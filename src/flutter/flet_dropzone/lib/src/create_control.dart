import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'flet_dropzone.dart';

class FletDropzoneExtension extends FletExtension {
  @override
  void ensureInitialized() {
    // nothing to initialize
  }

  @override
  Widget? createWidget(Key? key, Control control) {
    switch (control.type) {
      case "flet_dropzone":
        return DropzoneControl(key: key, control: control);
      default:
        return null;
    }
  }
}

// Keep old API for backward compatibility (deprecated)
@Deprecated('Use FletDropzoneExtension instead')
typedef CreateControlFactory = Widget? Function(dynamic args);

@Deprecated('Use FletDropzoneExtension instead')
CreateControlFactory createControl = (_) => null;
