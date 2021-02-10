import 'package:flutter/material.dart';
import 'package:surplus/models/cardmodel.dart';

class SearchResults extends StatefulWidget {
  var titlearr,descarr,km, urlarr;
  SearchResults(this.titlearr,this.descarr,this.km,this.urlarr);


  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: 650,
            child: CardModel(
                        url: widget.urlarr,
                        title: widget.titlearr.toString(),
                        distance: "${widget.km} kms",
                        desc: widget.descarr.toString()),

          ),
        ),
      ),
    );
  }
}
