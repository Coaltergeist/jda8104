import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  runApp(new MyApp());
}

final appTitle = 'Essentials for Parenting';
final content = {
  'Overview':
      '''<div class="module"><div><p><em>Essentials for Parenting Toddlers and Preschoolers</em> is a free, online resource developed by the Centers for Disease Control and Prevention (CDC). Designed for parents of 2 to 4 year olds, <em>Essentials for Parenting</em> addresses common parenting challenges, like tantrums and whining. The purpose of the resource is to provide as much information as possible on things you can do to build a positive, healthy relationship. Skills focus on encouraging good behavior and decreasing misbehavior using proven strategies like positive communication, structure and rules, clear directions, and consistent discipline and consequences.</p></div></div>
<h5>
<em>Essentials for Parenting</em> includes:</h5>
<ul>
<li>Articles with a variety of skills, tips, and techniques</li>
<li>“Frequently Asked Questions” answered by parenting experts</li>
<li>Fun and engaging videos featuring parents, children, and parenting experts who demonstrate and discuss skills</li>
<li>Free print resources like chore charts and daily schedules</li>
</ul>
<h5>
<em>Essentials for Parenting</em> is based on:</h5>
<ul>
<li>Decades of research and practical parenting experience suggesting that certain skills are useful in building a positive relationship and in handling children’s challenging behaviors.</li>
<li>Research conducted by CDC over the last 5 years about the types of questions parents have, where and how they look for information, and how they want to receive information.</li>
</ul>
<h3>All Families are Not Alike</h3>
<p>We know that every child and every parent is unique. You face many different situations and challenges every day. We don’t take a one-size-fits-all approach or think of this as a set of strict parenting rules that must be followed. We hope to give you new ideas for parenting so you can make the best decisions about what can work with your child and family.</p>
''',
  'Communicating with Your Child': '',
  'Creating Structure and Rules': '',
  'Giving Directions': '',
  'Using Discipline and Consequences':
      '''<p>Did you know that what you do right after any of your child’s behavior makes a difference? This may be why your child has good behavior some days and not others. Learning how to use discipline and consequences can help you have more good days with your child. It can also help you get behaviors you like to happen more.</p>
<h3>Keys to Using Discipline and Consequences</h3>
<ol>
<li>Use social rewards (like hugs and kisses) more than material rewards (like toys or candy). Social rewards can be given often and are more powerful! <a href="/parents/essentials/consequences/rewards.html">Click here to learn more</a>.</li>
<li>Sticker charts or similar reward programs can help change your child’s behavior. <a href="/parents/essentials/activities/activities-structure.html">Click here to create your own reward chart</a>.</li>
<li>Ignoring misbehavior means taking away your attention. It helps stop misbehaviors like tantrums, whining, and interrupting. <a href="/parents/essentials/consequences/ignoring.html">Click here to learn more</a>.</li>
<li>Want to reduce misbehavior? <a href="/parents/essentials/consequences/misbehaviors-steps.html">Try these five steps</a>.</li>
<li>Distracting your child can help stop misbehaviors. It works by getting your child to think and do something else so he doesn’t continue to misbehave.</li>
<li>Toddlers and preschoolers have short attention spans. Give consequences right after a misbehavior so they can remember what they did that you do not like.</li>
<li>Use consequences that match your child’s age and stage of development. <a href="/parents/essentials/consequences/whyimportant.html">Click here to learn more</a>.</li>
</ol>''',
  'Using Time-Out': '',
  'Practice Parenting Skills': '',
  'Parenting Videos': '',
  'Other Resources': ''
};
final fakeresults = {
  'Using Discipline and Consequences':
      'Did you know that what you do right after any of your child’s behavior makes a difference? This may be why your child has good behavior some days and not others. Learning how to use...',
  'Communicating with Your Child':
      'Good communication between you and your child is important for developing a positive relationship. As your child gets older, good communication will make it easier for you to talk...',
  'Ignoring':
      'Attention from parents is very rewarding for children. Attention can be both positive and negative. Positive attention refers to things you do to let your child know you like something...',
  'Using Consequences for Misbehaviors':
      'A consequence is what happens immediately after a behavior. Consequences can be both positive and negative. Positive consequences show your child she has done something you...'
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: appTitle,
        theme: new ThemeData(
          primaryColor: Colors.deepPurple,
        ),
        home: new Home(),
        routes: {'/search': (context) => new SearchPage()});
  }
}

class MyAppBar extends AppBar {
  MyAppBar(BuildContext context, {Key key, Widget title})
      : super(key: key, title: title, actions: [
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
        ]);
}

Widget _buildDrawer(BuildContext context) {
  return new Drawer(
    child: new ListView(
      children: content.keys.map<Widget>((title) {
        return new ListTile(
          title: new Text(title),
          trailing:
              new IconButton(icon: new Icon(Icons.add_circle), onPressed: null,),
          onTap: () {
            Navigator.of(context).pop();
            _navigate(title, context);
          },
        );
      }).toList(),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        context,
        title: new Text(appTitle),
      ),
      body: new GridView.count(
        crossAxisCount: 2,
        children: content.keys.map((title) {
          return _buildTile(title, context);
        }).toList(),
      ),
      endDrawer: _buildDrawer(context),
    );
  }

  Widget _buildTile(String path, BuildContext context) {
    return new GestureDetector(
      child: new Card(
        child: new GridTile(
          child: new Center(
            child: new Text(
              path,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ),
      ),
      onTap: () {
        _navigate(path, context);
      },
    );
  }
}

_navigate(title, context) {
  Navigator.of(context).push(
    new MaterialPageRoute(
      builder: (context) {
        return new Article(title, content[title]);
      },
    ),
  );
}

class Article extends StatelessWidget {
  final String _title;
  final String _content;

  Article(this._title, this._content);

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: new Uri.dataFromString(
        _content,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
      appBar: new MyAppBar(
        context,
        title: new Text(_title),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  bool _searching = false;

  AppBar buildAppBar(BuildContext context) {
    var textColor = Colors.white70;
    var hintText = 'Search';
    return new AppBar(
      title: new TextField(
        keyboardType: TextInputType.text,
        style: new TextStyle(color: textColor, fontSize: 16.0),
        decoration: new InputDecoration(
            hintText: hintText,
            hintStyle: new TextStyle(color: textColor, fontSize: 16.0),
            border: null),
        onSubmitted: (String val) {
          print(val);
          setState(() {
            _searching = true;
          });
        },
        autofocus: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body: _buildResults(context),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_searching) {
      final tiles = fakeresults.entries.map<Widget>(
        (entry) {
          return new ListTile(
            title: new Text(entry.key),
            subtitle: new Text(entry.value),
            onTap: () {
              _navigate('Using Discipline and Consequences', context);
            },
          );
        },
      );

      final divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();
      return new ListView(
        padding: const EdgeInsets.all(16.0),
        children: divided,
      );
    }
    return new Container();
  }
}
