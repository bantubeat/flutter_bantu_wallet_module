import 'package:uuid/uuid.dart';

String generateUniquePaymentId([String prefix = '']) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final uuid = const Uuid().v4();

  // Combine these components to create a unique ID
  final uniqueId = '$prefix-$timestamp-$uuid';

  return uniqueId;
}
