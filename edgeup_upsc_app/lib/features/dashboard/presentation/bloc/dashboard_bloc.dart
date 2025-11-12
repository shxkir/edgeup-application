import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edgeup_upsc_app/core/usecases/usecase.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/usecases/get_announcements.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/usecases/get_next_class.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/usecases/get_upcoming_quizzes.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetNextClass getNextClass;
  final GetUpcomingQuizzes getUpcomingQuizzes;
  final GetAnnouncements getAnnouncements;

  DashboardBloc({
    required this.getNextClass,
    required this.getUpcomingQuizzes,
    required this.getAnnouncements,
  }) : super(const DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    await _fetchDashboardData(emit);
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    await _fetchDashboardData(emit);
  }

  Future<void> _fetchDashboardData(Emitter<DashboardState> emit) async {
    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        getNextClass(NoParams()),
        getUpcomingQuizzes(NoParams()),
        getAnnouncements(NoParams()),
      ]);

      final nextClassResult = results[0];
      final quizzesResult = results[1];
      final announcementsResult = results[2];

      // Check for any failures
      if (nextClassResult.isLeft()) {
        final failure = nextClassResult.fold((l) => l, (r) => null);
        emit(DashboardError(failure?.message ?? 'Failed to load next class'));
        return;
      }

      if (quizzesResult.isLeft()) {
        final failure = quizzesResult.fold((l) => l, (r) => null);
        emit(DashboardError(failure?.message ?? 'Failed to load quizzes'));
        return;
      }

      if (announcementsResult.isLeft()) {
        final failure = announcementsResult.fold((l) => l, (r) => null);
        emit(DashboardError(failure?.message ?? 'Failed to load announcements'));
        return;
      }

      // Extract the data
      final nextClass = nextClassResult.fold(
        (l) => null,
        (r) => r,
      );

      final quizzes = quizzesResult.fold(
        (l) => <dynamic>[],
        (r) => r,
      );

      final announcements = announcementsResult.fold(
        (l) => <dynamic>[],
        (r) => r,
      );

      // Check if all data is empty
      if (nextClass == null && quizzes.isEmpty && announcements.isEmpty) {
        emit(const DashboardEmpty());
      } else {
        emit(DashboardLoaded(
          nextClass: nextClass,
          upcomingQuizzes: quizzes,
          announcements: announcements,
        ));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
