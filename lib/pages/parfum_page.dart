import 'package:flutter/material.dart';

import 'package:flutter_intenso/components/app_bar.dart';
import 'package:flutter_intenso/database/database_helper.dart';
import '../model/parfum.dart';

class ParfumPage extends StatefulWidget {
  final int? id;

  const ParfumPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ParfumPage> createState() => _ParfumPageState();
}

class _ParfumPageState extends State<ParfumPage> {
  Future<Parfum?>? _parfum;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _parfum = DatabaseHelper.instance.readId(widget.id!);
      // _parfum = Future.delayed(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IntensoDefaultAppBar(
        textWidget: _title,
      ),
      body: _page,
    );
  }

  Widget get _title {
    return FutureBuilder(
        future: _parfum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Загрузка');
          }
          if (snapshot.hasError) {
            return const Text('Ошибка');
          }
          if (snapshot.data == null) {
            return const Text('Не найдено');
          }
          return Text(snapshot.data!.title);
        });
  }

  Widget get _page {
    return FutureBuilder(
        future: _parfum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _getPageLoading();
          }
          if (snapshot.hasError) {
            return _getPageError();
          }
          if (snapshot.data == null) {
            return _getPageNotFound();
          }
          return _getPageParfum(snapshot.data!);
        });
  }

  Widget _getPageLoading() {
    return Center(
      child: Transform.scale(
        scale: 1.35,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _getPageError() {
    return const Center(
      child: Flexible(
        child: Text(
          'Произошла непредвиденная ошибка :(',
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getPageNotFound() {
    return const Center(
      child: Flexible(
        child: Text(
          'Данной позиции не удалось найти!',
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getPageParfum(Parfum parfum) {
    return Center(
      child: Flexible(
        child: Text('${parfum.title}\n'
            '${parfum.id}\n'
            '${parfum.price}\n'
            '${parfum.type}\n'
            '${parfum.urlImage}\n'
            '${parfum.article}\n'
            '${parfum.url}'),
      ),
    );
  }
}
