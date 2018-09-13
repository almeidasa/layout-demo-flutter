import 'package:flutter/material.dart';
import 'package:layout_demo_flutter/layout_type.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SliversPage extends StatelessWidget implements HasLayoutGroup {
  SliversPage({Key key, this.layoutGroup, this.onLayoutToggle})
      : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    _createList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            pinned: true,
            expandedHeight: 60.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Atividades'),
            ),
            leading: IconButton(
              icon: Icon(layoutGroup == LayoutGroup.nonScrollable
                  ? Icons.filter_1
                  : Icons.filter_2),
              onPressed: onLayoutToggle,
            )),
        SliverFixedExtentList(
          itemExtent: 90.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightGreen,
                child: Text('$comments $hours '),
              );
            },
          ),
        ),
      ],
    );
  }
}

String hours;
String comments;
Map data;
String apiKey = 'd9991ea89ca81352c9dce1182bc47a1f319065fa';
String userId = '88';
String spentOn = '2018-08-29';

void _createList() {
  Future<void> getData() async {
    try {
      var response = await http.get(
          Uri.encodeFull(
              "https://projetos.supera.com.br/time_entries.json?key=" +
                  apiKey +
                  "&user_id=" +
                  userId +
                  "&spent_on=" +
                  spentOn +
                  "&limit=10"),
          headers: {"Accept": "application/json"});

      data = json.decode(response.body);

      for (int i = 0; i < data.length; i++) {
        hours = data['time_entries'][i]['hours'].toString();
        comments = data['time_entries'][i]['comments'].toString();
        //print(comments + ' ' + hours);
      }
    } catch (e) {
      print('Erro na requisição: ' + e.toString());
    }
  }
  getData();
}
