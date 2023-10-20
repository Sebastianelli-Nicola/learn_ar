import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TrueFalseWidget extends StatelessWidget {
  const TrueFalseWidget({Key? key, required this.value, }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.transparent,
        height: 275.0,
        child: SvgPicture.asset(
          'assets/$value',
          height: 100.0,
          width: 100.0,
          allowDrawingOutsideViewBox: true,
        ),
    );
  }
}