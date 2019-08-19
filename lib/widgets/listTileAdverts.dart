import 'package:flutter/material.dart';


class CustomListItem extends StatelessWidget {
//  const CustomListItem({
//    this.thumbnail,
//    this.title,
//    this.user,
//    this.viewCount,
//  });
  const CustomListItem({
    this.leading1,
    this.leading2,
    this.title,
    this.first,
    this.second,
  });

  final Widget leading1;
  final Widget leading2;
  final String title;
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _InputDescription(
              leading1:leading1,
              leading2:leading2,
              title:title,
              first:first,
              second:second,
            ),
//          Padding(padding: EdgeInsets.fromLTRB(left, top, right, bottom)),
          Icon(Icons.arrow_forward_ios),


        ],
    );
  }
}

class _InputDescription extends StatelessWidget {
  const _InputDescription({
    Key key,
    this.leading1 = null,
    this.leading2 = null,
    this.title,
    this.first,
    this.second = null,
  }) : super(key: key);


  final Widget leading1;
  final Widget leading2;
  final String title;
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
            child:Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(32,110,65,1.0),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),

          ),
        Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child:
            Row(

              children: <Widget>[
                (leading1 == null)? SizedBox():leading1,
                (leading1 == null)? SizedBox():SizedBox(width: 7.5),
                Text(
                  first,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(112, 112, 112, 1.0),
                  ),
                ),
              ],
            ),

          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        Container(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child:Row(
            children: <Widget>[
              (leading2 == null)? SizedBox():leading2,
              (leading2 == null)? SizedBox():SizedBox(width: 7.5),
              (second == null)? SizedBox():
              Text(
                second,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(112, 112, 112, 1.0),
                ),
              ),
            ],
          )

        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        ],
//      ),
    );
  }
}

// ...
