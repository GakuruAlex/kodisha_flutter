class User {
  const User({
    this.id,
    this.firstname,
    this.lastname,
    this.emailAddress,
    this.phonenumber,
  });
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? emailAddress;
  final String? phonenumber;

  User copywith(
    String? firstname,
    int? id,

    String? lastname,
    String? emailAddress,
    String? phonenumber,
  ) {
    return User(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      emailAddress: emailAddress ?? this.lastname,
      phonenumber: phonenumber ?? this.phonenumber,
      id: id ?? this.id,
    );
  }

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      firstname: user['firstname'],
      lastname: user['lastname'],
      emailAddress: user['email_address'],
      phonenumber: user['phonenumber'],
      id: user["id"],
    );
  }
}
