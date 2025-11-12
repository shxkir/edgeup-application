import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:edgeup_upsc_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:edgeup_upsc_app/features/auth/data/models/user_model.dart';
import 'package:edgeup_upsc_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('loginWithEmail', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUserModel = UserModel(
      id: '123',
      email: tEmail,
      name: 'Test User',
    );

    test(
      'should return UserEntity when login is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.loginWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => tUserModel);

        when(mockLocalDataSource.cacheUser(any))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.loginWithEmail(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(const Right(tUserModel)));
        verify(mockRemoteDataSource.loginWithEmail(
          email: tEmail,
          password: tPassword,
        ));
        verify(mockLocalDataSource.cacheUser(tUserModel));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return AuthFailure when login fails',
      () async {
        // arrange
        when(mockRemoteDataSource.loginWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Login failed'));

        // act
        final result = await repository.loginWithEmail(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<AuthFailure>()),
          (_) => fail('Should return failure'),
        );
        verify(mockRemoteDataSource.loginWithEmail(
          email: tEmail,
          password: tPassword,
        ));
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  });

  group('logout', () {
    test(
      'should logout successfully and clear cache',
      () async {
        // arrange
        when(mockRemoteDataSource.logout())
            .thenAnswer((_) async => Future.value());
        when(mockLocalDataSource.clearCache())
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.logout();

        // assert
        expect(result, equals(const Right(null)));
        verify(mockRemoteDataSource.logout());
        verify(mockLocalDataSource.clearCache());
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return AuthFailure when logout fails',
      () async {
        // arrange
        when(mockRemoteDataSource.logout())
            .thenThrow(Exception('Logout failed'));

        // act
        final result = await repository.logout();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<AuthFailure>()),
          (_) => fail('Should return failure'),
        );
        verify(mockRemoteDataSource.logout());
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );
  });

  group('checkAuthStatus', () {
    const tUserModel = UserModel(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
    );

    test(
      'should return user when already logged in and verified remotely',
      () async {
        // arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getCurrentUser())
            .thenAnswer((_) async => tUserModel);
        when(mockLocalDataSource.cacheUser(any))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.checkAuthStatus();

        // assert
        expect(result, equals(const Right(tUserModel)));
        verify(mockLocalDataSource.isLoggedIn());
        verify(mockRemoteDataSource.getCurrentUser());
        verify(mockLocalDataSource.cacheUser(tUserModel));
      },
    );

    test(
      'should return null when not logged in locally',
      () async {
        // arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => false);

        // act
        final result = await repository.checkAuthStatus();

        // assert
        expect(result, equals(const Right<Failure, UserModel?>(null)));
        verify(mockLocalDataSource.isLoggedIn());
        verifyNoMoreInteractions(mockLocalDataSource);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );
  });
}
