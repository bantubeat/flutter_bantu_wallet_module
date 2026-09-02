class ProfileCompletionEntity {
  final bool isComplete;
  final List<String> missingFields;

  const ProfileCompletionEntity({
    required this.isComplete,
    required this.missingFields,
  });

  factory ProfileCompletionEntity.fromJson(Map<String, dynamic> json) {
    return ProfileCompletionEntity(
      isComplete: json['is_complete'] as bool? ?? false,
      missingFields: (json['missing_fields'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
