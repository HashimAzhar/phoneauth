import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/fireBaseServices/widgets/roundButton.dart';
import 'package:phoneauth/ui/fireStore/firestoreListScreen.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class addFirestoreData extends StatefulWidget {
  const addFirestoreData({super.key});

  @override
  State<addFirestoreData> createState() => _addFirestoreDataState();
}

class _addFirestoreDataState extends State<addFirestoreData> {
  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            roundButton(
                loading: loading,
                title: 'Add',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post Added');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (conetext) => fireStoreScreen()));
                  }).onError((error, StackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
