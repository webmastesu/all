import 'dart:convert';
import 'package:http/http.dart' as http;

class WordPressService {
  final String baseUrl;

  WordPressService({required this.baseUrl});

  Future<List<dynamic>> fetchPosts({int perPage = 10, int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?per_page=$perPage&page=$page&_embed'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<dynamic>> searchPosts({required String query}) async {
    final response = await http.get(Uri.parse('$baseUrl/wp-json/wp/v2/posts?search=$query&_embed'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search posts');
    }
  }
}
