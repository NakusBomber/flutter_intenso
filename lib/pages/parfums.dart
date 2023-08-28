import 'package:flutter/material.dart';
import 'package:flutter_intenso/components/app_bar.dart';
import 'package:flutter_intenso/database/database_helper.dart';
import 'package:flutter_intenso/model/parfum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ParfumPage extends StatefulWidget {
  const ParfumPage({super.key});

  @override
  State<ParfumPage> createState() => _ParfumPageState();
}

class _ParfumPageState extends State<ParfumPage> {

  @override
  void initState() {
    super.initState();
    // DatabaseHelper.instance.create(const Parfum(
    //     article: '2323232',
    //     urlImage: 's',
    //     title: 'test',
    //     type: 'Женские',
    //     price: 341.0,
    //     url: 'a')
    // );
  }

  @override
  void dispose() {
    super.dispose();
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
              return const Text('No data found.');
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].title),
                  subtitle: Text('Price: ${data[index].price}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
