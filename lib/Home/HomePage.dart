import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collagekit/Home/PageDrawer.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:collagekit/services/pdfViwer.dart';
import 'package:collagekit/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  authServices authservices = authServices();
  StorageServices storageservices = StorageServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      drawer: Pagedrawer(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Stream<QuerySnapshot>>(
              future: storageservices.getNotes(),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.bouncingBall(
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                }
                if (futureSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${futureSnapshot.error}'),
                  );
                }
                if (!futureSnapshot.hasData) {
                  return Center(
                    child: Text('No data available'),
                  );
                }

                Stream<QuerySnapshot> notesStream = futureSnapshot.data!;

                return StreamBuilder<QuerySnapshot>(
                  stream: notesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.bouncingBall(
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('No notes found'),
                      );
                    }

                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            documents[index].data() as Map<String, dynamic>;
                        return Container(
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 04,
                                    color: Color.fromRGBO(83, 86, 255, 1))
                              ],
                              color: Theme.of(context).primaryColor),
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${data['Subject']}'),
                                  Text('${data['Collage']}'),
                                  Text('Semester : ${data['Semester']}')
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        print('clicked view PDF');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PDFViewerPage(
                                                      pdfUrl: data['FileURL'])),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        child: Center(
                                            child: Text(
                                          'View',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(83, 86, 255, 1),
                                            border: Border.all(
                                                width: 5,
                                                color: Color.fromRGBO(
                                                    223, 245, 255, 1)),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )),

                                  //for offline UNDER DEVELOPMENT
                                  // TextButton(
                                  //     onPressed: () {
                                  //       print('clicked downloade');
                                  //     },
                                  //     child: Text('downloade')),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
