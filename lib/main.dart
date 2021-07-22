import 'package:flutter/material.dart';
import 'package:gii_test/Database.dart';
import 'package:gii_test/Movie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> data = [];

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController directorController = new TextEditingController();
  TextEditingController photoURLController = new TextEditingController();

  Future<void> _showMyDialog(Movie movie) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.all(5),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Image.network(movie.photo!),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(movie.title!),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(movie.description!),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(movie.director!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFormDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.all(5),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description",
                  ),
                ),
                TextFormField(
                  controller: directorController,
                  decoration: InputDecoration(
                    hintText: "Director",
                  ),
                ),
                TextFormField(
                  controller: photoURLController,
                  decoration: InputDecoration(
                    hintText: "Photo (URL)",
                  ),
                ),
                MaterialButton(
                  onPressed: (){
                    DatabaseHelper.instance.insert(({
                      "title": titleController.value.text,
                      "description": descriptionController.value.text,
                      "director": directorController.value.text,
                      "photo": photoURLController.value.text
                    })).then((value){
                      titleController.clear();
                      descriptionController.clear();
                      directorController.clear();
                      photoURLController.clear();
                      Navigator.pop(context);
                    });
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('Simpan'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: MaterialButton(
                onPressed: (){
                  data = [];
                  DatabaseHelper.instance.getData().then((value) {
                    if(value.length>0){
                      print(value);
                      value.forEach((element) {
                        setState(() {
                          data.add(element);
                        });
                      });
                    }
                  });
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Fetch'),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for(Movie e in data)
                    InkWell(
                      onTap: (){
                        _showMyDialog(e);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Text(e.title!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
          _showFormDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
