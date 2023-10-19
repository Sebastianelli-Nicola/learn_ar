import 'dart:typed_data';

class Question{

  late final String id;
  late final String title;
  late final Map<String, bool> options;
  late final String model3dName;
  //3D model
  //late final Uint8List model3d;


  // create constructor
  Question({
    required this.id,
    required this.title,
    required this.options,
    required this.model3dName
    //required this.model3d,
  });

  @override
  String toString(){
    return 'Question(id: $id, title: $title, options: $options)';
  }

}