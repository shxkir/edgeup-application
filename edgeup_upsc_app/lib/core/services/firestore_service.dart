import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling Firestore CRUD operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== CREATE ====================

  /// Create a new document with auto-generated ID
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      final docRef = await _firestore.collection(collection).add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  /// Create or set a document with a specific ID
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(
        {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: merge),
      );
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  // ==================== READ ====================

  /// Get a single document by ID
  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String docId,
  ) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  /// Get all documents in a collection
  Future<List<Map<String, dynamic>>> getAllDocuments(
    String collection,
  ) async {
    try {
      final snapshot = await _firestore.collection(collection).get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents: $e');
    }
  }

  /// Query documents with conditions
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    String? whereField,
    dynamic whereValue,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (whereField != null) {
        query = query.where(whereField, isEqualTo: whereValue);
      }

      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      throw Exception('Failed to query documents: $e');
    }
  }

  /// Stream a single document (real-time updates)
  Stream<Map<String, dynamic>?> streamDocument(
    String collection,
    String docId,
  ) {
    return _firestore.collection(collection).doc(docId).snapshots().map(
      (doc) {
        if (doc.exists) {
          return {'id': doc.id, ...doc.data()!};
        }
        return null;
      },
    );
  }

  /// Stream all documents in a collection (real-time updates)
  Stream<List<Map<String, dynamic>>> streamCollection(
    String collection, {
    String? orderByField,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList(),
        );
  }

  // ==================== UPDATE ====================

  /// Update specific fields in a document
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// Increment a numeric field
  Future<void> incrementField(
    String collection,
    String docId,
    String field,
    num value,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.increment(value),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to increment field: $e');
    }
  }

  /// Add an item to an array field
  Future<void> arrayUnion(
    String collection,
    String docId,
    String field,
    List<dynamic> values,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.arrayUnion(values),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add to array: $e');
    }
  }

  /// Remove an item from an array field
  Future<void> arrayRemove(
    String collection,
    String docId,
    String field,
    List<dynamic> values,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        field: FieldValue.arrayRemove(values),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove from array: $e');
    }
  }

  // ==================== DELETE ====================

  /// Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Batch delete multiple documents
  Future<void> batchDelete(
    String collection,
    List<String> docIds,
  ) async {
    try {
      final batch = _firestore.batch();
      for (final docId in docIds) {
        batch.delete(_firestore.collection(collection).doc(docId));
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch delete: $e');
    }
  }

  // ==================== BATCH OPERATIONS ====================

  /// Batch write multiple operations
  Future<void> batchWrite(
    List<BatchOperation> operations,
  ) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final docRef = _firestore
            .collection(operation.collection)
            .doc(operation.docId);

        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(docRef, operation.data!);
            break;
          case BatchOperationType.update:
            batch.update(docRef, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch write: $e');
    }
  }

  // ==================== TRANSACTIONS ====================

  /// Execute a transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    try {
      return await _firestore.runTransaction(updateFunction);
    } catch (e) {
      throw Exception('Transaction failed: $e');
    }
  }
}

// Helper classes for batch operations
enum BatchOperationType { set, update, delete }

class BatchOperation {
  final String collection;
  final String docId;
  final BatchOperationType type;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.collection,
    required this.docId,
    required this.type,
    this.data,
  });
}
