import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../infrastructure/navigation/routes.dart';

class LocationController extends GetxController {
  String address = "";
  String posCode = "";
  String label = "";
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = false;

  Future<void> checkAndRequestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> initGeolocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;

    update();
  }

  Future<void> getAddressFromCoordinates(double lat, double long) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        long,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        address =
            "${placemark.thoroughfare} ${placemark.locality} ${placemark.subLocality} ${placemark.subAdministrativeArea} ${placemark.postalCode}";
        posCode = placemark.postalCode ?? "";
        label =
            "${placemark.thoroughfare == '' ? placemark.locality : placemark.thoroughfare}";
        update();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void onTapMaps(LatLng latLng) async {
    await Future.delayed(400.milliseconds, () {
      latitude = latLng.latitude;
      longitude = latLng.longitude;
      update();
    });
    await getAddressFromCoordinates(latLng.latitude, latLng.longitude);
    update();
  }

  Future<void> initData() async {
    isLoading = true;
    update();
    await checkAndRequestLocationPermission();
    if (Get.arguments['with-latlong'] == true) {
      latitude = Get.arguments['lat'];
      longitude = Get.arguments['lng'];
    } else {
      await initGeolocation();
    }
    await getAddressFromCoordinates(latitude, longitude);
    isLoading = false;
    update();
  }

  void selectLocation() {
    Get.toNamed(Routes.DETAIL_ADDRESS, arguments: {
      'label': label,
      'address': address,
      'pos_code': posCode,
      'lat': latitude,
      'lng': longitude
    });
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }
}
