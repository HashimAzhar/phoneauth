import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/fireBaseServices/widgets/roundButton.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({super.key});

  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

class _addPostScreenState extends State<addPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
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
                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'title': postController.text.toString(),
                    'id': id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage('Post added');
                    postController.clear();
                  }).onError((error, stackTrace) {
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
