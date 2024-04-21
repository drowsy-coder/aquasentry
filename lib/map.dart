import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class VITMap extends StatefulWidget {
  const VITMap({super.key});

  @override
  State<VITMap> createState() => _VITMapState();
}

class _VITMapState extends State<VITMap> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.83966720164967, 80.15526799194957),
    zoom: 17,
  );

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLang = <LatLng>[
    const LatLng(12.839719504490347, 80.15521971218855), //MG
    const LatLng(12.84025046572062, 80.15272843194869), //Main Gate
  ];

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    loadData();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }
  }

  void loadData() async {
    List<String> markerImages = [
      "assets/4840.png_1200.png",
      "assets/4840.png_1200.png",
    ];

    for (int i = 0; i < _latLang.length; i++) {
      Uint8List? markerIcon = await getBytesFromAssets(markerImages[i], 130);

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dustbin in VIT-C Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: Set<Marker>.of(_markers),
        myLocationEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
