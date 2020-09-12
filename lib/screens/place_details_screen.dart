import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_provider.dart';

import 'map_screen.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = 'place_details';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final place = Provider.of<PlacesProvider>(
      context,
      listen: false,
    ).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(children: <Widget>[
        Hero(
          tag: place.id,
          child: Container(
            height: 200,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          place.location.address,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10.0),
        FlatButton(
          child: Text('View on Map'),
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapScreen(
                  location: place.location,
                  isSelecting: false,
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
