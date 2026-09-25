import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/features/address/data/models/india_locations.dart';

void main() {
  group('IndiaLocations.states', () {
    test('includes all major states and UTs', () {
      final states = IndiaLocations.states;
      expect(states, contains('Gujarat'));
      expect(states, contains('Maharashtra'));
      expect(states, contains('Delhi'));
      expect(states, contains('West Bengal'));
      expect(states, contains('Tamil Nadu'));
      expect(states.length, greaterThanOrEqualTo(36));
    });

    test('is not limited to Ahmedabad/Gujarat', () {
      expect(IndiaLocations.states.length, greaterThan(30));
    });
  });

  group('IndiaLocations.citiesFor', () {
    test('Gujarat cities include Ahmedabad and Surat', () {
      final cities = IndiaLocations.citiesFor('Gujarat');
      expect(cities, contains('Ahmedabad'));
      expect(cities, contains('Surat'));
      expect(cities, contains('Vadodara'));
      expect(cities, contains('Rajkot'));
      expect(cities, contains('Gandhinagar'));
      expect(cities.length, greaterThan(10));
    });

    test('Maharashtra cities include Mumbai but not Ahmedabad', () {
      final cities = IndiaLocations.citiesFor('Maharashtra');
      expect(cities, contains('Mumbai'));
      expect(cities, isNot(contains('Ahmedabad')));
    });

    test('is case-insensitive and trims input', () {
      expect(IndiaLocations.citiesFor(' gujarat '), isNotEmpty);
      expect(IndiaLocations.citiesFor('GUJARAT'), isNotEmpty);
    });

    test('returns empty for unknown or blank state', () {
      expect(IndiaLocations.citiesFor('Atlantis'), isEmpty);
      expect(IndiaLocations.citiesFor(''), isEmpty);
    });
  });

  group('IndiaLocations.matchState', () {
    test('matches exact and partial names case-insensitively', () {
      expect(IndiaLocations.matchState('Gujarat'), 'Gujarat');
      expect(IndiaLocations.matchState('gujarat'), 'Gujarat');
      expect(IndiaLocations.matchState('  Gujarat  '), 'Gujarat');
      expect(IndiaLocations.matchState('Guja'), 'Gujarat');
      expect(IndiaLocations.matchState('Maharashtra'), 'Maharashtra');
    });

    test('returns null for unknown states', () {
      expect(IndiaLocations.matchState('Atlantis'), isNull);
      expect(IndiaLocations.matchState(''), isNull);
    });
  });

  group('IndiaLocations.matchCity', () {
    test('matches within the given state only', () {
      expect(IndiaLocations.matchCity('Gujarat', 'Ahmedabad'), 'Ahmedabad');
      expect(IndiaLocations.matchCity('Gujarat', 'ahm'), 'Ahmedabad');
      expect(
        IndiaLocations.matchCity('Maharashtra', 'Mumbai'),
        'Mumbai',
      );
      expect(
        IndiaLocations.matchCity('Maharashtra', 'Ahmedabad'),
        isNull,
      );
    });

    test('returns null for unknown city or blank state', () {
      expect(IndiaLocations.matchCity('Gujarat', 'Wakanda'), isNull);
      expect(IndiaLocations.matchCity('', 'Ahmedabad'), isNull);
    });
  });

  group('IndiaLocations.findStateForCity', () {
    test('finds the owning state for a known city', () {
      expect(IndiaLocations.findStateForCity('Ahmedabad'), 'Gujarat');
      expect(IndiaLocations.findStateForCity('Mumbai'), 'Maharashtra');
      expect(IndiaLocations.findStateForCity('Kolkata'), 'West Bengal');
    });

    test('returns null when the city is not in the dataset', () {
      expect(IndiaLocations.findStateForCity('Wakanda'), isNull);
      expect(IndiaLocations.findStateForCity(''), isNull);
    });
  });
}
