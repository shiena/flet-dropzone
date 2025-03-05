import 'package:flet/flet.dart';

import 'flet_dropzone.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_dropzone":
      return DropzoneControl(
        parent: args.parent,
        control: args.control,
		children: args.children,
		parentDisabled: args.parentDisabled,
		parentAdaptive: args.parentAdaptive,
		backend: args.backend,
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}
