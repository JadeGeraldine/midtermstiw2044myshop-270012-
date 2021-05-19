import 'package:flutter/material.dart';
import 'newproduct.dart';

void main() => runApp(const Main());

/// This is the main application widget.
class Main extends StatelessWidget {
  const Main({key}) : super(key: key);

  static const String _title = 'Midterm';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MainScreen(),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MainScreen extends StatelessWidget {
  const MainScreen({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container
      (decoration: new BoxDecoration
        (gradient: new LinearGradient
          (begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           stops: [0.3,1],
           colors: [Colors.green[200],
                    Colors.red[200]
                   ],
          ),
        ),
     child:Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MY SHOP',
            style: TextStyle(fontSize: 25),),
        backgroundColor: Colors.green
      ),
      body: const Center(child: Text('Press the button below to add new product!', 
            style: TextStyle(fontSize: 20),)),
      backgroundColor:   Colors.white10,
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton
            (onPressed: () {
              Navigator.push
              (context, MaterialPageRoute(builder: (content) => NewProductScreen()));
            },
        child: const Icon(Icons.add, size:30.0),
        backgroundColor: Colors.green,),
        ),
      ),
      ),
    );
  }
}