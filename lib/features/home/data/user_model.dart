class UserModel {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final int id;
  final int age;
  final String mobileNumber;
  final String gender;

  const UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.age,
    required this.gender,
  });
  toJson() {
    return {
      "first name": firstname,
      "last name": lastname,
      "id": id,
      "age": age,
      "gender": gender,
      "mobile number": mobileNumber,
      "email": email,
      "password": password,
    };
  }
}
