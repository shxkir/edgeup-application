import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/announcement_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/class_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/quiz_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, ClassEntity?>> getNextClass();
  Future<Either<Failure, List<QuizEntity>>> getUpcomingQuizzes();
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements();
}
