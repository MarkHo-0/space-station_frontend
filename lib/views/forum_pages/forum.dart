import 'package:demo_page/page3.dart';
import 'package:demo_page/test.dart';
import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  int leftFlex = 4;
  int rightFlex = 2;

  bool leftSelect = true;
  bool rightSelect = false;

  String popValue = 'Course';

  @override
  void initState() {
    super.initState();
  }

  OverlayEntry? weixinOverlayEntry;

  void _popWindows() {
    weixinOverlayEntry = OverlayEntry(builder: ((context) {
      return Positioned(
          top: 80,
          right: 40,
          width: 240,
          child: SafeArea(
              child: Material(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(188, 188, 188, 1))),
              child: Column(
                children: <Widget>[
                  _expandedItem('- -', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = '- -';
                    });
                  }),
                  _expandedItem('Art & Humanities', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'Art & Humanities';
                    });
                  }),
                  _expandedItem('Economic & Buisness', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'Economic & Buisness';
                    });
                  }),
                  _expandedItem('Engineering & Technology', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'Engineering & Technology';
                    });
                  }),
                  _expandedItem('English', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'English';
                    });
                  }),
                  _expandedItem('Mathematic & Science', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'Mathematic & Science';
                    });
                  }),
                  _expandedItem('Social Science', () {
                    setState(() {
                      weixinOverlayEntry?.remove();
                      popValue = 'Social Science';
                    });
                  }),
                ],
              ),
            ),
          )));
    }));
    Overlay.of(context)?.insert(weixinOverlayEntry!);
  }

  Widget _hitItem() {
    return GestureDetector(
        onTap: () {
          //jump to other page
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Page3();
          }));
        },
        child: Container(
          height: 110,
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color.fromRGBO(188, 188, 188, 1), width: 1))),
          padding: const EdgeInsets.only(left: 13),
          child: Column(
            children: [
              //username   day
              Container(
                height: 24,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text(
                      'user name',
                      style: TextStyle(
                          color: Color.fromRGBO(110, 127, 183, 1),
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      '0000/00/00 00:00',
                      style: TextStyle(
                          color: Color.fromRGBO(116, 116, 116, 1),
                          fontSize: 8,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    ),
                    !rightSelect
                        ? const SizedBox()
                        : Expanded(
                            child: Container(
                                padding:
                                    const EdgeInsets.only(right: 11, top: 11),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Image.asset(
                                        'assets/ok.png',
                                        width: 10,
                                        height: 11,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text(
                                      'done',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(110, 127, 183, 1)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )))
                  ],
                ),
              ),
              //title
              Container(
                height: 55,
                alignment: Alignment.topLeft,
                child: const Text(
                  'Title',
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Color.fromRGBO(0, 0, 0, 1)),
                ),
              ),
              // menus
              SizedBox(
                height: 27,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Subject',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(116, 116, 116, 1)),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      'assets/up.png',
                      width: 10,
                      height: 11,
                    ),
                    const Text(
                      '100',
                      style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(110, 127, 183, 1)),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Image.asset(
                      'assets/down.png',
                      width: 10,
                      height: 11,
                    ),
                    const Text(
                      '100',
                      style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(110, 127, 183, 1)),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Image.asset(
                      'assets/msg.png',
                      width: 10,
                      height: 11,
                    ),
                    const Text(
                      '100',
                      style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(110, 127, 183, 1)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _expandedItem(String title, GestureTapCallback callback) =>
      GestureDetector(
        onTap: callback,
        child: Expanded(
          child: ListTile(
              title: Container(
            padding: const EdgeInsets.only(bottom: 14),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromRGBO(188, 188, 188, 1)))),
            child: Text(
              title,
              style: const TextStyle(
                  color: Color.fromRGBO(123, 123, 123, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          //search
          SizedBox(
            height: 35,
            child: Row(
              children: [
                const SizedBox(
                  width: 72,
                ),
                Container(
                  height: 35,
                  width: 258,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(227, 227, 227, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search,
                        size: 12,
                      ),
                      Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(109, 109, 109, 1)),
                      )
                    ],
                  ),
                ),
                //choose
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/screen_icon.png',
                    width: 22,
                    height: 22,
                  ),
                ))
              ],
            ),
          ),
          //tab
          Container(
            margin: const EdgeInsets.only(top: 14),
            height: 45,
            child: Row(
              children: [
                Expanded(
                    flex: leftFlex,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          leftFlex = 4;
                          rightFlex = 2;
                          leftSelect = true;
                          rightSelect = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                            border: !leftSelect
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromRGBO(110, 127, 183, 0.2)))
                                : const Border(
                                    bottom: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromRGBO(110, 127, 183, 1)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '吹水台',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(98, 98, 98, 1)),
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: rightFlex,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          leftFlex = 2;
                          rightFlex = 4;
                          leftSelect = false;
                          rightSelect = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                            border: !rightSelect
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromRGBO(110, 127, 183, 0.2)))
                                : const Border(
                                    bottom: BorderSide(
                                        width: 3,
                                        color:
                                            Color.fromRGBO(110, 127, 183, 1)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '學術台',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(98, 98, 98, 1)),
                            ),
                            !rightSelect
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      _popWindows();
                                    },
                                    child: Container(
                                        height: 15,
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 8,
                                        ),
                                        margin: const EdgeInsets.only(
                                            left: 12, top: 4),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                239, 239, 239, 1),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Row(
                                          children: [
                                            Text(
                                              popValue,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color.fromRGBO(
                                                      166, 166, 166, 1)),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              size: 12,
                                            )
                                          ],
                                        )),
                                  )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
          //list
          Expanded(
            child: ListView.builder(
                itemCount: 15,
                itemBuilder: ((context, index) {
                  return _hitItem();
                })),
          )
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Setting Page"),
      ),
    );
  }
}
