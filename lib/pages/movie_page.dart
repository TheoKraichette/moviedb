import 'package:moviedb/http_helper.dart';
import 'package:moviedb/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text(
    'MovieDb',
    style: TextStyle(
      color: Colors.red,
      fontSize: 30,
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
  ).p8();

  HttpHelper helper;
  int movieCount;
  List movies;
  bool textSearch = false;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://askleo.askleomedia.com/wp-content/uploads/2004/06/no_image-300x245.jpg';

  Future initialize() async {
    movies = [];
    movies = await helper.getUpcoming();
    setState(() {
      movieCount = movies.length;
      movies = movies;
      textSearch = false;
    });
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      movieCount = movies.length;
      movies = movies;
      textSearch = true;
    });
  }

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 3.0,
        shadowColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (this.visibleIcon.icon == Icons.search) {
                  this.visibleIcon = Icon(Icons.cancel_sharp);
                  this.searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    onSubmitted: (String text) {
                      search(text);
                    },
                  ).p4();
                } else {
                  setState(() {
                    this.visibleIcon = Icon(Icons.search);
                    this.searchBar = TextButton(
                      child: Text('MovieDb'),
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      onPressed: () {
                        initialize();
                      },
                    ).p8();
                  });
                }
              });
            },
            icon: visibleIcon,
            iconSize: 30.0,
            color: Colors.red,
          ).px8(),
        ],
        title: searchBar,
      ),
      body: (movies != null && movies.isNotEmpty)
          ? Column(children: [
              Container(
                  child: Text(
                textSearch ? "Search" : 'Popular Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              )),
              Expanded(
                  // The ListView
                  child: ListView.builder(
                itemCount: (this.movieCount == null) ? 0 : movieCount,
                itemBuilder: (BuildContext context, int position) {
                  if (movies[position].posterPath != null) {
                    image =
                        NetworkImage(iconBase + movies[position].posterPath);
                  } else {
                    image = NetworkImage(defaultImage);
                  }
                  return InkWell(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetailPage(movies[position]),
                      );
                      Navigator.push(context, route);
                    },
                    child: Card(
                      color: Color(0xffE1E1E1),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: image,
                          radius: 32.0,
                        ).p0(),
                        title: Text(
                          movies[position].title,
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          'Release date: ' +
                              movies[position].releaseDate +
                              '\n'
                                  'Vote: ' +
                              movies[position].voteAverage.toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ).p4(),
                    ).p8(),
                  ).p0();
                },
              ).p16().pOnly(top: 16.0))
            ])
          : Center(
              child: Text(
                'Movies not found',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
            ),
    ));
  }
}
