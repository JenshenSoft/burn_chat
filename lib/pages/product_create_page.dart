import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(autocorrect: true, onChanged: (value) {

      },),
      //Text()
    ],);
    /*return Center(
      child: RaisedButton(
          child: Text('Save'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Center(
                    child: Text('This is modal!'),
                  );
                });
          }),
    );*/
  }
}
