import 'package:dartz/dartz.dart';
import 'package:edgeup_upsc_app/core/errors/failures.dart';
import 'package:edgeup_upsc_app/core/usecases/usecase.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/announcement_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetAnnouncements implements UseCase<List<AnnouncementEntity>, NoParams> {
  final DashboardRepository repository;

  GetAnnouncements(this.repository);

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> call(NoParams params) async {
    return await repository.getAnnouncements();
  }
}
