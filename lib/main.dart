import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Request',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Dio request'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scrollController = ScrollController();
  List jsonList = [];
  int page = 1;
  int limit = 10;
  bool isLoaadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    //getData();
  }

  void getData() async {
    final url =
        'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=$limit';
    try {
      var response = await Dio().get(url);
      print(url);
      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data as List;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void getDataMore() async {
    final url =
        'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=$limit';
    try {
      var response = await Dio().get(url);
      print(url);
      if (response.statusCode == 200) {
        setState(() {
          List newList = [];
          newList = response.data as List;
          jsonList.addAll(newList);
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _scrollListener() async {
    if (isLoaadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoaadingMore = true;
      });
      page = page + 1;
      //limit = 5;
      getDataMore();

      setState(() {
        isLoaadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        controller: scrollController,
        itemCount: isLoaadingMore ? jsonList.length + 1 : jsonList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < jsonList.length) {
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Text(
                    jsonList[index]['id'].toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                title: Text(jsonList[index]['title']),
                subtitle: Text(jsonList[index]['url']),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
