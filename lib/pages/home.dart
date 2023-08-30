import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_intenso/components/app_bar.dart';
import 'package:flutter_intenso/pages/parfums.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _textComment =
      'Ваш мир поделится на "ДО" и \n"ПОСЛЕ" с INTENSO PARFUM!';

  Column _getLogo() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'INTENSO',
              style: TextStyle(
                  fontFamily: "BlackerSans",
                  fontWeight: FontWeight.w700,
                  fontSize: 60),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PARFUM',
              style: TextStyle(
                  fontFamily: 'BlackerSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            )
          ],
        )
      ],
    );
  }

  Divider _getDivider() {
    return const Divider(
      height: 30,
      indent: 20,
      endIndent: 20,
      color: Colors.black,
      thickness: 2,
    );
  }

  Widget _getAnimDivider() {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 400, end: 0),
        duration: const Duration(seconds: 1, milliseconds: 500),
        builder: (BuildContext context, double value, Widget? child) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: value),
              child: _getDivider());
        });
  }

  Column _getAbout(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'О нас',
              style: TextStyle(fontSize: 22),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(
                            text: 'INTENSO PARFUM',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const TextSpan(
                            text:
                                ' - это успешная, быстрорастущая компания, которая занимается производством и продажей аналоговой парфюмерии на разлив. Была создана в ноябре 2021 года в г. Днепр. Все наши ароматы производятся на масляной основе('),
                        TextSpan(
                            text:
                                '50% содержания масел DeLux качества в составе духов',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        const TextSpan(text: '), что обеспечивает '),
                        TextSpan(
                            text:
                                'невероятный шлейф и высокую стойкость - более 72 часов',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        const TextSpan(text: '! Ароматы очень стойкие!')
                      ]),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getComment() {
    return TweenAnimationBuilder(
        tween: IntTween(begin: 0, end: _textComment.length),
        duration: const Duration(seconds: 3),
        builder: (BuildContext context, int value, Widget? child) {
          int length = value;
          return Text(_textComment.substring(0, length));
        });
  }

  Container _getContainerComment() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CircleAvatar(
            radius: 40,
            child: ClipOval(
              child: Image.asset(
                'assets/image/alex.jpeg',
              ),
            ),
          ),
          Column(
            children: [
              const Row(
                children: [
                  Text(
                    'Александр Добныч',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [Text(_textComment)],
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget _getButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ParfumPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.fastOutSlowIn;

                  var tween = Tween(begin: begin, end: end);
                  var curvedAnimation =
                      CurvedAnimation(parent: animation, curve: curve);

                  return SlideTransition(
                    position: tween.animate(curvedAnimation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500)));
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    'Духи',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Icon(Icons.navigate_next,)
              ],
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          _getLogo(),
          _getAnimDivider(),
          _getAbout(context),
          _getContainerComment(),
          const Spacer(),
          _getButton(context)
        ],
      ),
    ));
  }

}
