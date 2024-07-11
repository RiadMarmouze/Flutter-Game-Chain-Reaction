import 'package:firebase_database/firebase_database.dart';
import 'package:chain_reaction/helpers/helper_function.dart';

class RoomService {
  late String? uid;

  RoomService({this.uid});

  void setUid(String newUid) {
    uid = newUid;
  }

  Future<void> createRoomInFirebase(Map<String, dynamic> roomMap, Function(String) setIdInRoom) async {
    // Initialize Firebase
    FirebaseDatabase database = FirebaseDatabase.instance;

    try {
      // Create a unique ID for the room
      String? roomId = await createRoomId(database);

      if (roomId != null) {
        roomMap["static"]["id"] = roomId;
        print(roomMap["static"]["id"]);

        // Create a reference to the new room
        DatabaseReference roomRef = database.ref().child('rooms').child(roomId);

        // Set the initial room data
        await roomRef.set(roomMap);

        // After ensuring room data is set successfully, update the UID and call setIdInRoom

        setUid(roomId);
        setIdInRoom(roomId);
        
        await HelperFunctions.saveUserJoinedStatus(true);
        await HelperFunctions.saveUserRoomIdSF(roomId);

        print('Room created successfully');
      }
    } catch (error) {
      print('Error creating room: $error');
      // Optionally, rethrow the error to handle it further up the call stack
      rethrow;
    }
  }

  Future<String?> createRoomId(FirebaseDatabase database) async {
    try {
      DatabaseReference newRoomRef = database.ref().child('rooms').push(); // Create a new room reference
      String roomId = newRoomRef.key ?? ""; // Get the room ID
      return roomId;
    } catch (error) {
      print('Error creating room ID: $error');
      return null;
    }
  }

  Future<void>? loadRoomFromFirebase(Function(Map<String, dynamic>) setRoomValues) {
    final DatabaseReference roomRef = FirebaseDatabase.instance.ref().child("rooms").child("$uid");
    Map<String, dynamic> snapshotValue = {};
    roomRef.once().then(
      (DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          snapshotValue = snapshot.value as Map<String, dynamic>;
        } else {
          print('Room data is null');
        }
      },
    ).catchError(
      (error) {
        print('Error loading room from database: $error');
      },
    );
    setRoomValues(snapshotValue);
    return null;
  }
}
