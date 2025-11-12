import 'package:equatable/equatable.dart';

class QuizEntity extends Equatable {
  final String id;
  final String title;
  final String topic;
  final DateTime dueDate;
  final int totalQuestions;
  final int duration; // in minutes

  const QuizEntity({
    required this.id,
    required this.title,
    required this.topic,
    required this.dueDate,
    required this.totalQuestions,
    required this.duration,
  });

  @override
  List<Object> get props => [id, title, topic, dueDate, totalQuestions, duration];
}
