import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/quiz_entity.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.title,
    required super.topic,
    required super.dueDate,
    required super.totalQuestions,
    required super.duration,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      title: data['title'] as String,
      topic: data['topic'] as String,
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      totalQuestions: data['totalQuestions'] as int,
      duration: data['duration'] as int,
    );
  }

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      topic: json['topic'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      totalQuestions: json['totalQuestions'] as int,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'topic': topic,
      'dueDate': dueDate.toIso8601String(),
      'totalQuestions': totalQuestions,
      'duration': duration,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'topic': topic,
      'dueDate': Timestamp.fromDate(dueDate),
      'totalQuestions': totalQuestions,
      'duration': duration,
    };
  }
}
