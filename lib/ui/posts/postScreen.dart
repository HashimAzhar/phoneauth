import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauth/ui/auth/loginScreen.dart';
import 'package:phoneauth/ui/posts/addPost.dart';
import 'package:phoneauth/ui/utils/utils.dart';

class postScreen extends StatefulWidget {
  const postScreen({super.key});

  @override
  State<postScreen> createState() => _postScreenState();
}

class _postScreenState extends State<postScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

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
            title: const Text('Post Screen'),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                    controller: searchFilter,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {});
                    }),
              ),
              // Expanded(
              //     child: StreamBuilder(
              //         stream: ref.onValue,
              //         builder:
              //             (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              //           if (!snapshot.hasData) {
              //             return CircularProgressIndicator();
              //           } else {
              //             Map<dynamic, dynamic> map =
              //                 snapshot.data!.snapshot.value as dynamic;
              //             List<dynamic> list = [];
              //             list.clear();
              //             list = map.values.toList();

              //             return ListView.builder(
              //                 itemCount:
              //                     snapshot.data!.snapshot.children.length,
              //                 itemBuilder: (context, index) {
              //                   return ListTile(
              //                     title: Text(list[index]['title']),
              //                     subtitle: Text(list[index]['id']),
              //                   );
              //                 });
              //           }
              //         })),
              Expanded(
                  child: FirebaseAnimatedList(
                      query: ref,
                      defaultChild: const Text('Loading'),
                      itemBuilder: (context, snapshot, animation, index) {
                        final title = snapshot.child('title').value.toString();
                        final id = snapshot.child('id').value.toString();
                        if (searchFilter.text.isEmpty) {
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
                                          ref.child(id).remove();
                                        },
                                        title: const Text('Delete'),
                                      ))
                                    ]),
                          );
                        } else if (title.toLowerCase().contains(
                            searchFilter.text.toLowerCase().toLowerCase())) {
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
                                        const PopupMenuItem(
                                            child: ListTile(
                                          leading: Icon(Icons.delete_outline),
                                          title: Text('Delete'),
                                        ))
                                      ]));
                        } else {
                          return Container();
                        }
                      }))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const addPostScreen()));
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
                        .child(Id)
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
