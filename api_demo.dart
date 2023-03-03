
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'insert_user.dart';

class ApiDemo extends StatefulWidget {
  const ApiDemo({Key? key}) : super(key: key);

  @override
  State<ApiDemo> createState() => _ApiDemoState();
}


class _ApiDemoState extends State<ApiDemo> {
  String Url = 'https://6310390036e6a2a04ee856d8.mockapi.io/Faculties';

  get index => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                size: 24,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Insert_User(null);
              })).then((value) {
                if (value == true) {
                  setState(() {});
                }
              });
            },
          )
        ],
      ),
      body: FutureBuilder<http.Response>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> datas = jsonDecode(snapshot.data!.body.toString());
            datas.reversed;
            return ListView.builder(
              itemCount: jsonDecode(snapshot.data!.body.toString()).length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Insert_User(
                          jsonDecode(snapshot.data!.body.toString())[index]);
                    })).then((value) {
                      if (value == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                  index]['FacultyName'])
                                      .toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                  index]['Department'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                                Text(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                  index]['FacultyMobile'])
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              (!getBoolFromDynamic(snapshot.data!, index))
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              updateFavourite(
                                  (jsonDecode(snapshot.data!.body.toString())[
                                  index]['id']),
                                  !getBoolFromDynamic(snapshot.data!, index));
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.delete_outline_sharp,
                              color: Colors.red,
                            ),
                            onTap: () {
                              showDeleteAlert((jsonDecode(
                                  snapshot.data!.body.toString())[index]
                              ['id']));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        future: getData(context),
      ),
    );
  }

  void showDeleteAlert(id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text('Are you sure want to delete this record?'),
          actions: [
            TextButton(
                onPressed: () async {
                  http.Response res = await deleteData(id);
                  if (res.statusCode == 200) {
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'))
          ],
        );
      },
    );
  }

  bool getBoolFromDynamic(data, index) {
    try {
      return jsonDecode(data.body.toString())[index]['IsFavourite'] as bool;
    } catch (e) {
      try {
        return jsonDecode(data.body.toString())[index]['IsFavourite']
            .toString()
            .toLowerCase() ==
            'true';
      } catch (e) {
        return false;
      }
    }
  }



  Future<http.Response> getData(context) async {
    var response = await http.get(Uri.parse(Url));

    return response;
  }

  Future<http.Response> deleteData(id) async {
    var response = await http.delete(
        Uri.parse('https://6310390036e6a2a04ee856d8.mockapi.io/Faculties/$id'));

    return response;
  }

  Future<http.Response> updateFavourite(id, value) async {
    Map<String, dynamic> map = {};
    map['IsFavourite'] = value.toString();
    var response = await http.put(
        Uri.parse('https://6310390036e6a2a04ee856d8.mockapi.io/Faculties/$id'),
        body: map);

    return response;
  }
}
