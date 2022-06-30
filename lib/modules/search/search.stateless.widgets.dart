import 'package:flutter/material.dart';

import '../../helper/commondropdown.dart';
import '../theme/configtheme.dart';
import '../theme/themenotifier.dart';
import 'search.notifiers.dart';
import 'package:provider/provider.dart';

class SearchTotRecordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Notifier<int>>(
      builder: (context, count, child) => Container(
        // height: 100,
        // width: 150,
        child: Center(
          child: Text('Total record: ${count.value.toString()}'),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: ezThemeData[ThemeNotifier.ezCurThemeName]!
        //         .buttonTheme
        //         .colorScheme!
        //         .onSurface,
        //     // width: 5,
        //   ),
        // ),
      ),
    );
  }
}

class SinceAgoDropdownWidget extends StatelessWidget {
  // const SinceAgoDropdownWidget({Key? key, })
  //     : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<SinceAgoNotifier>(
      builder: (context, sinceAgo, child) => Container(
          child: CommonDropDown(
              k: "sinceAgo",
              w: 150,
              uniqueValues: sinceAgo.ddItems.values.toList(),
              ddDataSourceNames: sinceAgo.ddItems.values.toList(),
              lblTxt: "Since ago",
              selectedVal: sinceAgo.selectedVal,
              onChanged: (String? val) {
                if (val != null) {
                  //Future.delayed(Duration.zero, () {
                  sinceAgo.selectedVal = val;
                  //});
                }
              })),
    );
  }
}
