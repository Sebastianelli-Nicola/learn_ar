import 'dart:typed_data';

class UserModel{

  late final String id;
  late final String email;
  late final String name;
  late final String surname;
  late final String birthDate;
  //3D model
  //late final Uint8List model3d;


  // create constructor
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthDate,
    //required this.model3d,
  });

  @override
  String toString(){
    return 'User(id: $id, email: $email, name: $name, surname: $surname, birthdate: $birthDate)';
  }

}