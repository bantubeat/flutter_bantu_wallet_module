import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/bantubeat_api_data_source.dart';

class UserRepositoryImpl extends UserRepository {
  final BantubeatApiDataSource _apiDataSource;

  UserRepositoryImpl(this._apiDataSource);

  @override
  Future<UserEntity> getCurrentUser() => _apiDataSource.get$authUser();
}
