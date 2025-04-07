import 'dart:convert';

import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/category.dart';
// import 'package:vendor_app/services/manage_http_response.dart';
// import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  // load the uploaded categories from the database
  Future<List<Category>> loadCategories() async {
    
    try {
      // send an http get request to load the categories
      http.Response response = await http
          .get(Uri.parse('$uri/api/categories'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      print('Category Response: ${response.body}');

      // print(response.body);
      if (response.statusCode == 200) {
        //OK
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((item) => Category.fromJson(item)).toList();
        return categories;
      } else {
        //throw an exception if the server responded with an error status code
        throw Exception('Failed to load Categories: ');
      }
    } catch (e, stacktrace) {
  print("Error loading categories: $e");
  print("StackTrace: $stacktrace");
  throw Exception("Error Loading categories: $e");
}

  }
}
