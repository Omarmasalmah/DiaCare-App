import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import 'package:url_launcher/url_launcher.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final MapController _mapController = MapController();
  latLng2.LatLng _currentPosition = const latLng2.LatLng(31.9066, 35.2033);
  final bool _isLoading = true;
  bool _isMapReady = false;

  final List<Map<String, dynamic>> diabetesCenters = [
    {
      "name": "Palestine Diabetes Institute - Al-Bireh",
      "lat": 31.55629,
      "lng": 35.09967,
      "address": "Al-Bireh, West Bank",
      "description":
          "Established in 2009, PDI provides diabetes treatment, awareness, and education."
    },
    {
      "name": "Palestine Diabetes Institute - Nablus",
      "lat": 32.22428,
      "lng": 35.2539,
      "address": "Nablus, West Bank",
      "description":
          "This center extends PDI's services to the northern West Bank with full diabetes care."
    },
    {
      "name": "Diabetes Model Clinic - Al-Hakim Medical Center",
      "lat": 32.2567,
      "lng": 35.23492,
      "address":
          "Zawata Roundabout, 25th Street, next to Al-Ruwad Schools (previously), Nablus, Palestine",
      "description":
          "A specialized diabetes clinic under the supervision of Dr. Anan Abdelhaq, providing diabetes treatment and monitoring services.",
    },
    {
      "name": "Palestine Diabetes Institute - Hebron",
      "lat": 31.55624,
      "lng": 35.09975,
      "address": "Hebron, West Bank",
      "description":
          "Provides diabetes treatment and education for the southern West Bank region."
    },
    {
      "name": "Arab Specialized Care Hospital",
      "lat": 31.9056737,
      "lng": 35.2066929,
      "address": "Al-Nahda Street, Downtown, Ramallah, Palestine",
      "description":
          "A private hospital offering high-quality healthcare services with around 40 beds.",
    },
    {
      "name": "Istishari Arab Hospital",
      "lat": 31.933716,
      "lng": 35.1634095,
      "address": "Al-Rihan Suburb, Ramallah, Palestine",
      "description":
          "A private hospital offering comprehensive healthcare services across multiple specialties.",
    },
    {
      "name": "Augusta Victoria Hospital - Diabetes Care Clinic",
      "lat": 31.7853,
      "lng": 35.2445,
      "address": "Mount of Olives, Jerusalem",
      "description":
          "Specialized diabetes care, patient education, and management services."
    },
    {
      "name": "UNRWA Health Center - Balata Camp",
      "lat": 32.2211,
      "lng": 35.2544,
      "address": "Balata Refugee Camp, Nablus",
      "description":
          "Provides diabetes screening, treatment, and preventive healthcare services."
    },
    {
      "name": "UNRWA Health Center - Jenin Camp",
      "lat": 32.4595,
      "lng": 35.3009,
      "address": "Jenin Refugee Camp, Jenin",
      "description":
          "Comprehensive diabetes care, including regular monitoring and health education."
    },
    {
      "name": "UNRWA Health Center - Dheisheh Camp",
      "lat": 31.7054,
      "lng": 35.2024,
      "address": "Dheisheh Refugee Camp, Bethlehem",
      "description":
          "Focused on diabetes prevention and management among camp residents."
    },
    {
      "name": "Caritas Baby Hospital - Outpatient Clinic",
      "lat": 31.73197,
      "lng": 35.2032,
      "address": "Bethlehem, West Bank",
      "description":
          "Pediatric diabetes care, diagnosis, treatment, and family education services."
    },
    {
      "name": "PRCS Al-Bireh Hospital",
      "lat": 31.9098,
      "lng": 35.2034,
      "address": "Al-Bireh, Ramallah, Palestine",
      "description":
          "Established in 1965, this hospital offers a range of healthcare services to the residents of Al-Bireh and Ramallah.",
    },
    {
      "name": "PRCS Specialized Hospital - Hebron",
      "lat": 31.5241,
      "lng": 35.0938,
      "address": "Wadi Al-Tuffah, Hebron, Palestine",
      "description":
          "A specialized hospital focusing on maternal and child health, providing advanced medical care in Hebron.",
    },
    {
      "name": "PRCS Maternity Hospital - Jerusalem",
      "lat": 31.7767,
      "lng": 35.2345,
      "address": "Sheikh Jarrah, Jerusalem, Palestine",
      "description":
          "A leading institution in maternity and gynecological surgeries in Jerusalem, with a capacity of 40 beds.",
    },
    {
      "name": "Al-Makassed Islamic Charitable Hospital",
      "lat": 31.78096,
      "lng": 35.2420,
      "address": "Mount of Olives, Jerusalem",
      "description":
          "Diabetes care services including inpatient and outpatient management."
    },
    {
      "name": "St. Luke's Hospital - Diabetes Clinic",
      "lat": 32.2211,
      "lng": 35.2544,
      "address": "Nablus, West Bank",
      "description":
          "Offers comprehensive diabetes care, including patient education and support."
    },
    {
      "name": "Rafidia Surgical Hospital - Endocrinology Dept.",
      "lat": 32.2253,
      "lng": 35.2415,
      "address": "Nablus, West Bank",
      "description":
          "Specialized diabetes care for treatment and management of complications."
    },
    {
      "name": "Alia Governmental Hospital - Diabetes Unit",
      "lat": 31.5326,
      "lng": 35.0998,
      "address": "Hebron, West Bank",
      "description":
          "Provides diabetes management, including insulin therapy and dietary counseling."
    },
    {
      "name": "Jericho Governmental Hospital - Outpatient Clinic",
      "lat": 31.8667,
      "lng": 35.4500,
      "address": "Jericho, West Bank",
      "description":
          "Diabetes screening and treatment services for the local population."
    },
    {
      "name": "Tulkarem Governmental Hospital - Diabetes Clinic",
      "lat": 32.3104,
      "lng": 35.0286,
      "address": "Tulkarem, West Bank",
      "description":
          "Provides comprehensive diabetes care, including patient monitoring and education."
    },
    {
      "name": "Qalqilya Governmental Hospital - Endocrinology Dept.",
      "lat": 32.1967,
      "lng": 34.9706,
      "address": "Qalqilya, West Bank",
      "description": "Offers specialized diabetes care and management services."
    },
    {
      "name": "Salfit Governmental Hospital - Outpatient Services",
      "lat": 31.7114,
      "lng": 35.1975,
      "address": "Salfit, West Bank",
      "description":
          "Diabetes screening and treatment services for the community."
    },
    {
      "name": "Juzoor for Health and Social Development",
      "lat": 31.9066,
      "lng": 35.2033,
      "address": "Ramallah, West Bank",
      "description":
          "Health promotion programs focusing on diabetes prevention and management."
    },
    {
      "name": "Palestine Medical Complex - Endocrinology Department",
      "lat": 31.89964,
      "lng": 35.20561,
      "address": "Ramallah, West Bank",
      "description":
          "Provides advanced diabetes care and treatment for complex cases."
    },
    {
      "name": "An-Najah National University Hospital - Diabetes Center",
      "lat": 32.2211,
      "lng": 35.2544,
      "address": "Nablus, West Bank",
      "description":
          "Comprehensive diabetes care services, including research and patient education."
    },
    {
      "name": "Layan Skin & Beauty Clinic",
      "lat": 31.9066,
      "lng": 35.2033,
      "address": "Ramallah, Palestine",
      "description":
          "A modern clinic offering advanced skin and beauty treatments.",
    },
    {
      "name": "Elite Clinic - Medical Center",
      "lat": 31.89386,
      "lng": 35.20483,
      "address": "Al-Masyoun, Ramallah, Palestine",
      "description":
          "A medical center offering a range of healthcare services.",
    },
    {
      "name": "Hebron Charitable Medical Center",
      "lat": 31.5326,
      "lng": 35.0998,
      "address": "Hebron, West Bank",
      "description":
          "Provides community medical services, including diabetes care and management."
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeGeolocator();
  }

  // 📍 Initialize Geolocator
  Future<void> _initializeGeolocator() async {
    WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter bindings
    await GeolocatorPlatform.instance
        .checkPermission(); // ✅ Force initialize Geolocator

    setState(() {
      _isMapReady = true;
    });

    _getUserLocation(); // ✅ Fetch user location after initialization
  }

  // 📍 Get User's Current Location
  Future<void> _getUserLocation() async {
    if (!_isMapReady) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar("Location permission denied.");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition =
            latLng2.LatLng(position.latitude, position.longitude);
      });

      // Move the map to user's location
      _mapController.move(_currentPosition, 14);
    } catch (e) {
      _showSnackbar("Error fetching location: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diabetes Centers",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color.fromARGB(255, 41, 175, 45)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
          },
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 12,
          onMapReady: () {
            setState(() {
              _isMapReady = true;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/masalmah/cm6wkpn1v01bu01r5b0ls41ml/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFzYWxtYWgiLCJhIjoiY202d2s5aTdpMGlyczJrcXk1NXY5Z2ExaCJ9.hRCxbc-nJosr5sOUVH9Ldw',
            additionalOptions: const {
              'accessToken':
                  "pk.eyJ1IjoibWFzYWxtYWgiLCJhIjoiY202d2s5aTdpMGlyczJrcXk1NXY5Z2ExaCJ9.hRCxbc-nJosr5sOUVH9Ldw"
            },
          ),
          MarkerLayer(
            markers: [
              ...diabetesCenters
                  .map(
                    (center) => Marker(
                      point: latLng2.LatLng(center["lat"], center["lng"]),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _showCenterInfo(context, center),
                        child: const Icon(Icons.local_hospital,
                            color: Colors.red, size: 30),
                      ),
                    ),
                  )
                  .toList(),
              Marker(
                point: _currentPosition,
                width: 50,
                height: 50,
                child: const Icon(Icons.person_pin_circle,
                    color: Colors.blue, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _getUserLocation,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  // ℹ️ Show Diabetes Center Info
  void _showCenterInfo(BuildContext context, Map<String, dynamic> center) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(center["name"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 Address: ${center["address"]}"),
            const SizedBox(height: 8),
            Text("ℹ️ ${center["description"]}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openGoogleMaps(center["lat"], center["lng"]); // Open directions
            },
            child: const Text("Get Directions"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _openGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      _showSnackbar("Could not open Google Maps");
    }
  }
}
