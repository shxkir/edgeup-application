import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/announcement_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/class_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/quiz_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ClassEntity?>> getNextClass() async {
    try {
      final result = await remoteDataSource.getNextClass();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuizEntity>>> getUpcomingQuizzes() async {
    try {
      final result = await remoteDataSource.getUpcomingQuizzes();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async {
    try {
      final result = await remoteDataSource.getAnnouncements();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
