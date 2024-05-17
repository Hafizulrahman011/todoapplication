import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      //drawer to navigate to other pages
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
              return Slidable(
                endActionPane: ActionPane(
                  motion: StretchMotion(),
                  children: [
                    //update button
                    SlidableAction(
                      onPressed: (context) {
                        openNoteBox(docId: docID);
                      },
                      flex: 2,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.blue,
                      icon: Icons.edit,
                    ),
                    //delete button
                    SlidableAction(
                      onPressed: (context) {
                        firestoreService.deleteNote(docID);
                      },
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
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
