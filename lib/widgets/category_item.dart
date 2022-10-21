import 'package:flutter/material.dart';

import '../shared/constants.dart';

// import '../screens/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  CategoryItem(this.title, this.icon);

  void selectCategory(BuildContext ctx) {
    // Navigator.of(ctx).pushNamed(routeName
    // , arguments: {
    //   'id': id,
    //   'title': title,
    // }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Icon(
                icon,
                color: Colors.white,
                size: 45,
              ),
            ),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  color: Constants.primaryTextColor,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Constants.primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
