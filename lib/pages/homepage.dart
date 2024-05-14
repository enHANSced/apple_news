import 'dart:convert';
//import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl =
      'https://newsapi.org/v2/everything?q=apple&from=2024-05-13&to=2024-05-13&sortBy=popularity&apiKey=5e874bda77484ed9b4c470f1b04c1fc6';

  List data = [];

  String formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 1) {
      return '${difference.inDays}d';
    } else if (difference.inDays == 1) {
      return '1d';
    } else if (difference.inHours > 1) {
      return '${difference.inHours}h';
    } else if (difference.inHours == 1) {
      return 'An hour ago';
    } else {
      return 'Just now';
    }
  }

  String formatDateToDisplay(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}';
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['articles'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple News'),
        //backgroundColor: Colors.blueGrey,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 50,
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                //side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: GestureDetector(
                onTap: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //const SizedBox(height: 10),
                              Text(
                                data[index]['title'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                data[index]['urlToImage'] ?? 'No image',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox();
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(data[index]['author'] ?? 'No author'),
                              Text(
                                formatDateToDisplay(data[index]['publishedAt']),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data[index]['description'],
                                style: const TextStyle(fontSize: 16),
                              ),

                              const SizedBox(height: 10),
                              data[index]['url'] != null
                                  ? Text(
                                      '${data[index]['url']}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade900,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data[index]['urlToImage'] != null
                          ? Image.network(
                              data[index]['urlToImage'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const SizedBox();
                              },
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      Text(
                        data[index]['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${data[index]['source']['name']} • ${formatDate(data[index]['publishedAt'])}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
