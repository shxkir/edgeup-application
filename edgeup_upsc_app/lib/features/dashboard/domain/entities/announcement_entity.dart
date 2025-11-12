import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? imageUrl;
  final bool isImportant;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.imageUrl,
    this.isImportant = false,
  });

  @override
  List<Object?> get props => [id, title, message, createdAt, imageUrl, isImportant];
}
