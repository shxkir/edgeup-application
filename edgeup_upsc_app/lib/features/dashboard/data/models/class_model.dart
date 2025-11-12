import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edgeup_upsc_app/features/dashboard/domain/entities/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.subject,
    required super.topic,
    required super.startTime,
    super.meetLink,
    super.instructor,
  });

  factory ClassModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassModel(
      id: doc.id,
      subject: data['subject'] as String,
      topic: data['topic'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      meetLink: data['meetLink'] as String?,
      instructor: data['instructor'] as String?,
    );
  }

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      meetLink: json['meetLink'] as String?,
      instructor: json['instructor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'topic': topic,
      'startTime': startTime.toIso8601String(),
      'meetLink': meetLink,
      'instructor': instructor,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'subject': subject,
      'topic': topic,
      'startTime': Timestamp.fromDate(startTime),
      'meetLink': meetLink,
      'instructor': instructor,
    };
  }
}
