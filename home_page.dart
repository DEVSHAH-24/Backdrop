import 'package:flutter/material.dart';
import 'package:wallie/screens/account.dart';
import 'package:wallie/screens/explore.dart';
import 'package:wallie/screens/favorites.dart';
import 'package:wallie/screens/login_screen.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPageIndex = 0;
 // String appBarTitle;
  List _pages = [ExplorePage(),FavoritePage(),AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
        ),
        title: Text('Backdrop'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,

        onTap: (index){
          setState(() {
            _selectedPageIndex = index;
          });

        },
        backgroundColor: Colors.grey[900],
        items: [
          BottomNavigationBarItem(

              icon: Icon(Icons.search,), title: Text('Explore')),
          BottomNavigationBarItem(

            icon: Icon(Icons.favorite),
            title: Text('Favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Account'),
          ),
        ],
      ),
    );
  }
}
