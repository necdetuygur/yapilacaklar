import 'package:flutter/material.dart';
import 'new_item_view.dart';
import 'todo.dart';
import 'database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yapılacaklar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> list = new List<Todo>();

  @override
  void initState() {
    /*
    list.add(Todo(title: "Eleman A."));
    list.add(Todo(title: "Eleman B."));
    list.add(Todo(title: "Eleman C."));
     */
    ReloadDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yapılacaklar"),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? buildBody() : buildEmptyBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToNewItemView(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index]);
      },
    );
  }

  Widget buildItem(Todo item) {
    return Dismissible(
        key: Key(item.hashCode.toString()),
        onDismissed: (direction) => removeItem(item),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red[500],
          child: Icon(Icons.delete, color: Colors.white),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
        ),
        child: buildListTile(item));
  }

  Widget buildListTile(Todo item) {
    return ListTile(
      title: Text(item.title),
      trailing: Checkbox(
        value: item.complete == 1,
        onChanged: (bool value) {
          setComplete(item);
        },
      ),
      onTap: () => setComplete(item),
      onLongPress: () => goToEditItemView(item),
    );
  }

  void setComplete(Todo item) {
    setState(() {
      item.complete = item.complete == 1 ? 0 : 1;
    });
    Set(item); // DB
    ReloadDatabase();
  }

  void removeItem(Todo item) {
    list.remove(item);
    Del(item.id); // DB
    ReloadDatabase();
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewItemView();
    })).then((title) {
      if (title != null) {
        addTodo(Todo(title: title));
      }
    });
  }

  void addTodo(Todo item) {
    list.add(item);
    Add(item); // DB
    ReloadDatabase();
  }

  void goToEditItemView(Todo item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewItemView(
        title: item.title,
      );
    })).then((title) {
      if (title != null) {
        editTodo(item, title);
      }
    });
  }

  void editTodo(Todo item, String title) {
    item.title = title;
    Set(item); // DB
    ReloadDatabase();
  }

  Widget buildEmptyBody() {
    return Center(child: Text("Yapılacak yok"));
  }

  void ReloadDatabase() {
    GetAll().then((lst) {
      setState(() {
        list = lst;
      });
    });
  }
}
