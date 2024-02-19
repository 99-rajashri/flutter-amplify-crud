import 'package:flutter/material.dart';

class PlayerData {
  String id;
  String name;
  String gender;
  String mobileNumber;

  PlayerData({
    required this.id,
    required this.name,
    required this.gender,
    required this.mobileNumber,
  });
}

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  List<PlayerData> playerDataList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isEditing = false;
  int editingIndex = -1;

  void addPlayer() {
    final name = nameController.text;
    final gender = genderController.text;
    final mobileNumber = mobileNumberController.text;

    if (name.isNotEmpty && gender.isNotEmpty && mobileNumber.isNotEmpty) {
      setState(() {
        playerDataList.add(PlayerData(
          id: DateTime.now().toString(),
          name: name,
          gender: gender,
          mobileNumber: mobileNumber,
        ));
        nameController.clear();
        genderController.clear();
        mobileNumberController.clear();
      });
    }
  }

  void updatePlayer(PlayerData updatedPlayer) {
    setState(() {
      playerDataList[editingIndex] = updatedPlayer;
      isEditing = false;
      editingIndex = -1;
      nameController.clear();
      genderController.clear();
      mobileNumberController.clear();
    });
  }

  void editPlayer(PlayerData player) {
    setState(() {
      isEditing = true;
      editingIndex = playerDataList.indexOf(player);
      nameController.text = player.name;
      genderController.text = player.gender;
      mobileNumberController.text = player.mobileNumber;
    });
  }

  void deletePlayer(PlayerData player) {
    setState(() {
      playerDataList.remove(player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
          ),
          ElevatedButton(
            onPressed: isEditing
                ? () => updatePlayer(PlayerData(
                      id: playerDataList[editingIndex].id,
                      name: nameController.text,
                      gender: genderController.text,
                      mobileNumber: mobileNumberController.text,
                    ))
                : addPlayer,
            child: Text(isEditing ? 'Update Player' : 'Add Player'),
          ),
          SizedBox(height: 20),
          Text('Player List', style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: playerDataList.length,
              itemBuilder: (context, index) {
                final player = playerDataList[index];
                return ListTile(
                  title: Text('Name: ${player.name}'),
                  subtitle: Text(
                      'Gender: ${player.gender}\nMobile: ${player.mobileNumber}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editPlayer(player),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deletePlayer(player),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
