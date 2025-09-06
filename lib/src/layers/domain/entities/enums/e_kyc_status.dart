enum EKycStatus {
  pending('PENDING'),
  success('SUCCESS'),
  failed('FAILED'),
  unknow('UNKNOWN');

  final String value;

  const EKycStatus(this.value);
}
