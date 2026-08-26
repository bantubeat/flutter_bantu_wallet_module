import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';

import '../../repositories/user_repository.dart';

class UploadMonetizationDocumentUseCase
    extends UseCase<String, UploadMonetizationDocumentParams> {
  static const String contextMonetizationDocument = 'monetization_document';

  final UserRepository _repository;

  UploadMonetizationDocumentUseCase(this._repository);

  @override
  Future<String> call(params) async {
    return await _repository.uploadDocument(
      filePath: params.filePath,
      fileName: params.fileName,
      context: contextMonetizationDocument,
    );
  }
}

class UploadMonetizationDocumentParams {
  final String filePath;
  final String fileName;

  const UploadMonetizationDocumentParams({
    required this.filePath,
    required this.fileName,
  });
}
