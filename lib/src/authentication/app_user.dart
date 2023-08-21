class AppUser {
  AppUser({
    required this.anonymous,
    this.uid,
    this.email,
    this.password,
  });

  bool? anonymous;
  String? uid;
  String? email;
  String? password;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
        uid: json['uid'],
        email: json['email'],
        password: json['password'],
        anonymous: json['anonymous']);
  }
}
