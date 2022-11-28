
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Home'), centerTitle: true),
        body: SingleChildScrollView(
            child: Column(children: [
          //头部占位图
          InkWell(
            onTap: () {
              //跳转到一个页面
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return null;
              // }));
            },
            child: Container(
              margin: const EdgeInsets.only(left: 28, right: 28, top: 22),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(38, 45, 67, 1),
                  borderRadius: BorderRadius.circular(40)),
              height: 172,
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
          //最新资讯
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 14, left: 15),
            child: const Text(
              'Lastest Information',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  fontStyle: FontStyle.normal,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
          Container(
              height: 170,
              margin: const EdgeInsets.only(top: 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _infoItem('Lastest News'),
                  _infoItem('Maybe a longer Lastest News’ title'),
                  _infoItem('Lastest News'),
                  _infoItem('Maybe a longer Lastest News’ title'),
                  _infoItem('Lastest News'),
                ],
              )),
          //热门话题
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 18, left: 15),
            child: const Text(
              'Hit topics',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  fontStyle: FontStyle.normal,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
          Container(
            height: 800,
            margin: const EdgeInsets.only(top: 10),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: ((context, index) {
                  return _hitItem();
                })),
          )
        ])));
  }

  Widget _hitItem() {
    return GestureDetector(
        onTap: () {
         //jump to other page
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return const TextPage();
          // }));
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
                  children: const [
                    Text(
                      'user name',
                      style: TextStyle(
                          color: Color.fromRGBO(110, 127, 183, 1),
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '00dat age',
                      style: TextStyle(
                          color: Color.fromRGBO(116, 116, 116, 1),
                          fontSize: 8,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400),
                    ),
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
              Container(
                height: 27,
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
                          color: Color.fromRGBO(110, 127, 183, 1)),
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
                          color: Color.fromRGBO(110, 127, 183, 1)),
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
// jump to other page
  Widget _infoItem(String txt) {
    return GestureDetector(
      onTap: () {
        
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return null;
        // }));
      },
      child: Container(
        width: 160,
        height: 170,
        padding: const EdgeInsets.only(top: 20, left: 13),
        margin: const EdgeInsets.only(left: 15, right: 5),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(192, 103, 103, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          txt,
          style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
