// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use, unnecessary_this, unused_local_variable, annotate_overrides, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace, unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pens_apitabot/globals.dart' as globals;
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'dart:convert' show jsonDecode;
import 'package:pens_apitabot/class/Json.dart';

const List<String> list = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu'
];
var hari = list.first;
var jam = "";

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<TextEditingController> _data = [TextEditingController()];  
  TextEditingController timeinput = TextEditingController();
  Timer? timer;
  int _selectedIndex = 0;
  bool status = false;
  String kelembapan_udara = "";
  String kualitas_air = "";
  String ph_air = "";
  String suhu_air = "";

  late List<dynamic>? data = null;
  
  @override
  void initState() {
    super.initState();
    getEndpointFromStorage();
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getEndpointFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? endpoint = prefs.getString('endpoint');
    if(endpoint != null){
      setState(() {
        _data[0].text = endpoint;
        globals.endpoint = endpoint;
      });
    }
    else{
      _data[0].text = "0.0.0.0";
      globals.endpoint = "0.0.0.0";
    }
  }

  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/");  
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
      var respon = Json.tryDecode(response.body);
      if(respon != null){
        if (this.mounted) {
          setState(() {
            if (respon['jadwal_pakan_flutter'] != null &&
                respon['jadwal_pakan_flutter'] != "") {
              data = List<dynamic>.from((respon['jadwal_pakan_flutter']) as List);
            }
            if(respon['data_latest'] != null){
              kelembapan_udara = respon['data_latest']["kelembapan_udara"];
              kualitas_air = respon['data_latest']["kualitas_air"];
              ph_air = respon['data_latest']["ph_air"];
              suhu_air = respon['data_latest']["suhu_air"];
            }
          });
        }
      }
    }
    } on Exception catch (_) {}
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        timer?.cancel();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 44, 138),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: () => Phoenix.rebirth(context),
            // ),
            title: Text(
              "APITABOT",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.settings,
                      color: Colors.white, size: 20.0),
                  onPressed: () async {
                    Alert(
                    context: context,
                    // type: AlertType.info,
                    desc: "Setting API",
                    content: Column(
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.width / 15),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'IP Endpoint',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: _data[0],
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            if(_data[0].text.isEmpty){          
                              status = false;
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Value Cannot be Empty!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ).show();
                            }
                            else{
                              var url = Uri.parse('http://' + _data[0].text + '/index.php');
                              try{
                                  final response = await http.get(url).timeout(
                                  const Duration(seconds: globals.httpTimeout),
                                  onTimeout: () {
                                    // Time has run out, do what you wanted to do.
                                    return http.Response('Error', 408); // Request Timeout response status code
                                  },
                                );
                              // context.loaderOverlay.hide();
                                if (response.statusCode == 200) {
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Connection OK",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () async {
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          setState(() {
                                            globals.endpoint = _data[0].text;
                                            prefs.setString("endpoint", _data[0].text);
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      )
                                    ],
                                  ).show();
                                }
                                else{
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Connection Failed!",
                                    desc: "Please check Endpoint IP",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ).show();
                                }
                              } on Exception catch (_) {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Connection Failed!",
                                  desc: "Please check Endpoint IP",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ).show();
                                // rethrow;
                              }
                            }
                          }
                      ),
                    ],
                  ).show();

                  //================================ END ALERT UNTUK SETTING API ========================================
                  print(globals.endpoint);
                  }) 
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
          body: _selectedIndex == 0 ?
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: Home(context),
          )
          :
          Container(
            child: JadwalPakan(context),
          )
        ),
    );
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Widget Home(BuildContext context){
    TextStyle tstyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
    TextStyle tstyle2 = TextStyle(
      fontSize: 20,
      // fontWeight: FontWeight.w500,
    );
    return 
    Column(
      children: [    
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(style: tstyle, "Kelembapan Udara  "),
                Text(style: tstyle, "Kualitas Air (TDS)"),
                Text(style: tstyle, "PH Air"),
                Text(style: tstyle, "Suhu Air"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(style: tstyle2, "${kelembapan_udara} %"),
                Text(style: tstyle2, "${kualitas_air} ppm"),
                Text(style: tstyle2, "${ph_air}"),
                Text(style: tstyle2, "${suhu_air}"),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton(
            child: Text("Manual Pakan"),
            onPressed: () async{                                  
              var url = Uri.parse("http://${globals.endpoint}/");
              final response = await http.post(url, body: {'manual_trigger': '1', 'mode': 'pakan'});
              print(response.statusCode);
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton(
            child: Text("Manual Sprayer"),
            onPressed: () async{                                  
              var url = Uri.parse("http://${globals.endpoint}/");
              final response = await http.post(url, body: {'manual_trigger': '1', 'mode': 'sprayer'});
              print(response.statusCode);
            },
          ),
        ),
        
      ],
    );
  }


  Widget JadwalPakan(BuildContext context){
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 20.0), //SizedBox(height: 20.0),

            Container(
              height: 50.0,
              width: 300.0,
              child: ElevatedButton(
                child: new Text("Tambahkan Jadwal"),
                onPressed: () {
                  Alert(
                      context: context,
                      title: "Tambahkan Jadwal",
                      content: Column(
                        children: <Widget>[
                          DropdownButtonExample(),
                          TextField(
                            controller:
                                timeinput, //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(Icons.timer), //icon of text field
                                labelText: "Enter Time" //label text of field
                                ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );

                              if (pickedTime != null) {
                                print(
                                    pickedTime.format(context)); //output 10:51 PM
                                DateTime parsedTime = new DateFormat("hh:mm")
                                    .parse(pickedTime.format(context).toString());
                                // //converting to DateTime so that we can further format on different pattern.
                                // print(parsedTime); //output 1970-01-01 22:53:00.000
                                String formattedTime =
                                    DateFormat('HH:mm:ss').format(parsedTime);
                                // print(formattedTime); //output 14:59:00
                                // //DateFormat() is from intl package, you can format the time on any pattern you need.

                                setState(() {
                                  timeinput.text =
                                      formattedTime; //set the value of text field.
                                  jam = formattedTime;
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          )
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () async{
                            var url = Uri.parse("http://${globals.endpoint}/jadwal_pakan/create.php");
                            final response = await http.post(url, body: {'hari': hari, 'jam': jam});
                            print(hari);
                            print(jam);
                            print(response.statusCode);
                            // context.loaderOverlay.hide();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Tambahkan",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ]).show();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return AbsensiPage(id: 1);
                  // }));
                },
              ),
            ),

            Container(height: 20.0), //SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height - 230,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Stack(children: <Widget>[
                    Column(children: [
                      if(data != null) SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Hari'),
                            ),
                            // DataColumn(
                            //   label: Text('Name'),
                            // ),
                            // DataColumn(
                            //   label: Text('Pesan'),
                            // ),
                            DataColumn(
                              label: Text('Jam'),
                            ),
                            DataColumn(
                              label: Text('Aksi'),
                            ),
                          ],
                          rows: List.generate(data != null ? data!.length : 0, (index) {
                            final item = data![index];
                            return DataRow(
                              cells: [
                                DataCell(Text(item['hari'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(Text(item['jam'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(ElevatedButton(
                                    child: new Text("Hapus"), onPressed: () async{                                  
                                      var url = Uri.parse("http://${globals.endpoint}/jadwal_pakan/delete.php");
                                      final response = await http.post(url, body: {'id': item['id']});
                                    })),
                              ],
                            );
                          }),
                        ),
                      ),
                    ])
                  ])) ,
            )
          ],
        );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: globals.baseColor),
      underline: Container(
        height: 2,
        color: globals.baseColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          hari = dropdownValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}