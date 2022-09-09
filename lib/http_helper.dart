import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'model/movie.dart';

class HttpHelper {
  final String url =
      'https://api.themoviedb.org/3/movie/popular?api_key=a2e909496e75e74c53864f0c3aa7eaf9&language=en-US';

  final String searchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=a2e909496e75e74c53864f0c3aa7eaf9&query=';


  Future<List> findMovies(String title) async {
    final String query = searchBase + title;
    http.Response result = await http.get(Uri.parse(query));

    if (result != null) {
      final response = json.decode(result.body);
      final moviesMap = response['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
/*  Future<List> similar(movieId) async {
    final String similarQuery = 'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=a2e909496e75e74c53864f0c3aa7eaf9&language=en-US&page=1';

    http.Response result = await http.get(Uri.parse(similarQuery));

    if (result != null) {
      final response = json.decode(result.body);
      final moviesMap = response['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
*/
  Future<List> getUpcoming() async {
    http.Response result = await http.get(Uri.parse(url));

    if (result.statusCode == HttpStatus.ok) {
      final response = json.decode(result.body);
      final movieMap = response['results'];
      List movies = movieMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
