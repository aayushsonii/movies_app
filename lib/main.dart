import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/views/widgets/custom_card.dart';
import 'package:movies/views/widgets/custom_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
  List<Movie> _movies = [];
  @override
  void initState() {
    super.initState();
    _populateMovies();
  }

  void _populateMovies({String movie}) async {
    final movies = await _getMovies(findMovie: movie);
    setState(() {
      _movies = movies;
    });
  }

  Future<List<Movie>> _getMovies({String findMovie}) async {
    String _findMovie;
    setState(() {
      _findMovie = findMovie;
    });
    final response = await http.get(
      Uri.parse(
          'https://www.omdbapi.com/?s=${_findMovie ?? "Batman"}&page=2&apikey=84e777a4'),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result['Search'];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw (response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              CustomInput(
                onChanged: (value) {
                  setState(() {
                    _populateMovies(movie: value);
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    _populateMovies(movie: value.replaceAll(" ", "_"));
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = _movies[index];
                    return MoviesCard(
                      poster: movie.poster,
                      title: movie.title,
                      year: movie.rating,
                      type: movie.type,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
