import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/core/usecases/usecase.dart';
import 'package:edgeup_upsc_app/features/auth/domain/entities/user_entity.dart';
import 'package:edgeup_upsc_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}
