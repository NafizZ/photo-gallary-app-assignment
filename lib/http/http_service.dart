import 'dart:convert';
import 'package:http/http.dart';

class HttpService {
  final String imagesURL = "https://picsum.photos/v2/list";

  Future<List> getImages() async {
    Response res = await get(Uri.parse(imagesURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      return body;
    } else {
      throw "Unable to retrieve images.";
    }
  }
}