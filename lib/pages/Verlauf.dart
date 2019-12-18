import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class VerlaufPage extends StatefulWidget {
  @override
  _VerlaufPageState createState() => _VerlaufPageState();
}

class _VerlaufPageState extends State<VerlaufPage>
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
            "Verlauf",
            style: TextStyle(
                color: Color.fromRGBO(112, 112, 112, 1.0), fontSize: 16.0),
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
              Container(
                height: 0.5,
                color: Color.fromRGBO(112, 112, 112, 1.0),
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
                              Text(
                                'Bezahlung mit Moobercredit',
                                style: TextStyle(
                                    color: Color.fromRGBO(112, 112, 112, 1.0),
                                    fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "23.05.2019",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(112, 112, 112, 1.0),
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "-5,55 €",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )
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
