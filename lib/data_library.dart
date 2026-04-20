import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cbor/simple.dart';
import 'package:flutter/widgets.dart';
import 'package:dartframe/dartframe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frc_adjutant/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLibrary extends StatefulWidget {
  final Map<String, dynamic> library;
  final String name;
  final Function(Map<String, dynamic>) onDataChanged;

  const DataLibrary({
    super.key,
    required this.library,
    required this.name,
    required this.onDataChanged
  });

  @override
  _DataLibraryState createState() => _DataLibraryState(); 
}

class _DataLibraryState extends State<DataLibrary> {
  DataFrame? testLibrary;
  String currentPath = "";
  bool refresh = false;

  Future<void> setPath(String path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString("${widget.name}Path", path);
    currentPath = path;
  }

  Future<void> loadFromPath() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final path = (pref.get("${widget.name}Path") ?? "") as String;

    final pathWorks = await File(path).exists();

    if (pathWorks) {
      final df = await File(path);
      currentPath = path;
        
      final intermediary = await FileReader.readCsv(df.path); // Test Library assignment

      setState(() {
        testLibrary = intermediary;

        setLibrary(intermediary);

        widget.onDataChanged({widget.name: widget.library[widget.name]});
      });
    }
  }

  Set sortTeams(Series<dynamic> t) {
    Set sortedSet = {};
    List teams = t.data;
    teams.sort();

    for (dynamic team in teams) {
      sortedSet.add(team);
    }

    return sortedSet;
  } 

  void uploadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // Opens the file picker window

    //TODO: read file onto the proper document storage file by widget.name comparison
    //overwrite the existing file there

    if (result != null && result.files.single.path != null) {
      final df = await File(result.files.single.path!);

      setPath(result.files.single.path!);
      
      final intermediary = await FileReader.readCsv(df.path); // Test Library assignment

      setState(() {
        testLibrary = intermediary;

        setLibrary(intermediary);

        widget.onDataChanged({widget.name: widget.library[widget.name]});
      });
    } else {
      // User canceled the picker
    }
  }

  void setLibrary(DataFrame data) {
    Series<dynamic> tempList = Series<dynamic>(["null"], name: 'null');
    Map<int, DataFrame> temp = {};
    String name = "";
    bool teamCheck, teamNumberCheck, teamSpaceNumberCheck, teamCapCheck, teamSpaceCapNumberCheck, team1Check, team1CapCheck, team1SpaceNumberCapCheck = false;
    (data.hasColumn("team")) ? teamCheck = true : teamCheck = false;
    (data.hasColumn("teamNumber")) ? teamNumberCheck = true : teamNumberCheck = false;
    (data.hasColumn("team number")) ? teamSpaceNumberCheck = true : teamSpaceNumberCheck = false;
    (data.hasColumn("Team")) ? teamCapCheck = true : teamCapCheck = false;
    (data.hasColumn("Team Number")) ? teamSpaceCapNumberCheck = true : teamSpaceCapNumberCheck = false;
    (data.hasColumn("team1")) ? team1Check = true : team1Check = false;
    (data.hasColumn("Team1")) ? team1CapCheck = true : team1CapCheck = false;
    (data.hasColumn("Team 1")) ? team1SpaceNumberCapCheck = true : team1SpaceNumberCapCheck = false;
  
    if (teamCheck) {
      tempList = data.column("team");
      name = "team";
    } else if (teamNumberCheck) {
      tempList = data.column("teamNumber");
      name = "teamNumber";
    } else if (teamSpaceNumberCheck) {
      tempList = data.column("team number");
      name = "team number";
    } else if (teamCapCheck) {
      tempList = data.column("Team");
      name = "Team";
    } else if (teamSpaceCapNumberCheck) {
      tempList = data.column("Team Number");
      name = "Team Number";
    } else if (team1Check) {
      tempList = data.column("team1");
      name = "team1";
    } else if (team1CapCheck) {
      tempList = data.column("Team1");
      name = "Team1";
    } else if (team1SpaceNumberCapCheck) {
      tempList = data.column("Team 1");
      name = "Team 1";
    } else {
      throw ErrorSummary("No Valid Team Numbers in Data");
    }

    for (int i in sortTeams(tempList)) {
      temp.addEntries({MapEntry(i,DataFrame.fromNames(data.columns))});
    }  

    for (int index = 0; index < tempList.length; index++) {
      List<dynamic> rowTemp = [];
      
      data.row({name: tempList[index]}).forEach((key, value) {
        rowTemp.add(value);
      });

      temp[tempList[index]]?.addRow(rowTemp);
    }

    widget.library[widget.name] = temp;
  }

  @override
  Widget build(BuildContext context) {
    loadFromPath();

    return Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FilledButton( // File selection button
                  onPressed: uploadCSV, 
                  child: const Text('Upload a CSV')
                )
              ), 
              SizedBox(width: 8),
              Flexible(
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      widget.library[widget.name] = Map<int, DataFrame>;
                      setPath("");
                      refresh = !refresh;
                    });
                  },
                  child: const Text('Clear Data')
                )
              ), 
              SizedBox(width: 8),
              Text("Current Path: $currentPath")
            ],
          ),
          const SizedBox(height: 12),
          if (widget.library[widget.name] is! Map<int, DataFrame> || (widget.library[widget.name] as Map<int, DataFrame>).isEmpty)
            Text('No file uploaded') //TODO: change this if statement to also check for existing files in the pit/match directory
          else
            Expanded(
              child: SingleChildScrollView(
                key: ValueKey(refresh),
                child: Column(
                  children: [
                    for (MapEntry<int, DataFrame> entry in (widget.library[widget.name] as Map<int, DataFrame>).entries)
                      DataSheet(
                        dataMap: widget.library[widget.name][entry.key], //TODO: need a function to check for existing files and read from that
                        name: entry.key,
                      ),
                  ]
                ),
              ),
            )
        ],
      ),
    );
  }
}