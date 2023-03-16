import 'package:cosmetic_survey/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../core/firebase/firestore/current_user_details.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  CurrentUserDetails currentUserDetails = CurrentUserDetails();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: cosmeticPrimaryColor,
          elevation: 2,
          title: Text(
            '${currentUserDetails.getTimeDay()}, ${currentUserDetails.getUserFirstName()}!',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
