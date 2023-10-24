import 'dart:typed_data';

class Info{

  late final String id;
  late final String name;


  // create constructor
  Info({
    required this.id,
    required this.name,
  });

  @override
  String toString(){
    return 'Question(id: $id, title: $name,)';
  }

}