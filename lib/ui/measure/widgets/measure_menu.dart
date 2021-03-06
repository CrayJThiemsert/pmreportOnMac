import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmreport/blocs/blocs.dart';
import 'package:pmreport/ui/measure/widgets/categories_menu.dart';
import 'package:pmreport/ui/home/widgets/loading_indicator.dart';
import 'package:pmreport/utils/sizes_helpers.dart';
import 'package:pmreport/widgets/buttons/toffee_button.dart';

class MeasureMenu extends StatelessWidget {
  MeasureMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CategoriesMenu();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Category',
            style: TextStyle(
                fontSize: 18,
                color: Colors.brown
            ),),
          CategoriesMenu(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Bounce(
                duration: Duration(milliseconds: 100),
                // child: ToffeeButton('assets/report_menu_normal.png', 'Back'),
                child: Container(
                  // color: Colors.yellowAccent,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.brown,
                        ),
                      ),
                      Text('Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  print('Back pressed...');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


}
