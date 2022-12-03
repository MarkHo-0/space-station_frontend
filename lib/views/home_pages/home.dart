import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //歡迎組件
          const WellcomeWidget(),
          //最新資訊
          TitledContainer(
            title: 'latest_info'.i18n(),
            body: SizedBox(
              height: 170,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 15),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return _infoItem('Info $index');
                },
                separatorBuilder: (_, __) {
                  return const SizedBox(width: 10);
                },
              ),
            ),
          ),
          //熱門
          TitledContainer(
            title: 'hit_topics'.i18n(),
            body: Column(
              children: List.generate(5, (index) => _hitItem()),
            ),
          )
        ],
      ),
    );
  }

  Widget _hitItem() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color.fromRGBO(188, 188, 188, 1), width: 1),
              ),
            ),
            padding: const EdgeInsets.only(left: 13),
            child: Column(
              children: [
                //username   day
                Container(
                  height: 24,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Text(
                        'user name',
                        style: TextStyle(
                          color: Color.fromRGBO(110, 127, 183, 1),
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '1 day age',
                        style: TextStyle(
                          color: Color.fromRGBO(116, 116, 116, 1),
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                //title
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(bottom: 15),
                  child: const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
                // menus
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/up.png',
                        width: 10,
                        height: 11,
                      ),
                      const Text(
                        '100',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(110, 127, 183, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Image.asset(
                        'assets/images/down.png',
                        width: 10,
                        height: 11,
                      ),
                      const Text(
                        '100',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(110, 127, 183, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Image.asset(
                        'assets/images/msg.png',
                        width: 10,
                        height: 11,
                      ),
                      const Text(
                        '100',
                        style: TextStyle(fontSize: 10, fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, color: Color.fromRGBO(110, 127, 183, 1)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

// jump to other page
  Widget _infoItem(String txt) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      color: const Color.fromRGBO(192, 103, 103, 1),
      child: Ink(
        width: 150,
        height: 170,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              txt,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitledContainer extends StatelessWidget {
  final String title;
  final Widget body;
  const TitledContainer({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        body,
        const SizedBox(height: 10),
      ],
    );
  }
}

class WellcomeWidget extends StatelessWidget {
  const WellcomeWidget({super.key});

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
                const Positioned(
                    top: 100,
                    left: 25,
                    child: Text(
                      'user name',
                      style: TextStyle(
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
