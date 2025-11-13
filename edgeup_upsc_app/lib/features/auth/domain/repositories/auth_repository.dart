import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithGoogle();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> checkAuthStatus();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, bool>> isEmailVerified();
}
