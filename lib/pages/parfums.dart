import 'package:flutter/material.dart';
import 'package:flutter_intenso/components/app_bar.dart';
import 'package:flutter_intenso/database/database_helper.dart';
import 'package:flutter_intenso/model/parfum.dart';
import 'package:flutter_svg/svg.dart';

class ParfumPage extends StatefulWidget {
  const ParfumPage({super.key});

  @override
  State<ParfumPage> createState() => _ParfumPageState();
}

class _ParfumPageState extends State<ParfumPage> {
  Card _getCardParfum(BuildContext context, List<Parfum> data, int index) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.network(
                          data[index].urlImage,
                          width: 70,
                          height: 70,
                          loadingBuilder: (context, w, chunk) {
                            if (chunk == null) {
                              return w;
                            }
                            return const CircularProgressIndicator();
                          },
                          errorBuilder: (context, obj, trace) {
                            return SizedBox(
                              width: 70,
                              height: 70,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/parfum_none.svg',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(data[index].title, style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(data[index].type, style: const TextStyle(
                                color: Colors.white,
                              ),),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text('${data[index].price.toInt()} ₴', style: const TextStyle(
                                color: Colors.white,
                              ),),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IntensoAppBar(titleText: "Духи"),
      body: Center(
        child: FutureBuilder<List<Parfum>>(
          future: DatabaseHelper.instance.readAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final data = snapshot.data;
            if (data == null || data.isEmpty) {
              return const Text('Не найдено ни одних духов!');
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _getCardParfum(context, data, index);
              },
            );
          },
        ),
      ),
    );
  }
}
