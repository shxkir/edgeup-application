import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgeup_upsc_app/core/constants/app_constants.dart';
import 'package:edgeup_upsc_app/features/dashboard/data/models/announcement_model.dart';
import 'package:edgeup_upsc_app/features/dashboard/data/models/class_model.dart';
import 'package:edgeup_upsc_app/features/dashboard/data/models/quiz_model.dart';

abstract class DashboardRemoteDataSource {
  Future<ClassModel?> getNextClass();
  Future<List<QuizModel>> getUpcomingQuizzes();
  Future<List<AnnouncementModel>> getAnnouncements();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ClassModel?> getNextClass() async {
    try {
      final now = DateTime.now();

      final querySnapshot = await firestore
          .collection(AppConstants.classesCollection)
          .where('startTime', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('startTime', descending: false)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return ClassModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get next class: ${e.toString()}');
    }
  }

  @override
  Future<List<QuizModel>> getUpcomingQuizzes() async {
    try {
      final now = DateTime.now();

      final querySnapshot = await firestore
          .collection(AppConstants.quizzesCollection)
          .where('dueDate', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('dueDate', descending: false)
          .limit(5)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get upcoming quizzes: ${e.toString()}');
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final querySnapshot = await firestore
          .collection(AppConstants.announcementsCollection)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => AnnouncementModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get announcements: ${e.toString()}');
    }
  }
}
