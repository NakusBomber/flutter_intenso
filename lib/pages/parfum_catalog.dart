import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import 'package:flutter_intenso/pages/parfum_page.dart';
import 'package:flutter_intenso/components/parfum_image.dart';
import 'package:flutter_intenso/utils/animations.dart';
import 'package:flutter_intenso/utils/navigation.dart';
import 'package:flutter_intenso/database/database_helper.dart';
import 'package:flutter_intenso/model/parfum.dart';

class ParfumCatalog extends StatefulWidget {
  const ParfumCatalog({super.key});

  @override
  State<ParfumCatalog> createState() => _ParfumCatalogState();
}

class _ParfumCatalogState extends State<ParfumCatalog> {
  final ScrollController _scrollController = ScrollController();
  final countParfumOnPage = 12;

  Set<ParfumTypes> _filters = ParfumTypes.values.toSet();

  bool _isSearch = false;
  String _searchQuery = '';
  SortingTypes _sortType = SortingTypes.popular;
  int _pageNumber = 0;
  int? _offset;

  int _getCountPage(int countEntry) => (countEntry / countParfumOnPage).ceil();

  void _scrollToAnchor() {
    _scrollController.animateTo(0,
        duration: animationScrollToAnchorDuration, curve: Curves.ease);
  }

  void _resetPageNumber() {
    setState(() {
      _pageNumber = 0;
      _offset = _pageNumber * countParfumOnPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _getAppBar(context),
          _getTopButtons(context),
          _getTotalText(),
          _getListParfums(),
          _getPagesNumber()
        ],
      ),
    );
  }

  SliverToBoxAdapter _getPagesNumber() {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: DatabaseHelper.instance
            .getCountEntry(filters: _filters, searchQuery: _searchQuery),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done && data != 0) {
            return NumberPaginator(
              config: NumberPaginatorUIConfig(
                  buttonSelectedBackgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.7)),
              initialPage: _pageNumber,
              numberPages: _getCountPage(data),
              onPageChange: (index) {
                if (index != _pageNumber) {
                  setState(() {
                    _pageNumber = index;
                    _offset = _pageNumber * countParfumOnPage;
                  });
                }
                _scrollToAnchor();
              },
            );
          }
          return const Spacer();
        },
      ),
    );
  }

  SliverAppBar _getAppBar(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        pinned: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _isSearch
            ? TextField(
                onChanged: (query) {
                  setState(() {
                    _resetPageNumber();
                    _searchQuery = query;
                  });
                },
                autofocus: true,
                style: const TextStyle(
                    color: Colors.white, decorationThickness: 0),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: 'Пример: Mango skin',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4))),
              )
            : const Text(
                'Каталог',
                style: TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        actions: [
          _isSearch
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearch = false;
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
        ]);
  }

  SliverList _getTopButtons(BuildContext context) {
    return SliverList.list(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Expanded(
                  child: FilledButton.icon(
                icon: Icon(_filters.length < 3
                    ? Icons.filter_alt
                    : Icons.filter_alt_off),
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
        ),
      ],
    );
  }

  SliverList _getTotalText() {
    return SliverList.list(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              builder: (context, snapshot) => Flexible(
                child: Text('Всего позиций: ${snapshot.data ?? 0}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ),
              future: DatabaseHelper.instance
                  .getCountEntry(filters: _filters, searchQuery: _searchQuery),
            ),
          ],
        ),
      ],
    );
  }

  Card _getCardParfum(BuildContext context, Parfum parfum) {
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
                        child: parfumImage(parfum.urlImage),
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
                          Flexible(
                            child: Text(
                              parfum.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                parfum.type,
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
                                '${parfum.price.toInt()} ₴',
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

  Widget _getListParfums() {
    return FutureBuilder<List<Parfum>>(
        future: DatabaseHelper.instance.readWithOptions(
            filters: _filters,
            sortType: _sortType,
            searchQuery: _searchQuery,
            limit: countParfumOnPage,
            offset: _offset),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return SliverFillRemaining(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return _getNotFindParfum();
          }
          return SliverList.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final parfum = data[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(getPageRouteBuilder(ParfumPage(
                    id: parfum.id,
                  )));
                },
                child: _getCardParfum(context, parfum),
              );
            },
          );
        });
  }

  SliverFillRemaining _getNotFindParfum() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Не найдено духов. Возможно, неверно указаны фильтры или поиск!',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          FilledButton(
              onPressed: () {
                setState(() {
                  _isSearch = false;
                  _searchQuery = '';
                  _filters = ParfumTypes.values.toSet();
                });
              },
              child: const Text('Показать всё'))
        ],
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
                                selected: _filters.contains(type),
                                onSelected: (bool selected) {
                                  setState(() {
                                    _setState(() {
                                      if (selected) {
                                        _filters.add(type);
                                      } else {
                                        _filters.remove(type);
                                      }
                                      _resetPageNumber();
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
                                  _sortType = type;
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
