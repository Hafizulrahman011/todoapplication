import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/intro_page.dart';
import 'package:todoapp/services/firestore.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // Function to access the text from the textfield
  final TextEditingController noteController = TextEditingController();

  // Firestore class
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[300],
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IntroPage()));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: buildNotes(),
    );
  }

  // Function to open a box to add a new note
  void openNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'Enter your note',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Add a note to the Firestore
              if (docId == null) {
                firestoreService.addNote(noteController.text);
              }
              //update existing note
              else {
                firestoreService.updateNote(docId, noteController.text);
              }

              // Clear the textfield
              noteController.clear();

              // Close the dialog box
              Navigator.pop(context);
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }

  // Function to display the notes
  Widget buildNotes() {
    return StreamBuilder(
      stream: firestoreService.getNotes(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // If we have data, get all the docs
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> noteList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, index) {
              // Get each doc
              QueryDocumentSnapshot document = noteList[index];
              String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String noteText = data['note'];

              // Display as a list tile
              return Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(4.0, 4.0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(-4.0, -4.0),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update button
                      IconButton(
                        onPressed: () {
                          openNoteBox(docId: docID);
                        },
                        icon: const Icon(Icons.edit_document),
                      ),

                      //delete button
                      //update button
                      IconButton(
                        onPressed: () {
                          firestoreService.deleteNote(docID);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // If no data available
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
