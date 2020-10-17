import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "8e57f29ef8c6c2a0f6ac72819901d50b0a15fd78";
  StreamController _streamController;
  Stream _stream;
  TextEditingController _textController = TextEditingController();
  _search() async {
    if (_textController.text == null || _textController.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response _response = await get(_url + _textController.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(_response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Dictionary"),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0)),
                        child: TextFormField(
                          onChanged: (String text) {
                            print("a");
                          },
                          decoration: InputDecoration(
                            hintText: "Type in something",
                            contentPadding: EdgeInsets.only(left: 15.0),
                            border: InputBorder.none,
                          ),
                          controller: _textController,
                        ),
                      ),
                    IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          print("meta");
                          _search();
                        })
                  ],
                ))),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //print(snapshot.data["definitions"].length);
                if (snapshot.data == null) {
                  return Center(
                    child: Text("Enter a word to search"),
                  );
                }
                if (snapshot.data == "waiting") {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data["definitions"].length != 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 58.0),
                      child: Center(
                        child: Column(
                            //scrollDirection: Axis.horizontal,

                            children: <Widget>[
                              Container(
                                //elevation: 5,
                                color: Colors.transparent,
                                child: snapshot.data["definitions"][0]
                                            ["image_url"] ==
                                        null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.red[100],
                                        radius: 140,
                                      )
                                    : CircleAvatar(
                                        radius: 140,
                                        backgroundImage: NetworkImage(
                                            snapshot.data["definitions"][0]
                                                ["image_url"]),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _textController.text.trim(),
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48.0),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              Center(
                                child: Text(
                                  (snapshot.data["pronunciation"] == null)
                                      ? ""
                                      : ("/" +
                                          snapshot.data["pronunciation"] +
                                          "/"),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              SizedBox(width: 20),
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 21.0),
                                child: Text(
                                  (snapshot.data["definitions"][0]
                                      ["definition"]),
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                            ]),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("No results found"),
                    );
                  }
                }
              }),
        ));
  }
}

// return ListView.builder(
//                 //scrollDirection: Axis.horizontal,
//                 itemCount: snapshot.data["definitions"].length,

//                 itemBuilder: (BuildContext context, int index){
//                   return ListBody(
//                     children: <Widget>[
//                       Container(color: Colors.grey[400],
//                       child: ListTile(
//                         leading:snapshot.data["definitions"][index]["image_url"]   == null ? null: CircleAvatar(backgroundImage: NetworkImage(snapshot.data["definitions"][index]["image_url"]),),
//                         title: Text(_textController.text.trim() + "(" + snapshot.data["definitions"][index]["type"] + ")"),

//                       )),
//                       Padding(padding: const EdgeInsets.all(8.0),
//                       child:  Text(_textController.text.trim() + "(" + snapshot.data["definitions"][index]["type"] + ")"),
//                       )
//                     ]
//                   );
//                 }
//               );
