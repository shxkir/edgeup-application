import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service for handling Firebase Storage operations
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  ///
  /// [file] - The file to upload
  /// [path] - The storage path (e.g., 'users/{userId}/profile.jpg')
  /// Returns the download URL of the uploaded file
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('Upload is $progress% complete');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload multiple files
  Future<List<String>> uploadMultipleFiles(
    List<File> files,
    String basePath,
  ) async {
    final urls = <String>[];
    for (var i = 0; i < files.length; i++) {
      final url = await uploadFile(files[i], '$basePath/file_$i');
      urls.add(url);
    }
    return urls;
  }

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get download URL for a file
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// List all files in a directory
  Future<List<String>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();

      final urls = <String>[];
      for (final item in result.items) {
        final url = await item.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// Get file metadata
  Future<FullMetadata> getMetadata(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get metadata: $e');
    }
  }
}
