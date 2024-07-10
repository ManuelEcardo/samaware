// conditional_import.dart
export 'conditional_import_stub.dart'
if (dart.library.html) 'conditional_import_web.dart'
if (dart.library.io) 'conditional_import_io.dart';
