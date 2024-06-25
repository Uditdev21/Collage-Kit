import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collagekit/services/test_services.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TestServices services = TestServices();
  late Stream<DocumentSnapshot> testDataStream;

  @override
  void initState() {
    super.initState();
    testDataStream = services.showtestdat(); // Initialize your stream here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          // Use LayoutBuilder to rebuild on size changes
          builder: (context, constraints) {
            // Calculate the text size based on the constraints.maxWidth
            double textSize =
                constraints.maxWidth * 0.05; // Example: 5% of max width

            return StreamBuilder<DocumentSnapshot>(
              stream: testDataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  // Use the calculated text size for your Text widget
                  return Text(
                    data['test'] ?? 'Field not found',
                    style: TextStyle(
                      fontSize: textSize, // Set the text size dynamically
                    ),
                  );
                } else {
                  return Text('No data found');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
