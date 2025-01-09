import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pertemuan12/models/journal.dart';
import 'package:pertemuan12/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = 'journals';

  DbFirestoreService() {
    // Firestore settings are now set via the FirebaseFirestore instance
    _firestore.settings = const Settings();
  }

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs = snapshot.docs.map((doc) {
        return Journal.fromDoc(doc);
      }).toList();
      _journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));
      return _journalDocs;
    });
  }

  Future<Journal> getJournal(String documentID) async {
    DocumentSnapshot documentSnapshot =
    await _firestore.collection(_collectionJournals).doc(documentID).get();
    return Journal.fromDoc(documentSnapshot);
  }

  Future<bool> addJournal(Journal journal) async {
    DocumentReference _documentReference =
    await _firestore.collection(_collectionJournals).add({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
      'uid': journal.uid,
    });
    return _documentReference.id.isNotEmpty;
  }

  Future<void> updateJournal(Journal journal) async {
    try {
      await _firestore
          .collection(_collectionJournals)
          .doc(journal.documentID)
          .update({
        'date': journal.date,
        'mood': journal.mood,
        'note': journal.note,
      });
    } catch (error) {
      print('Error updating: $error');
    }
  }

  Future<void> updateJournalWithTransaction(Journal journal) async {
    DocumentReference _documentReference =
    _firestore.collection(_collectionJournals).doc(journal.documentID);
    var journalData = {
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    };
    await _firestore.runTransaction((transaction) async {
      transaction.update(_documentReference, journalData);
    }).catchError((error) => print('Error updating: $error'));
  }

  Future<void> deleteJournal(Journal journal) async {
    try {
      await _firestore
          .collection(_collectionJournals)
          .doc(journal.documentID)
          .delete();
    } catch (error) {
      print('Error deleting: $error');
    }
  }
}
