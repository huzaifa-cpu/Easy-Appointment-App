import 'package:http/http.dart';
import 'dart:convert';


class loginService{

  Future<void> getData() async {
    Response response =
    await get('https://jsonplaceholder.typicode.com/todos/1');
    Map data = jsonDecode(response.body);
    print(data['title']);
  }
}