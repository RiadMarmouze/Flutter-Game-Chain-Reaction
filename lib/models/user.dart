class User {
  String email;
  String id;
  String username;

  User({required this.email, required this.id, required this.username});

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'username': username,
    };
  }

  // Method to create a User object from a Map
  static User fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      id: map['id'],
      username: map['username'],
    );
  }
}