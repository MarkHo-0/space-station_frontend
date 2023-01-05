// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:space_station/models/user.dart';

class WellcomeBox extends StatelessWidget {
  final User data;
  const WellcomeBox(this.data, {Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        color: const Color.fromRGBO(38, 45, 67, 1),
        child: Ink(
          height: 172,
          child: InkWell(
            onTap: () => {},
            child: Stack(
              children: [
                Positioned(
                    top: 100,
                    left: 25,
                    child: Text(
                      data.nickname,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(192, 206, 255, 1),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                      ),
                    )),
                Positioned(
                  top: 60,
                  left: 25,
                  child: Image.asset(
                    'assets/images/welcome.png',
                    width: 131,
                    height: 44,
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 0,
                  child: Image.asset(
                    'assets/images/people.png',
                    width: 150,
                    height: 159,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
