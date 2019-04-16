import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
import 'package:loginandsignup/icons/customIcons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loginandsignup/data/data.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailSentDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Column(children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20.0),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      child: Image.asset(
                        'assets/email.png',
                        width: 60,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Vui lòng xác nhận tài khoản",
                            style:
                                TextStyle(fontFamily: "oscinebold", fontSize: 16),
                          ),
                          SizedBox(height: 10.0),
                          Flexible(
                            child: Text(
                              "Một email với đường link xác nhận tài khoản đã được gửi tới hòm thư của bạn",
                              style: TextStyle(fontFamily: "oscinebold"),
                            ),
                          ),
                          //SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Bỏ qua",
                      style: TextStyle(fontFamily: "oscinebold"),
                    ),
                    color: Colors.red,
                    colorBrightness: Brightness.dark,
                    onPressed: () {
                      _signOut();
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  //SizedBox(width: 10.0),
                  RaisedButton(
                    child: Text(
                      "Gửi lại",
                      style: TextStyle(fontFamily: "oscinebold"),
                    ),
                    color: Color(0xFF212121),
                    colorBrightness: Brightness.dark,
                    onPressed: () {
                      _resentVerifyEmail();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ],
              ))
            ]),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  var currentPage=images.length-1.0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    PageController controller=PageController(initialPage: images.length-1);
    controller.addListener((){
      setState(() {
        currentPage=controller.page;
      });
    });
    return Scaffold(
      backgroundColor: Color(0xFF2d3247),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 30, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        CustomIcons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {}),
                  Container(
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          _signOut();
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Doanh thu hàng ngày",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "oscinebold",
                    ),
                  ),
                ],
              ),
            ),
           /* Stack(
              children: <Widget>[
                CardScrollWidget(currentPage),
                Positioned.fill(
                    child: PageView.builder(
                        itemCount: images.length,
                        controller: controller,
                        reverse: true,
                        itemBuilder: (context,index){
                          return Container();
                        }
                    ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
