import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Slidable Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Slidable Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView.builder(
          itemBuilder: (context, index) {
  return new Slidable(
    key: Key('$index'),
    delegate: _getDelegate(index),
    actionsExtentRatio: 0.5,
    child: new Container(
      color: Colors.white,
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundColor: _getAvatarColor(index),
          child: new Text('$index'),
          foregroundColor: Colors.white,
        ),
        title: new Text('Tile n°$index'),
        subtitle: new Text(_getSubtitle(index)),
      ),
    ),
    leftActions: <Widget>[
      new IconSlideAction(
        caption: 'Archive',
        color: Colors.blue,
        icon: Icons.archive,
        onTap: () => _showSnackBar('Archive'),
      ),
      new IconSlideAction(
        caption: 'Share',
        color: Colors.indigo,
        icon: Icons.share,
        onTap: () => _showSnackBar('Share'),
      ),
    ],
    rightActions: <Widget>[
      new IconSlideAction(
        caption: 'More',
        color: Colors.grey.shade200,
        icon: Icons.more_horiz,
        onTap: () => _showSnackBar('More'),
      ),
      new IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => _showSnackBar('Delete'),
      ),
    ],
  );
          },
          itemCount: 20,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  SlidableDelegate _getDelegate(int index) {
    switch (index % 4) {
      case 0:
        return new SlidableBehindDelegate();
      case 1:
        return new SlidableStrechDelegate();
      case 2:
        return new SlidableScrollDelegate();
      case 3:
        return new SlidableDrawerDelegate();
      default:
        return null;
    }
  }

  Color _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  String _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindDelegate';
      case 1:
        return 'SlidableStrechDelegate';
      case 2:
        return 'SlidableScrollDelegate';
      case 3:
        return 'SlidableDrawerDelegate';
      default:
        return null;
    }
  }

  void _showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }
}