import 'dart:typed_data';

class Chapter{

  late final String id;
  late final String name;

  late final bool? isLock;


  // create constructor
  Chapter({
    required this.id,
    required this.name,
    this.isLock,
  });

  @override
  String toString(){
    return 'Question(id: $id, title: $name,)';
  }

}