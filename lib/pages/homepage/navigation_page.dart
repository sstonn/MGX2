import 'package:loginandsignup/pages/homepage/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:loginandsignup/services/authentication.dart';
import 'package:loginandsignup/pages/homepage/second_page.dart';
import 'package:loginandsignup/pages/homepage/home_page.dart';
import 'package:loginandsignup/pages/login_signup_page.dart';
class NavigationPage extends StatefulWidget {
  NavigationPage({this.auth});

  final BaseAuth auth;
  @override
  _NavigationPageState createState() => _NavigationPageState();
}
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
class _NavigationPageState extends State<NavigationPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  int currentPage = 0;
  String _userId = "";
  bool _isEmailVerified = false;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }
  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;

    });
  }
  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    if(authStatus==AuthStatus.NOT_LOGGED_IN){
      return new LoginSignUpPage(
        auth: widget.auth,
        onSignedIn: _onLoggedIn,
      );
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.monetization_on,
              title: "Doanh thu",
              onclick: () {
                /*final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(0);*/
              }),
          TabData(
              iconData: Icons.multiline_chart,
              title: "Thống kê",
          ),
          TabData(
              iconData: Icons.local_parking,
              title: "Quản lý bãi"
          ),
          TabData(
              iconData: Icons.supervised_user_circle,
              title: "Nhân viên"
          ),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[Text("Hello"), Text("World")],
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return MyHomePage(
          userId: _userId,
          auth: widget.auth,
          onSignedOut: _onSignedOut,
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the search page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondPage()));
              },
            )
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the basket page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
  }
}
