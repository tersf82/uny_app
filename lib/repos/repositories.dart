import 'dart:convert';
import 'package:http/http.dart';
import '../models/models.dart';


class UserRepository {

  String url = 'https://jsonplaceholder.typicode.com/comments';

 Future<List<CommentModel>>  getComments() async {
      Response response = await get(Uri.parse(url));

      if(response.statusCode == 200) {
        final List result = jsonDecode(response.body);
        return result.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        throw Exception(response.reasonPhrase);
      }
  }
}