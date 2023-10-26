import 'dart:typed_data';

class Statistic{

  late final String id;
  late final String email;
  late final Map<String, int> stats;
  //3D model
  //late final Uint8List model3d;


  // create constructor
  Statistic({
    required this.id,
    required this.email,
    required this.stats,
    //required this.model3d,
  });

  @override
  String toString(){
    return 'Statistics(id: $id, email: $email, stats: $stats)';
  }

}