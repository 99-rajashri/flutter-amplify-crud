import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/services.dart';
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(MyApp());
}

Future<void> configureAmplify() async {
  try {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    await Amplify.addPlugins([datastorePlugin, api, AmplifyAPI()]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print("Error configuring Amplify: $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController playerNameController = TextEditingController();
  final TextEditingController parentMobileController = TextEditingController();
  // final List<AddPlayer> playerDataList = [];
  late StreamSubscription _subscription;
  bool _isSynced = false;
  Stream<QuerySnapshot<AddPlayer>>? _stream;
  List<AddPlayer> _playerDataList = [];

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 10), (timer) {
    fetchPlayerData();
    // });
    _stream = observeQuery();
  }

  Stream<QuerySnapshot<AddPlayer>> observeQuery() {
    return Amplify.DataStore.observeQuery(
      AddPlayer.classType,
      // where: AddPlayer.NAME.beginsWith('post'),
      sortBy: [AddPlayer.NAME.ascending()],
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> fetchPlayerData() async {
    try {
      final posts = await Amplify.DataStore.query(AddPlayer.classType);
      setState(() {
        _playerDataList = posts;
        _stream = observeQuery();
      });
    } catch (e) {
      print('Query failed: $e');
    }
  }

  Future<void> createAddPlayer() async {
    try {
      final model = AddPlayer(
        name: playerNameController.text,
        mobNo: parentMobileController.text,
        gender: "Female",
      );
      await Amplify.DataStore.save(model);
      fetchPlayerData();
      _stream = observeQuery();

      playerNameController.text = "";
      parentMobileController.text = "";
    } catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<void> deleteAddPlayer(AddPlayer modelToDelete) async {
    try {
      await Amplify.DataStore.delete(modelToDelete);
    } catch (e) {
      print('Delete failed: $e');
    }
  }

  Future<void> updatePlayer(String id, String newName, String newGender,
      String newMobileNumber) async {
    try {
      final playerToUpdate = AddPlayer(
        id: id,
        name: newName,
        gender: newGender,
        mobNo: newMobileNumber,
      );
      await Amplify.DataStore.save(playerToUpdate);
      fetchPlayerData();
    } catch (e) {
      print('Update failed: $e');
    }
  }

  void _showEditDialog(BuildContext context, AddPlayer player) {
    TextEditingController nameController =
        TextEditingController(text: player.name);
    TextEditingController genderController =
        TextEditingController(text: player.gender);
    TextEditingController mobileNumberController =
        TextEditingController(text: player.mobNo);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Player Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Player Name'),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                    "Gender: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 60,
                    child: Radio(
                      value: 'Male',
                      groupValue: genderController.text,
                      onChanged: (value) {
                        setState(() {
                          genderController.text = value!;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 60,
                    child: Radio(
                      value: 'Female',
                      groupValue: genderController.text,
                      onChanged: (value) {
                        setState(() {
                          genderController.text = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: mobileNumberController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 14),
                cursorColor: Colors.yellow[600],
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(
                    RegExp("[0-9]"),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Enter Mobile No',
                  prefixIcon: Icon(Icons.call),
                  suffixIcon: Icon(Icons.contact_phone),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updatePlayer(player.id, nameController.text,
                    genderController.text, mobileNumberController.text);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Player List'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Input form for adding a new player
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: TextFormField(
                        controller: playerNameController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]")),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Player Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Text(
                          "Gender: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Text("Male"),
                            Container(
                              height: 50,
                              width: 60,
                              child: Radio(
                                value: 'Male',
                                groupValue: "gender",
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Female"),
                            Container(
                              height: 50,
                              width: 60,
                              child: Radio(
                                value: 'Female',
                                groupValue: "gender",
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      child: TextFormField(
                        controller: parentMobileController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        cursorColor: Colors.yellow[600],
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call),
                          suffixIcon: Icon(Icons.contact_phone),
                          isDense: true,
                          border: OutlineInputBorder(),
                          labelText: 'Enter Mobile No',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: createAddPlayer,
                      child: Text("Add Player"),
                    ),
                  ],
                ),
              ),

              StreamBuilder<QuerySnapshot<AddPlayer>>(
                stream: _stream,
                builder: (context, snapshot) {
                  print("Snapashot : $snapshot");
                  if (snapshot.hasData) {
                    print("Snapashot data : ${snapshot.data!.items}");
                    final playerDataList = snapshot.data?.items ?? [];
                    return Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: playerDataList.length,
                        itemBuilder: (context, index) {
                          final player = playerDataList[index];
                          return ListTile(
                            title: Text("Name: ${player.name ?? ''}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mob No: ${player.mobNo ?? ''}"),
                                Text("Gender: ${player.gender ?? ''}")
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, player);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteAddPlayer(player);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // Display a loading indicator while fetching data.
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
