import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  //create a new note
  Future<void> addNote(String note){
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  //read a note
  Stream<QuerySnapshot> getNotes(){
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //update a note by doc id
  Future<void> updateNote(String docId, String newNote){
    return notes.doc(docId).update({
      'note':newNote,
      'timestamp': Timestamp.now(),
    });
  }
    
  
  //delete a note

  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}
