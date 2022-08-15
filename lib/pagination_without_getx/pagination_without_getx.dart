import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/pagination_without_getx/model_class.dart';
import 'package:http/http.dart' as http;

class PaginationWithoutGetX extends StatefulWidget {
  PaginationWithoutGetX({Key? key}) : super(key: key);

  @override
  State<PaginationWithoutGetX> createState() => _PaginationWithoutGetXState();
}

class _PaginationWithoutGetXState extends State<PaginationWithoutGetX> {
  List<Result> result = [];
  ScrollController scrollController = ScrollController();
  bool loading = true;
  int offset = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(offset);
    handleNext();
  }

  void fetchData(paraOffset) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://pokeapi.co/api/v2/pokemon?offset=${paraOffset}&limit=15"));

    ModelClass modelClass = ModelClass.fromJson(json.decode(response.body));
    result = result + modelClass.results;
    int localOffset = offset + 15;
    setState(() {
      result;
      loading = false;
      offset = localOffset;
    });
  }

  void handleNext() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        fetchData(offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite Scroll Pagination"),
      ),
      body: ListView.builder(
          controller: scrollController,
          itemCount: result.length + 1,
          itemBuilder: (context, index) {
            if (index == result.length) {
              return loading
                  ? Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                        ),
                      ),
                    )
                  : Container();
            }
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.emoji_emotions),
                ),
                // tileColor: index % 2 == 0 ? Colors.teal : Colors.yellow,
                title: Text(
                  result[index].name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  result[index].url,
                ),
              ),
            );
          }),
    );
  }
}
