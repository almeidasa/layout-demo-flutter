import 'package:flutter/material.dart';
import 'package:layout_demo_flutter/layout_type.dart';
import 'package:layout_demo_flutter/pages/main_app_bar.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

List<Issues> allIssues = [];
class Issues {
  Issues({this.hours, this.comments});

  final String hours;
  final String comments;
}

class ListPage extends StatelessWidget implements HasLayoutGroup {
  ListPage({Key key, this.layoutGroup, this.onLayoutToggle}) : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    _createList();
    return Scaffold(
      appBar: MainAppBar(
        layoutGroup: layoutGroup,
        layoutType: LayoutType.list,
        onLayoutToggle: onLayoutToggle,
      ),
      body: Container(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: allIssues.length,
        itemBuilder: (BuildContext content, int index) {
          Issues issue = allIssues[index];
          return IssueList(issue);
        });
  }
}

void _createList() {
  Map data;
  String apiKey = 'd9991ea89ca81352c9dce1182bc47a1f319065fa';
  String userId = '88';
  String spentOn = '2018-08-29';

  Future<void> getData() async {
    try {
      var response = await http.get(
          Uri.encodeFull(
              "https://projetos.supera.com.br/time_entries.json?key=" + apiKey +
                  "&user_id=" + userId +
                  "&spent_on=" + spentOn + "&limit=10"),
          headers: {"Accept": "application/json"});

      data = json.decode(response.body);

      allIssues.clear();
      for (int i = 0; i < data.length; i++) {
        allIssues.add(Issues(hours: data['time_entries'][i]['hours'].toString(),
            comments: data['time_entries'][i]['comments'].toString()));
        print(data['time_entries'][i]['comments'].toString());
      }

    } catch (e) {
      print('Erro na requisição: ' + e.toString());
    }
  }
  getData();
}

class IssueList extends ListTile {
  IssueList(Issues issue) : super(title: Text(issue.hours),subtitle: Text(issue.comments),);
}


