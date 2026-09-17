import 'package:flutter/material.dart';
import 'package:merchent/utils/app_size.dart';
import 'package:merchent/widget/text_field_widget/text_field_widget.dart';

import '../../../../constant/app_color/app_color.dart';
import '../controller/location_controller.dart';

class LocationFormSection extends StatelessWidget {
  const LocationFormSection({super.key, required this.controller});

  final LocationController controller;

  @override
  Widget build(BuildContext context) {
    final suggestions = controller.searchResults;
    final isLoadingLocation = controller.isLoadingLocation;
    final mapPreviewUrl = controller.mapPreviewUrl;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: isLoadingLocation ? null : controller.useCurrentLocation,
          child: Container(
            width: double.infinity,
            height: 54,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: ShapeDecoration(
              color: const Color(0xFFD7F4DE),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF198248)),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.my_location, color: const Color(0xFF198248)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isLoadingLocation
                        ? 'Fetching current location...'
                        : 'Use Current Location',
                    style: const TextStyle(
                      color: Color(0xFF181818),
                      fontSize: 14,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isLoadingLocation)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSize.height(value: 20)),
        TextFieldWidget(
          controller: controller.inputLocation,
          hintText: 'Enter a new address',
          borderColor: const Color(0xFF198248),
          focusedBorderColor: const Color(0xFF198248),
          prefixIcon: const Icon(Icons.location_on, color: Color(0xFF198248)),
          customSuffixIcon: controller.inputLocation.text.isEmpty
              ? null
              : IconButton(
                  onPressed: controller.clearInputField,
                  icon: const Icon(Icons.cancel, color: Color(0xFF198248)),
                ),
        ),
        if (controller.isSearchingAddress)
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Searching address...'),
              ],
            ),
          ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4FBF6),
              border: Border.all(
                color: const Color(0xFF198248).withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    'Suggestions from Google Maps',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF198248),
                    ),
                  ),
                ),
                ...suggestions.take(5).map((suggestion) {
                  return ListTile(
                    leading: const Icon(
                      Icons.location_pin,
                      color: Color(0xFF198248),
                    ),
                    title: Text(
                      suggestion.address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF198248),
                      ),
                    ),
                    subtitle: Text(
                      'Lat: ${suggestion.latitude.toStringAsFixed(4)}, Lng: ${suggestion.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF198248),
                      ),
                    ),
                    onTap: () => controller.onSuggestionTap(suggestion),
                  );
                }),
              ],
            ),
          ),
      
      ],
    );
  }
}
