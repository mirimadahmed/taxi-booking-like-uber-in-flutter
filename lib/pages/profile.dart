import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This app is a stateful, it tracks the user's current choice.
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
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
            "Profil",
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
          padding: EdgeInsets.zero,
          child: ListView(
            children: <Widget>[
              Container(
                height: 1,
                color: Color.fromRGBO(32, 110, 65, 1.0),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 80.00,
                        height: 80.00,
//                              margin: EdgeInsets.only(top: 50.0,left: 20),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: new DecorationImage(
                            image: ExactAssetImage('assets/profileImage.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/rating.png"),
                          alignment: Alignment.bottomRight,
                        )),
                    Text(
                      'Mikey Mechito',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@mechitomike',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Persönliche Daten",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Mikey Mechito",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18),
                                ),
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile1");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Kontakt",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset("assets/mail.png"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "mustermail@muster.com",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 18),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset("assets/call.png"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "+4917612345678",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 18),
                                    )
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile2");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Favoriten",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Mein Adressbuch",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile3");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Allgemein",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(32, 110, 65, 1.0)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Passwort ändern",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/profile4");
                                })
                          ],
                        )
                      ])),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      "Ich möchte News und Rabatte via E-Mail, Push oder SMS erhalten. Hierzu werden Standort-, Nutzung- und Inhaltsdaten gemäß unserer Datenschutzerklärung kombiniert. Die Einwilligung kann ich jederzeit widerrufen.")),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(color: Color.fromRGBO(32, 110, 65, 1.0)),
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(32, 110, 65, 0.5),
                          ),alignment: Alignment.bottomCenter,
                          height: 22,width: 40,
                        ),
                        Switch(
                          onChanged: (v){},
                          value: false,
                          activeColor: Color.fromRGBO(32, 110, 65, 1.0),
                          inactiveThumbColor: Color.fromRGBO(32, 110, 65, 1.0),

                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                      ]
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Account löschen",
                    style: TextStyle(
                      color: Color.fromRGBO(32, 110, 65, 1.0),
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Text(
                    "Ausloggen",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Color.fromRGBO(32, 110, 65, 1.0),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
