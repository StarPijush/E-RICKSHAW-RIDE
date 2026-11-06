import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/features/location/domain/location_model.dart';

/// E-GO mock data for development.
/// Clearly separated from future API integration.
/// Location: Jhargram, West Bengal, India.
abstract class MockData {
  // Jhargram, West Bengal coordinates
  static const LatLng jhargramCenter = LatLng(22.4529, 86.9003);

  // Mock current location (Jhargram Station area)
  static const LatLng mockCurrentLocation = LatLng(22.4550, 86.9020);

  // Mock recent destinations
  static const List<RecentDestination> recentDestinations = [
    RecentDestination(
      id: '1',
      label: 'Jhargram Bazar',
      subtitle: 'Market area',
      coordinate: LatLng(22.4701, 86.9152),
      icon: Icons.store,
      type: PlaceType.market,
    ),
    RecentDestination(
      id: '2',
      label: 'Jhargram Railway Station',
      subtitle: 'Station Road',
      coordinate: LatLng(22.4529, 86.9003),
      icon: Icons.train,
      type: PlaceType.transport,
    ),
    RecentDestination(
      id: '3',
      label: 'Jhargram Palace',
      subtitle: 'Tourist spot',
      coordinate: LatLng(22.4480, 86.8950),
      icon: Icons.account_balance,
      type: PlaceType.landmark,
    ),
    RecentDestination(
      id: '4',
      label: 'Kendua Market',
      subtitle: 'Local market',
      coordinate: LatLng(22.4650, 86.9100),
      icon: Icons.shopping_basket,
      type: PlaceType.market,
    ),
  ];

  // Mock suggested/searchable places
  static const List<SuggestedPlace> suggestedPlaces = [
    SuggestedPlace(
      id: 's1',
      name: 'Jhargram Bazar',
      address: 'Market area, Jhargram',
      coordinate: LatLng(22.4701, 86.9152),
      type: PlaceType.market,
    ),
    SuggestedPlace(
      id: 's2',
      name: 'Jhargram Railway Station',
      address: 'Station Road, Jhargram',
      coordinate: LatLng(22.4529, 86.9003),
      type: PlaceType.transport,
    ),
    SuggestedPlace(
      id: 's3',
      name: 'Jhargram Palace',
      address: 'Palace Road, Jhargram',
      coordinate: LatLng(22.4480, 86.8950),
      type: PlaceType.landmark,
    ),
    SuggestedPlace(
      id: 's4',
      name: 'Kendua Market',
      address: 'Kendua, Jhargram',
      coordinate: LatLng(22.4650, 86.9100),
      type: PlaceType.market,
    ),
    SuggestedPlace(
      id: 's5',
      name: 'Jhargram Medical College',
      address: 'Khasjangal, Jhargram',
      coordinate: LatLng(22.4400, 86.8800),
      type: PlaceType.hospital,
    ),
    SuggestedPlace(
      id: 's6',
      name: 'Jhargram Bus Stand',
      address: 'Bus Stand Road, Jhargram',
      coordinate: LatLng(22.4580, 86.9050),
      type: PlaceType.transport,
    ),
    SuggestedPlace(
      id: 's7',
      name: 'Jhargram College',
      address: 'College Road, Jhargram',
      coordinate: LatLng(22.4610, 86.9120),
      type: PlaceType.education,
    ),
    SuggestedPlace(
      id: 's8',
      name: 'Belpahari',
      address: 'NH-6, Jhargram district',
      coordinate: LatLng(22.5200, 86.9500),
      type: PlaceType.other,
    ),
    SuggestedPlace(
      id: 's9',
      name: 'Lodhasuli',
      address: 'Lodhasuli, Jhargram',
      coordinate: LatLng(22.4350, 86.8700),
      type: PlaceType.residential,
    ),
    SuggestedPlace(
      id: 's10',
      name: 'Binpur',
      address: 'Binpur, Jhargram district',
      coordinate: LatLng(22.5600, 87.0200),
      type: PlaceType.other,
    ),
    SuggestedPlace(
      id: 's11',
      name: 'Sankrail',
      address: 'Sankrail, Jhargram',
      coordinate: LatLng(22.4150, 86.8600),
      type: PlaceType.other,
    ),
    SuggestedPlace(
      id: 's12',
      name: 'Jamboni',
      address: 'Jamboni, Jhargram district',
      coordinate: LatLng(22.5000, 86.9800),
      type: PlaceType.other,
    ),
  ];

  // Saved home/work locations placeholder
  static const SavedPlace homePlace = SavedPlace(
    id: 'home',
    label: 'Home',
    address: 'Add home address',
    icon: Icons.home,
    type: SavedPlaceType.home,
  );

  static const SavedPlace workPlace = SavedPlace(
    id: 'work',
    label: 'Work',
    address: 'Add work address',
    icon: Icons.work,
    type: SavedPlaceType.work,
  );

  // FAQ for Help & Support
  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'How do I book a ride?',
      answer:
          'Open the app, enter your destination, choose a vehicle (Bike or Toto), and confirm your booking. A driver will be matched to you.',
    ),
    FaqItem(
      question: 'How is the fare calculated?',
      answer:
          'Fares are based on distance and vehicle type. Bike rides start at ₹20 + ₹10/km. Toto rides start at ₹15 + ₹7/km. A small platform fee applies.',
    ),
    FaqItem(
      question: 'Can I cancel a ride?',
      answer:
          'Yes, you can cancel before the driver arrives. Once the trip starts, cancellation is not available.',
    ),
    FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'Currently cash is accepted. UPI and card payments will be available soon.',
    ),
    FaqItem(
      question: 'How do I contact my driver?',
      answer:
          'Once a driver is assigned, you can call them from the driver details screen.',
    ),
    FaqItem(
      question: 'What is a Toto?',
      answer:
          'A Toto is an electric rickshaw (E-Rickshaw) that can carry up to 3 passengers. It is a popular and affordable mode of transport in Jhargram.',
    ),
    FaqItem(
      question: 'Is E-GO available 24/7?',
      answer:
          'E-GO operates from 6:00 AM to 10:00 PM. Hours may expand as the service grows.',
    ),
  ];
}

class RecentDestination {
  const RecentDestination({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.coordinate,
    required this.icon,
    required this.type,
  });

  final String id;
  final String label;
  final String subtitle;
  final LatLng coordinate;
  final IconData icon;
  final PlaceType type;
}

class SuggestedPlace {
  const SuggestedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinate,
    required this.type,
  });

  final String id;
  final String name;
  final String address;
  final LatLng coordinate;
  final PlaceType type;
}

enum SavedPlaceType { home, work, other }

class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.label,
    required this.address,
    required this.icon,
    required this.type,
    this.coordinate,
  });

  final String id;
  final String label;
  final String address;
  final IconData icon;
  final SavedPlaceType type;
  final LatLng? coordinate;

  bool get isSet => coordinate != null;

  SavedPlace copyWith({
    String? id,
    String? label,
    String? address,
    IconData? icon,
    SavedPlaceType? type,
    LatLng? coordinate,
  }) {
    return SavedPlace(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      coordinate: coordinate ?? this.coordinate,
    );
  }
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}
