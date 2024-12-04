import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getCurrentUser();
}
