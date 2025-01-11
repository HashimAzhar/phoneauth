import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauth/ui/auth/loginScreen.dart';
import 'package:phoneauth/ui/fireStore/addFirestoreData.dart';
import 'package:phoneauth/ui/posts/addPost.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class fireStoreScreen extends StatefulWidget {
  const fireStoreScreen({super.key});

  @override
  State<fireStoreScreen> createState() => _fireStoreScreenState();
}

class _fireStoreScreenState extends State<fireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Firestore'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const loginScreen()));
                  }).onError((error, StackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: const Icon(Icons.logout_outlined),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: fireStore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();
                    if (snapshot.hasError)
                      return Text('Some Error has occoured');
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final title =
                              snapshot.data!.docs[index]['title'].toString();
                          final id =
                              snapshot.data!.docs[index]['id'].toString();
                          return ListTile(
                            title: Text(title),
                            subtitle: Text(id),
                            trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              showMyDialog(title, id);
                                            },
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit'),
                                          )),
                                      PopupMenuItem(
                                          child: ListTile(
                                        leading:
                                            const Icon(Icons.delete_outline),
                                        onTap: () {
                                          Navigator.pop(context);
                                          ref.doc(id).delete();
                                          Utils().toastMessage('Post Deleted');
                                        },
                                        title: const Text('Delete'),
                                      ))
                                    ]),
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const addFirestoreData()));
            },
            child: const Icon(Icons.add),
          )),
    );
  }

  Future<void> showMyDialog(String Title, String Id) async {
    editController.text = Title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                  hintText: 'Edit',
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .doc(Id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().toastMessage('Post Updated');
                    }).onError((error, StackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
