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
  Set<ParfumTypes> filters = <ParfumTypes>{
    ParfumTypes.unisex,
    ParfumTypes.man,
    ParfumTypes.woman
  };

  SortingTypes sortType = SortingTypes.popular;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IntensoAppBar(titleText: "Каталог"),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            _getTopButtons(context),
            _getExpandedListParfums(),
          ],
        ),
      ),
    );
  }

  Row _getTopButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Expanded(
              child: FilledButton.icon(
            icon: Icon(
                filters.length < 3 ? Icons.filter_alt : Icons.filter_alt_off),
            label: const Text('Фильтр'),
            onPressed: () {
              _getModalFilters(context);
            },
          )),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Expanded(
              child: FilledButton.icon(
            icon: const Icon(Icons.sort),
            label: const Text('Сортировка'),
            onPressed: () {
              _getModalSorting(context);
            },
          )),
        ),
      ],
    );
  }

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
                          Text(
                            data[index].title,
                            style: const TextStyle(
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
                              Text(
                                data[index].type,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                '${data[index].price.toInt()} ₴',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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

  Expanded _getExpandedListParfums() {
    return Expanded(
      flex: 11,
      child: FutureBuilder<List<Parfum>>(
        future:
            DatabaseHelper.instance.readSortedFromFilters(filters, sortType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(
                child: Text(
              'Не найдено духов.\nВозможно, неверно указаны фильтры!',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _getCardParfum(context, data, index);
            },
          );
        },
      ),
    );
  }

  Future<dynamic> _getModalFilters(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) _setState) {
                return SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Показать духи:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                          spacing: 6,
                          children: ParfumTypes.values.map((ParfumTypes type) {
                            return FilterChip(
                                label: Text(type.name),
                                selected: filters.contains(type),
                                onSelected: (bool selected) {
                                  setState(() {
                                    _setState(() {
                                      if (selected) {
                                        filters.add(type);
                                      } else {
                                        filters.remove(type);
                                      }
                                    });
                                  });
                                });
                          }).toList())
                    ],
                  ),
                );
              },
            ));
  }

  Future<dynamic> _getModalSorting(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) _setState) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Отсортировать по:',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Flex(
                          direction: Axis.vertical,
                          children:
                              SortingTypes.values.map((SortingTypes type) {
                                return ChoiceChip(
                                  showCheckmark: false,
                                  label: Text(type.name),
                                  selected: true,
                                  onSelected: (bool _) {
                                    setState(() {
                                      sortType = type;
                                    });
                                  },
                            );
                          }).toList())
                    ],
                  ),
                );
              },
            ));
  }
}
