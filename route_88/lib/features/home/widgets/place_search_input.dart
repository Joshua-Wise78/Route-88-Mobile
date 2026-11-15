import 'dart:async';

import 'package:flutter/material.dart';
import 'package:route_88/features/home/utils/map_theme.dart';
import 'package:route_88/features/routing/models/coordinate.dart';
import 'package:route_88/features/routing/models/place.dart';
import 'package:route_88/features/routing/repositories/routing_repository.dart';

/// An autocomplete search input that queries Nominatim places via
/// [RoutingRepository].
class PlaceSearchInput extends StatefulWidget {
  const PlaceSearchInput({
    required this.routingRepository,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.iconColor,
    required this.onPlaceSelected,
    this.onCleared,
    super.key,
  });

  final RoutingRepository routingRepository;
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final ValueChanged<Place> onPlaceSelected;
  final VoidCallback? onCleared;

  @override
  State<PlaceSearchInput> createState() => _PlaceSearchInputState();
}

class _PlaceSearchInputState extends State<PlaceSearchInput> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  List<Place> _suggestions = const [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && mounted && _suggestions.isNotEmpty) {
      setState(() => _suggestions = const []);
    }
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    final query = value.trim();

    // Check if user entered raw coordinates: e.g. "39.9612, -83.0019"
    final coordRegex = RegExp(r'^(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)$');
    final match = coordRegex.firstMatch(query);
    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        widget.onPlaceSelected(
          Place(
            id: 'manual_coord',
            displayName: query,
            coordinate: Coordinate(lat: lat, lng: lng),
          ),
        );
        setState(() => _suggestions = const []);
        return;
      }
    }

    if (query.length < 2) {
      setState(() {
        _suggestions = const [];
        _isLoading = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      setState(() => _isLoading = true);

      try {
        final places = await widget.routingRepository.searchPlaces(query);
        if (mounted) {
          setState(() {
            _suggestions = places;
            _isLoading = false;
          });
        }
      } on Exception catch (_) {
        if (mounted) {
          setState(() {
            _suggestions = const [];
            _isLoading = false;
          });
        }
      }
    });
  }

  void _clearInput() {
    widget.controller.clear();
    widget.onCleared?.call();
    setState(() => _suggestions = const []);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon:
                Icon(widget.prefixIcon, color: widget.iconColor, size: 20),
            suffixIcon: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : widget.controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: _clearInput,
                      )
                    : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MapTheme.primary, width: 2),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 180),
            child: Material(
              color: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final place = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: MapTheme.primary,
                      size: 18,
                    ),
                    title: Text(
                      place.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      '${place.coordinate.lat.toStringAsFixed(4)}, '
                      '${place.coordinate.lng.toStringAsFixed(4)}',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                    onTap: () {
                      widget.controller.text = place.displayName;
                      widget.onPlaceSelected(place);
                      _focusNode.unfocus();
                      setState(() => _suggestions = const []);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
