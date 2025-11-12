import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/core/usecases/usecase.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/quiz_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetUpcomingQuizzes implements UseCase<List<QuizEntity>, NoParams> {
  final DashboardRepository repository;

  GetUpcomingQuizzes(this.repository);

  @override
  Future<Either<Failure, List<QuizEntity>>> call(NoParams params) async {
    return await repository.getUpcomingQuizzes();
  }
}
