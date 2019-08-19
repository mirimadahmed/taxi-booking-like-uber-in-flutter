import 'package:flutter/material.dart';


class CustomListItem extends StatelessWidget {

  const CustomListItem({
    this.thumbnail,
    this.timeTitle,
    this.first,
    this.second,
  });

  final Widget thumbnail;
  final String timeTitle;
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Expanded(
            flex: 4,
            child:
            _DriversDescription(
              timeTitle:timeTitle,
              first:first,
              second:second,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                thumbnail,
              ],
            )
          ),
        ],
      ),
    );
  }
}

class _DriversDescription extends StatelessWidget {
  const _DriversDescription({
    Key key,
    this.timeTitle,
    this.first,
    this.second = null,
  }) : super(key: key);


  final String timeTitle;
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 5, 0.0, 0.0),
            child:Text(
              timeTitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(32,110,65,1.0),
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),

          ),
        Container(
            padding: EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),

            child:
            Row(

              children: <Widget>[
                Image.asset("assets/locationPerson.png"),
               Flexible(child:  Text(
                  first,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(

                    fontSize: 15.0,
                    color:  Color.fromRGBO(32,110,65,1.0),
                  ),
                ),
               ),
              ],
            ),

          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
//        Flexible(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0.0, 0.0, 0.0),
          child:Row(
            children: <Widget>[
              Image.asset("assets/locationFlag.png"),
              Flexible(
                child:
                Text(
                  second,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(32,110,65,1.0),
                  ),
                ),
              ),
            ],
          )

        ),
        ],
//      ),
    );
  }
}

// ...
