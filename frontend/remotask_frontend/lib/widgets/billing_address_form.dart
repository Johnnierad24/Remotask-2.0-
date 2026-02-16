import 'package:flutter/material.dart';

class BillingAddressValidator {
  /// Country-specific postcode/zip code patterns
  static final Map<String, RegExp> postcodePatterns = {
    'US': RegExp(r'^\d{5}(-\d{4})?$'), // US ZIP code
    'UK': RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$', caseSensitive: false), // UK postcode
    'CA': RegExp(r'^[A-Z]\d[A-Z] ?\d[A-Z]\d$', caseSensitive: false), // Canada
    'AU': RegExp(r'^\d{4}$'), // Australia
    'KE': RegExp(r'^\d{5}$'), // Kenya
    'NG': RegExp(r'^\d{6}$'), // Nigeria
    'DE': RegExp(r'^\d{5}$'), // Germany
    'FR': RegExp(r'^\d{5}$'), // France
    'IN': RegExp(r'^\d{6}$'), // India
  };

  /// Country-specific required fields
  static final Map<String, List<String>> requiredFields = {
    'US': ['street', 'city', 'state', 'postcode'],
    'UK': ['street', 'city', 'postcode'],
    'CA': ['street', 'city', 'province', 'postcode'],
    'KE': ['street', 'city'],
    'NG': ['street', 'city', 'state'],
  };

  /// Validates postcode based on country
  static String? validatePostcode(String? value, String countryCode) {
    if (value == null || value.isEmpty) {
      // Check if postcode is required for this country
      final required = requiredFields[countryCode]?.contains('postcode') ?? false;
      if (required) return 'Postcode is required';
      return null;
    }

    final pattern = postcodePatterns[countryCode];
    if (pattern != null && !pattern.hasMatch(value)) {
      return 'Invalid postcode format for $countryCode';
    }
    return null;
  }

  /// Validates all billing address fields
  static Map<String, String?> validateAddress({
    required String countryCode,
    String? street,
    String? city,
    String? state,
    String? postcode,
  }) {
    final errors = <String, String?>{};
    final required = requiredFields[countryCode] ?? ['street', 'city'];

    if (required.contains('street') && (street == null || street.isEmpty)) {
      errors['street'] = 'Street address is required';
    }
    if (required.contains('city') && (city == null || city.isEmpty)) {
      errors['city'] = 'City is required';
    }
    if (required.contains('state') && (state == null || state.isEmpty)) {
      errors['state'] = 'State/Province is required';
    }
    if (required.contains('postcode')) {
      errors['postcode'] = validatePostcode(postcode, countryCode);
    }

    return errors;
  }
}

class BillingAddressForm extends StatefulWidget {
  final String initialCountry;
  final Function(Map<String, String>) onAddressChanged;

  const BillingAddressForm({
    Key? key,
    this.initialCountry = 'US',
    required this.onAddressChanged,
  }) : super(key: key);

  @override
  State<BillingAddressForm> createState() => _BillingAddressFormState();
}

class _BillingAddressFormState extends State<BillingAddressForm> {
  late String _selectedCountry;
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postcodeController = TextEditingController();
  Map<String, String?> _errors = {};

  static const List<Map<String, String>> countries = [
    {'code': 'US', 'name': 'United States'},
    {'code': 'UK', 'name': 'United Kingdom'},
    {'code': 'CA', 'name': 'Canada'},
    {'code': 'AU', 'name': 'Australia'},
    {'code': 'KE', 'name': 'Kenya'},
    {'code': 'NG', 'name': 'Nigeria'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'IN', 'name': 'India'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  void _validateAndNotify() {
    _errors = BillingAddressValidator.validateAddress(
      countryCode: _selectedCountry,
      street: _streetController.text,
      city: _cityController.text,
      state: _stateController.text,
      postcode: _postcodeController.text,
    );
    setState(() {});

    widget.onAddressChanged({
      'country': _selectedCountry,
      'street': _streetController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'postcode': _postcodeController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final requiredFields = BillingAddressValidator.requiredFields[_selectedCountry] ?? ['street', 'city'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          decoration: const InputDecoration(
            labelText: 'Country or region',
            border: OutlineInputBorder(),
          ),
          items: countries.map((c) => DropdownMenuItem(
            value: c['code'],
            child: Text(c['name']!),
          )).toList(),
          onChanged: (val) {
            setState(() => _selectedCountry = val!);
            _validateAndNotify();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _streetController,
          decoration: InputDecoration(
            labelText: 'Street address',
            border: const OutlineInputBorder(),
            errorText: _errors['street'],
          ),
          onChanged: (_) => _validateAndNotify(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'City',
            border: const OutlineInputBorder(),
            errorText: _errors['city'],
          ),
          onChanged: (_) => _validateAndNotify(),
        ),
        if (requiredFields.contains('state') || requiredFields.contains('province')) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _stateController,
            decoration: InputDecoration(
              labelText: _selectedCountry == 'CA' ? 'Province' : 'State',
              border: const OutlineInputBorder(),
              errorText: _errors['state'],
            ),
            onChanged: (_) => _validateAndNotify(),
          ),
        ],
        if (requiredFields.contains('postcode')) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _postcodeController,
            decoration: InputDecoration(
              labelText: _selectedCountry == 'US' ? 'ZIP code' : 'Postcode',
              border: const OutlineInputBorder(),
              errorText: _errors['postcode'],
            ),
            onChanged: (_) => _validateAndNotify(),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }
}
