import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/core/usecases/usecase.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/class_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetNextClass implements UseCase<ClassEntity?, NoParams> {
  final DashboardRepository repository;

  GetNextClass(this.repository);

  @override
  Future<Either<Failure, ClassEntity?>> call(NoParams params) async {
    return await repository.getNextClass();
  }
}
