enum EKycStatus {
  pending('PENDING'),
  success('SUCCESS'),
  failed('FAILED'),
  notSubmitted('404'),
  unknow('UNKNOWN');

  final String value;

  const EKycStatus(this.value);
}
