import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapMarkerData {
  final double lat;
  final double lon;
  final String label;
  final String? partyId;

  MapMarkerData({
    required this.lat,
    required this.lon,
    required this.label,
    this.partyId,
  });
}

class KakaoMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final int zoomLevel;
  final List<MapMarkerData> markers;
  final bool interactive;
  final void Function(LatLng)? onTap;
  final void Function(String?)? onMarkerTap;

  const KakaoMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 200,
    this.zoomLevel = 3,
    this.markers = const [],
    this.interactive = true,
    this.onTap,
    this.onMarkerTap,
  });

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  KakaoMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void didUpdateWidget(covariant KakaoMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markers != widget.markers ||
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _updateMarkers();
      _mapController?.setCenter(
        LatLng(widget.latitude, widget.longitude),
      );
    }
  }

  void _updateMarkers() {
    final newMarkers = <Marker>{};
    for (final m in widget.markers) {
      newMarkers.add(Marker(
        markerId: m.partyId ?? '${m.lat}_${m.lon}',
        latLng: LatLng(m.lat, m.lon),
        infoWindowContent: m.label,
        infoWindowFirstShow: widget.markers.length == 1,
      ));
    }
    setState(() => _markers = newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    // Expanded must be a direct child of Flex (Column/Row)
    // When height is infinity, use Expanded directly; otherwise use SizedBox
    final mapContent = _buildMap();

    if (widget.height.isFinite) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: widget.height,
          child: mapContent,
        ),
      );
    } else {
      // Return map directly when height is infinity - parent must provide Flex context
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: mapContent,
      );
    }
  }

  Widget _buildMap() {
    return AbsorbPointer(
      absorbing: !widget.interactive,
      child: KakaoMap(
        center: LatLng(widget.latitude, widget.longitude),
        currentLevel: widget.zoomLevel,
        markers: _markers.toList(),
        onMapCreated: (controller) {
          _mapController = controller;
          _updateMarkers();
        },
        onMapTap: (latLng) {
          widget.onTap?.call(latLng);
        },
        onMarkerTap: (markerId, latLng, zoomLevel) {
          widget.onMarkerTap?.call(markerId);
        },
      ),
    );
  }
}
