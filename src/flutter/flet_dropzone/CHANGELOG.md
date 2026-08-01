## 0.4.0

* Add `read_bytes` method to read the content of a dropped file on any
  platform, including web where only a temporary `blob:` URL is available (#6).
* The `dropped` event now sends a list of `{name, path}` objects instead of
  a list of path strings.
* Filter `allowed_file_types` by file name instead of path, so it works on
  web where the path is a `blob:` URL without an extension.

## 0.2.0

* Rename dropzone to flet_dropzone.

## 0.1.0

* First release.
