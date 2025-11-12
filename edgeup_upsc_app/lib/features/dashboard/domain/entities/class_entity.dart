import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String id;
  final String subject;
  final String topic;
  final DateTime startTime;
  final String? meetLink;
  final String? instructor;

  const ClassEntity({
    required this.id,
    required this.subject,
    required this.topic,
    required this.startTime,
    this.meetLink,
    this.instructor,
  });

  @override
  List<Object?> get props => [id, subject, topic, startTime, meetLink, instructor];
}
