import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logAction(String action, String substationId) async {
    await _firestore.collection('action_logs').add({
      'action': action,
      'substation_id': substationId,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'completed',
    });
  }

  Stream<QuerySnapshot> getSubstations() {
    return _firestore.collection('substations').snapshots();
  }
}
