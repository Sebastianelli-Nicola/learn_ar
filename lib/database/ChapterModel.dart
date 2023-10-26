import 'dart:typed_data';

class Chapter{

  late final String id;
  late final String name;


  // create constructor
  Chapter({
    required this.id,
    required this.name,
  });

  @override
  String toString(){
    return 'Question(id: $id, title: $name,)';
  }

}