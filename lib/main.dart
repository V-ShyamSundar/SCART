import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'shop_welcome_screen.dart'; // Import the ShopWelcomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermarket Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SupermarketSearch(),
    );
  }
}

class SupermarketSearch extends StatefulWidget {
  @override
  _SupermarketSearchState createState() => _SupermarketSearchState();
}

class _SupermarketSearchState extends State<SupermarketSearch> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermarket Search'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for a supermarket',
            ),
            onChanged: (value) {
              searchSupermarkets(value);
            },
          ),
          Expanded(
            child: _loading
                ? const Center(
                    //child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('supermarkets')
                        .where('name', isEqualTo: _searchController.text)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          //child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Text('No supermarkets found');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(doc['name']),
                            onTap: () {
                              // Navigate to ShopWelcomeScreen when a supermarket is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShopWelcomeScreen(
                                    shopName: doc['name'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void searchSupermarkets(String query) {
    setState(() {
      _loading = true;
    });

    if (query.isEmpty) {
      setState(() {
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = false;
    });
  }
}
