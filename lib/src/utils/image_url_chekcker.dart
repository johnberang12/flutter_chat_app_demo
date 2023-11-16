import 'package:http/http.dart' as http;

Future<String> checkImageUrl(String url) async {
  final response = await http.head(Uri.parse(url));
  if (response.statusCode == 200) return url;
  throw Exception('Url provided is invalid or not reachable');
}
