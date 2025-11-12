import 'package:equatable/equatable.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/announcement_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/class_entity.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/quiz_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final ClassEntity? nextClass;
  final List<QuizEntity> upcomingQuizzes;
  final List<AnnouncementEntity> announcements;

  const DashboardLoaded({
    this.nextClass,
    required this.upcomingQuizzes,
    required this.announcements,
  });

  @override
  List<Object?> get props => [nextClass, upcomingQuizzes, announcements];
}

class DashboardEmpty extends DashboardState {
  const DashboardEmpty();
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
