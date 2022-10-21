import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../shared/constants.dart';
import '../widgets/category_item.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic'),
        centerTitle: true,
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: Provider.of<Categories>(context)
            .categories
            .map((e) => CategoryItem(e[0] as String, e[1] as IconData))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: (3 / 2),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
