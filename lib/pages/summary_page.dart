import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*  # of tasks
    **  # of tasks did last week, last month
    **  # individual task summary  
    */

    var summaryList = SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Text('# of tasks'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('1'),
                      Text('punched: 10'),
                      Icon(Icons.info),
                    ],
                  ),
                  Text('211'),
                ],
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            )
          ],
        )
      ]),
    );

    return CustomScrollView(
      slivers: <Widget>[
        summaryList,
      ],
    );
  }
}
