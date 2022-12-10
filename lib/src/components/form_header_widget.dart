import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  String image, tittle, subtittle;
  TextStyle? textStyleTittle, textStyleSubTittle;

  FormHeaderWidget(
      {Key? key,
      required this.image,
      required this.tittle,
      required this.subtittle,
      this.textStyleTittle,
      this.textStyleSubTittle})
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
          style: textStyleTittle ?? Theme.of(context).textTheme.headline4,
        ),
        Text(
          subtittle,
          style: textStyleSubTittle ?? Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
