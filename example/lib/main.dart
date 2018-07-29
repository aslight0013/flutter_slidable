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
        child: _buildList(context, Axis.vertical),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return new ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        if (index < 8) {
          return _getSlidableWithLists(context, index, slidableDirection);
        } else {
          return _getSlidableWithDelegates(context, index, slidableDirection);
        }
      },
      itemCount: 20,
    );
  }

  Widget _buildVerticalListItem(BuildContext context, int index) {
    return new Container(
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
    );
  }

  Widget _buildhorizontalListItem(BuildContext context, int index) {
    return new Container(
      color: Colors.white,
      width: 160.0,
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Expanded(
            child: new CircleAvatar(
              backgroundColor: _getAvatarColor(index),
              child: new Text('$index'),
              foregroundColor: Colors.white,
            ),
          ),
          new Expanded(
            child: Center(
              child: new Text(
                _getSubtitle(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    return new Slidable(
      direction: direction,
      slideToDismissDelegate: const SlideToDismissDrawerDelegate(),
      delegate: _getDelegate(index),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? _buildVerticalListItem(context, index)
          : _buildhorizontalListItem(context, index),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _showSnackBar(context, 'Archive'),
        ),
        new IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _showSnackBar(context, 'Share'),
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'More',
          color: Colors.grey.shade200,
          icon: Icons.more_horiz,
          onTap: () => _showSnackBar(context, 'More'),
          closeOnTap: false,
        ),
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showSnackBar(context, 'Delete'),
        ),
      ],
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    return new Slidable.builder(
      direction: direction,
      slideToDismissDelegate: const SlideToDismissDrawerDelegate(),
      delegate: _getDelegate(index),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? _buildVerticalListItem(context, index)
          : _buildhorizontalListItem(context, index),
      actionDelegate: new SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, step) {
            if (index == 0) {
              return new IconSlideAction(
                caption: 'Archive',
                color: Colors.blue.withOpacity(animation.value),
                icon: Icons.archive,
                onTap: () => _showSnackBar(context, 'Archive'),
              );
            } else {
              return new IconSlideAction(
                caption: 'Share',
                color: Colors.indigo.withOpacity(animation.value),
                icon: Icons.share,
                onTap: () => _showSnackBar(context, 'Share'),
              );
            }
          }),
      secondaryActionDelegate: new SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, step) {
            if (index == 0) {
              return new IconSlideAction(
                caption: 'More',
                color: Colors.grey.shade200.withOpacity(animation.value),
                icon: Icons.more_horiz,
                onTap: () => _showSnackBar(context, 'More'),
                closeOnTap: false,
              );
            } else {
              return new IconSlideAction(
                caption: 'Delete',
                color: Colors.red.withOpacity(animation.value),
                icon: Icons.delete,
                onTap: () => _showSnackBar(context, 'Delete'),
              );
            }
          }),
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

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }
}
