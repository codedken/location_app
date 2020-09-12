import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function selectLocation;

  LocationInput(this.selectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewLocationUrl;

  void _getLocation(double lat, double lng) {
    final _mapPreviewUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewLocationUrl = _mapPreviewUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    _getLocation(locData.latitude, locData.longitude);
    widget.selectLocation(
      locData.latitude,
      locData.longitude,
    );
  }

  Future<void> _getLocationFromMap() async {
    final mapData = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(isSelecting: true),
      ),
    );

    if (mapData == null) {
      return;
    }
    _getLocation(mapData.latitude, mapData.longitude);
    widget.selectLocation(
      mapData.latitude,
      mapData.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 170.0,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _previewLocationUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewLocationUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            SizedBox(width: 10.0),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select a map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getLocationFromMap,
            )
          ],
        )
      ],
    );
  }
}
