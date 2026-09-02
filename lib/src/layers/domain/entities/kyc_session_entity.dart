import 'package:equatable/equatable.dart';

class KycSessionEntity extends Equatable {
  final String? uuid;
  final String? diditSessionId;
  final String? status;
  final String verificationUrl;

  const KycSessionEntity({
    required this.verificationUrl,
    this.uuid,
    this.diditSessionId,
    this.status,
  });

  /// Didit session token, extracted from the verification url:
  /// https://verify.didit.me/session/{token}
  String? get sessionToken {
    final segments = Uri.tryParse(verificationUrl)?.pathSegments ?? const [];
    if (segments.isNotEmpty) return segments.last;
    return diditSessionId;
  }

  @override
  List<Object?> get props => [uuid, diditSessionId, status, verificationUrl];
}