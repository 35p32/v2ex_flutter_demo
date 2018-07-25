import 'package:flutter/material.dart';
import 'package:flutter_app/model/RepliesResp.dart';
import 'package:flutter_app/model/TopicsResp.dart';
import 'package:flutter_app/network/NetworkApi.dart';
import 'package:flutter_app/utils/TimeBase.dart';

class TopicDetails extends StatelessWidget {
  final Topic topic;

  TopicDetails(this.topic);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Topic detils',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(topic.title),
          leading: new GestureDetector(
            onTap: () {
              print('back');
              Navigator.pop(context);
            },
            child: new Icon(Icons.arrow_back),
          ),
        ),
        body: new ListView(
          children: <Widget>[
            new TopicContentView(topic),
            new RepliesView(topic.id),
          ],
        ),
      ),
    );
  }
}

class RepliesView extends StatelessWidget {
  final int topicId;

  RepliesView(this.topicId);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<RepliesResp>(
        future: NetworkApi.getReplies(topicId),
        builder: (context, result) {
          if (result.hasData) {
//            return new Column(
//              children: result.data.list.map((Reply reply) {
//                return new Text(reply.id.toString());
//              }).toList(),
//            );
            return new Center(
              child: new Text("${result.error}"),
            );
          } else if (result.hasError) {
            return new Center(
              child: new Text("${result.error}"),
            );
          }

          return new Center(
            child: new CircularProgressIndicator(),
          );
        });
  }
}

class TopicContentView extends StatelessWidget {
  final Topic topic;

  TopicContentView(this.topic);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.only(
              left: 10.0, top: 10.0, bottom: 5.0, right: 10.0),
          width: 500.0,
          child: new Text(
            topic.title,
            softWrap: true,
            style: new TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        new Container(
          padding: const EdgeInsets.only(
              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
          child: new Text(
            topic.content,
            softWrap: true,
            style: new TextStyle(color: Colors.black87, fontSize: 14.0),
          ),
        ),
        new Container(
          color: Colors.black,
          height: 0.2,
        ),
        new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Row(
            children: <Widget>[
              new Container(
                width: 40.0,
                height: 40.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        new NetworkImage('https:' + topic.member.avatar_large),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: new Text(
                  topic.member.username +
                      ' · ' +
                      new TimeBase(topic.last_modified).getShowTime(),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            ],
          ),
        ),
        new Container(
          color: Colors.black,
          height: 0.2,
        ),
      ],
    );
  }
}