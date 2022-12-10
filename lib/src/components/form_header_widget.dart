import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  String image, tittle, subtittle;

  FormHeaderWidget(
      {Key? key,
      required this.image,
      required this.tittle,
      required this.subtittle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Image(
          image: AssetImage(image),
          height: deviceSize.height * 0.4,
        ),
        Text(
          tittle,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          subtittle,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
