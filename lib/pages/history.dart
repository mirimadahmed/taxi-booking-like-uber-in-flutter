import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Deine Fahrten",
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(
                "VERLAUF",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 1,
                color: Color.fromRGBO(32, 110, 65, 1.0),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "23.05.2019",
                                    style: TextStyle(
                                        color: Color.fromRGBO(32, 110, 65, 1.0),
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "5,55 €",
                                    style: TextStyle(
                                        color: Color.fromRGBO(32, 110, 65, 1.0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Icon(Icons.location_on,
                                            color: Color.fromRGBO(
                                                32, 110, 65, 1.0)),
                                        Text(
                                            "Maximiliansplatz 5, 80333 München",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    32, 110, 65, 1.0),
                                                fontSize: 15))
                                      ]),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(children: <Widget>[
                                        Icon(Icons.location_on,
                                            color: Color.fromRGBO(
                                                32, 110, 65, 1.0)),
                                        Text(
                                            "Maximiliansplatz 5, 80333 München",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    32, 110, 65, 1.0),
                                                fontSize: 15))
                                      ]),
                                    ],
                                  ),
                                  Column(children: <Widget>[
                                    Container(
                                        width: 50.00,
                                        height: 50.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: new DecorationImage(
                                            image: ExactAssetImage(
                                                'assets/profileImage.jpg'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          child: Image.asset(
                                            "assets/rating.png",
                                            fit: BoxFit.fill,
                                          ),
                                          alignment: Alignment.bottomRight,
                                        )),
                                    Text(
                                      "Alex",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(32, 110, 65, 1.0)),
                                    )
                                  ])
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider()
                            ],
                          ));
                        },
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
