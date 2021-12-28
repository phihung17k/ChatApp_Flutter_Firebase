class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String photoURL;

  UserModel(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.photoURL});

  @override
  String toString() {
    return "displayName: $displayName\n"
        "email: $email\n"
        "photoURL: $photoURL\n";
  }
}
