import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shades/features/resource_mgt/reportResource.dart';
import 'package:shades/features/resource_mgt/upload.dart';
import 'package:shades/features/resource_mgt/ViewPdf.dart';

class Resourceoperations extends StatefulWidget {
  const Resourceoperations({super.key});

  @override
  State<Resourceoperations> createState() => MywidgetState();
}

class MywidgetState extends State<Resourceoperations> {
  //tetx field conrtoller
  final TextEditingController _resourceNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _resources =
      FirebaseFirestore.instance.collection('resources');

  // String searchText = '';
  // bool isSearchClicked = false;

  // Create operation
  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Insert Resource Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(labelText: "Module Name"),
                ),
                TextField(
                  controller: _subjectCodeController,
                  decoration: const InputDecoration(labelText: "Subject Code"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _ratingsController,
                  decoration: const InputDecoration(labelText: "File Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;
                      final String ratings = _ratingsController.text;

                      await _resources.add({
                        'resourceName': resourceName,
                        'subjectCode': subjectCode,
                        'description': description,
                        'Ratings': ratings,
                      });
                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";
                      _ratingsController.text = "";

                      // Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Upload()));
                    },
                    child: const Text("Create")),
              ],
            ),
          );
        });
  }

//update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _resourceNameController.text =
          documentSnapshot['resourceName'].toString();
      _subjectCodeController.text = documentSnapshot['subjectCode'].toString();
      _descriptionController.text = documentSnapshot['description'].toString();
      _ratingsController.text = documentSnapshot['Ratings'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Update Resource Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(labelText: "Resource Name"),
                ),
                TextField(
                  controller: _subjectCodeController,
                  decoration: const InputDecoration(labelText: "Subject Code"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _ratingsController,
                  decoration: const InputDecoration(labelText: "File Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;
                      final String ratings = _ratingsController.text;

                      // await _resources.({
                      //   'resourceName': resourceName,
                      //   'subjectCode': subjectCode,
                      //   'description': description,
                      //   'Ratings': ratings,
                      // });

                      await _resources.doc(documentSnapshot!.id).update({
                        'resourceName': resourceName,
                        'subjectCode': subjectCode,
                        'description': description,
                        'Ratings': ratings,
                      });
                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";
                      _ratingsController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  //delete operation
  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    await _resources.doc(documentSnapshot!.id).delete();
  }

  // void _onSearchChanged(String value) {
  //   setState(() {
  //     searchText = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        // title: isSearchClicked
        //     ? Container(
        //         height: 40,
        //         decoration: BoxDecoration(
        //             color: const Color.fromARGB(255, 253, 255, 255),
        //             borderRadius: BorderRadius.circular(30)),
        //         child: TextField(
        //           controller: _searchController,
        //           onChanged: _onSearchChanged,
        //           decoration: const InputDecoration(
        //             hintText: "Search",
        //           ),
        //         ),
        //       )
        //     : const Text(
        //         "search here",
        //         style: TextStyle(
        //           fontStyle: FontStyle.italic,
        //           color: Color.fromARGB(
        //               115, 253, 253, 253), // Set text color to white
        //         ),
        //       ),
        // backgroundColor: const Color.fromARGB(255, 39, 10, 94),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         isSearchClicked = !isSearchClicked;
        //       });
        //     },
        //     icon: const Icon(Icons.search_sharp),
        //   )
        // ],
      ),
      body: StreamBuilder(
          stream: _resources.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Column(
                children: [
                  // Add your text widget here
                  const Center(
                    child: Text(
                      'Resource List',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 3, 8),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];

                          return SizedBox(
                            height: 110,
                            child: Card(
                              shadowColor: Colors.black,
                              color: const Color.fromARGB(246, 241, 241, 240),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.all(10),
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/resource/PDF.jpg',
                                        width: 50,
                                        height: 50,
                                      ),
                                      // CircleAvatar(
                                      //   radius: 17,
                                      //   backgroundColor:
                                      //       const Color.fromARGB(255, 255, 106, 7),

                                      // ),
                                    ],
                                  ),
                                  title: Text(
                                    documentSnapshot['resourceName'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 2, 3, 8),
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${documentSnapshot['subjectCode'].toString()} \n ${documentSnapshot['Ratings'].toString()} \n ${documentSnapshot['description']}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 2, 3, 8),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _update(documentSnapshot),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _delete(documentSnapshot),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.report),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Scaffold(
                                                body: ResourceReportForm(),
                                                // body: ViewPdf(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: const Color.fromARGB(255, 88, 168, 243),
        child: const Icon(Icons.add),
      ),
    );
  }
}
