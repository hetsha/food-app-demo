/// Local data source for Indian states/UTs and their cities.
///
/// Maintained as a single const map so it can be updated easily without
/// touching any UI code. No network request is needed to open the
/// State/City selectors.
class IndiaLocations {
  const IndiaLocations._();

  /// States/UTs mapped to their cities (insertion order = display order).
  static const Map<String, List<String>> statesWithCities = {
    'Andhra Pradesh': [
      'Visakhapatnam',
      'Vijayawada',
      'Guntur',
      'Nellore',
      'Tirupati',
      'Kurnool',
      'Rajahmundry',
      'Kakinada',
      'Anantapur',
      'Kadapa',
      'Eluru',
      'Ongole',
      'Srikakulam',
      'Vizianagaram',
      'Machilipatnam',
    ],
    'Arunachal Pradesh': [
      'Itanagar',
      'Naharlagun',
      'Pasighat',
      'Tawang',
      'Ziro',
      'Bomdila',
      'Tezu',
      'Along',
      'Changlang',
      'Roing',
    ],
    'Assam': [
      'Guwahati',
      'Silchar',
      'Dibrugarh',
      'Jorhat',
      'Nagaon',
      'Tinsukia',
      'Tezpur',
      'Bongaigaon',
      'Dhubri',
      'Diphu',
      'North Lakhimpur',
    ],
    'Bihar': [
      'Patna',
      'Gaya',
      'Bhagalpur',
      'Muzaffarpur',
      'Darbhanga',
      'Purnia',
      'Ara',
      'Begusarai',
      'Chhapra',
      'Katihar',
      'Munger',
      'Saharsa',
    ],
    'Chhattisgarh': [
      'Raipur',
      'Bhilai',
      'Bilaspur',
      'Korba',
      'Durg',
      'Rajnandgaon',
      'Jagdalpur',
      'Raigarh',
      'Ambikapur',
      'Dhamtari',
    ],
    'Goa': [
      'Panaji',
      'Margao',
      'Vasco da Gama',
      'Mapusa',
      'Ponda',
      'Bicholim',
      'Curchorem',
      'Canacona',
      'Valpoi',
      'Cuncolim',
    ],
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Gandhinagar',
      'Bhavnagar',
      'Jamnagar',
      'Junagadh',
      'Anand',
      'Mehsana',
      'Bharuch',
      'Navsari',
      'Vapi',
      'Porbandar',
      'Surendranagar',
      'Morbi',
      'Nadiad',
      'Dahod',
      'Gandhidham',
      'Bhuj',
      'Amreli',
      'Botad',
      'Deesa',
      'Himatnagar',
      'Palanpur',
      'Sanand',
    ],
    'Haryana': [
      'Gurugram',
      'Faridabad',
      'Panipat',
      'Ambala',
      'Yamunanagar',
      'Rohtak',
      'Hisar',
      'Karnal',
      'Sonipat',
      'Panchkula',
      'Bhiwani',
      'Sirsa',
      'Bahadurgarh',
      'Rewari',
      'Nuh',
      'Palwal',
    ],
    'Himachal Pradesh': [
      'Shimla',
      'Solan',
      'Dharamshala',
      'Mandi',
      'Kullu',
      'Manali',
      'Baddi',
      'Nahan',
      'Paonta Sahib',
      'Sundarnagar',
      'Una',
      'Hamirpur',
      'Chamba',
      'Bilaspur',
    ],
    'Jharkhand': [
      'Ranchi',
      'Jamshedpur',
      'Dhanbad',
      'Bokaro Steel City',
      'Deoghar',
      'Hazaribagh',
      'Giridih',
      'Ramgarh',
      'Chas',
      'Dumka',
      'Phusro',
      'Adityapur',
    ],
    'Karnataka': [
      'Bengaluru',
      'Mysuru',
      'Hubballi',
      'Mangaluru',
      'Belagavi',
      'Davanagere',
      'Ballari',
      'Vijayapura',
      'Kalaburagi',
      'Shivamogga',
      'Tumakuru',
      'Raichur',
      'Bidar',
      'Udupi',
      'Hassan',
      'Mandya',
      'Chitradurga',
      'Kolar',
      'Gadag',
      'Karwar',
      'Bagalkote',
      'Haveri',
    ],
    'Kerala': [
      'Thiruvananthapuram',
      'Kochi',
      'Kozhikode',
      'Thrissur',
      'Kollam',
      'Alappuzha',
      'Palakkad',
      'Kannur',
      'Kottayam',
      'Malappuram',
      'Pathanamthitta',
      'Idukki',
      'Kasaragod',
      'Guruvayur',
    ],
    'Madhya Pradesh': [
      'Bhopal',
      'Indore',
      'Jabalpur',
      'Gwalior',
      'Ujjain',
      'Sagar',
      'Dewas',
      'Satna',
      'Ratlam',
      'Rewa',
      'Katni',
      'Singrauli',
      'Burhanpur',
      'Khandwa',
      'Morena',
      'Chhindwara',
      'Guna',
      'Shivpuri',
      'Vidisha',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Thane',
      'Nashik',
      'Chhatrapati Sambhajinagar',
      'Aurangabad',
      'Solapur',
      'Kolhapur',
      'Amravati',
      'Navi Mumbai',
      'Kalyan',
      'Dombivli',
      'Vasai',
      'Virar',
      'Malegaon',
      'Jalgaon',
      'Bhusawal',
      'Akola',
      'Latur',
      'Dhule',
      'Chandrapur',
      'Nanded',
    ],
    'Manipur': [
      'Imphal',
      'Thoubal',
      'Bishnupur',
      'Churachandpur',
      'Kakching',
      'Ukhrul',
      'Senapati',
      'Tamenglong',
      'Jiribam',
    ],
    'Meghalaya': [
      'Shillong',
      'Tura',
      'Jowai',
      'Nongstoin',
      'Baghmara',
      'Williamnagar',
      'Mawkyrwat',
      'Resubelpara',
    ],
    'Mizoram': [
      'Aizawl',
      'Lunglei',
      'Champhai',
      'Serchhip',
      'Kolasib',
      'Lawngtlai',
      'Saiha',
      'Mamit',
      'Khawzawl',
    ],
    'Nagaland': [
      'Kohima',
      'Dimapur',
      'Mokokchung',
      'Tuensang',
      'Wokha',
      'Zunheboto',
      'Mon',
      'Phek',
      'Kiphire',
      'Longleng',
    ],
    'Odisha': [
      'Bhubaneswar',
      'Cuttack',
      'Rourkela',
      'Brahmapur',
      'Sambalpur',
      'Puri',
      'Balasore',
      'Bhadrak',
      'Baripada',
      'Jharsuguda',
      'Angul',
      'Dhenkanal',
      'Kendrapara',
    ],
    'Punjab': [
      'Ludhiana',
      'Amritsar',
      'Jalandhar',
      'Patiala',
      'Bathinda',
      'Hoshiarpur',
      'Mohali',
      'Batala',
      'Pathankot',
      'Moga',
      'Abohar',
      'Malerkotla',
      'Khanna',
      'Phagwara',
      'Muktsar',
      'Barnala',
      'Firozpur',
    ],
    'Rajasthan': [
      'Jaipur',
      'Jodhpur',
      'Udaipur',
      'Kota',
      'Bikaner',
      'Ajmer',
      'Bhilwara',
      'Alwar',
      'Sikar',
      'Bharatpur',
      'Pali',
      'Sri Ganganagar',
      'Tonk',
      'Kishangarh',
      'Beawar',
      'Hanumangarh',
      'Sawai Madhopur',
    ],
    'Sikkim': [
      'Gangtok',
      'Namchi',
      'Gyalshing',
      'Mangan',
      'Rangpo',
      'Singtam',
      'Jorethang',
      'Chungthang',
    ],
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tirunelveli',
      'Tiruppur',
      'Vellore',
      'Erode',
      'Thoothukudi',
      'Dindigul',
      'Thanjavur',
      'Ramanathapuram',
      'Kanchipuram',
      'Hosur',
      'Nagercoil',
      'Kumbakonam',
      'Cuddalore',
      'Jolarpettai',
      'Tiruvannamalai',
    ],
    'Telangana': [
      'Hyderabad',
      'Warangal',
      'Nizamabad',
      'Karimnagar',
      'Khammam',
      'Ramagundam',
      'Mahbubnagar',
      'Nalgonda',
      'Adilabad',
      'Suryapet',
      'Miryalagonda',
      'Jagtial',
      'Peddapalli',
    ],
    'Tripura': [
      'Agartala',
      'Udaipur',
      'Dharmanagar',
      'Kailashahar',
      'Belonia',
      'Ambassa',
      'Khowai',
      'Teliamura',
      'Sonamura',
    ],
    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Agra',
      'Varanasi',
      'Prayagraj',
      'Meerut',
      'Bareilly',
      'Aligarh',
      'Moradabad',
      'Saharanpur',
      'Gorakhpur',
      'Noida',
      'Ghaziabad',
      'Jhansi',
      'Mathura',
      'Ayodhya',
      'Rampur',
      'Shahjahanpur',
      'Muzaffarnagar',
      'Firozabad',
      'Basti',
      'Deoria',
      'Etawah',
      'Farrukhabad',
      'Mirzapur',
      'Unnao',
      'Bulandshahr',
      'Badaun',
      'Gonda',
      'Bahraich',
    ],
    'Uttarakhand': [
      'Dehradun',
      'Haridwar',
      'Roorkee',
      'Haldwani',
      'Rudrapur',
      'Kashipur',
      'Rishikesh',
      'Nainital',
      'Almora',
      'Pithoragarh',
      'Kotdwar',
      'Manglaur',
      'Kichha',
      'Sitarganj',
    ],
    'West Bengal': [
      'Kolkata',
      'Howrah',
      'Asansol',
      'Siliguri',
      'Durgapur',
      'Bardhaman',
      'Malda',
      'Kharagpur',
      'Haldia',
      'Darjeeling',
      'Jalpaiguri',
      'Baharampur',
      'Krishnanagar',
      'Shantipur',
    ],
    'Andaman and Nicobar Islands': [
      'Port Blair',
      'Car Nicobar',
      'Mayabunder',
      'Rangat',
      'Diglipur',
      'Hut Bay',
    ],
    'Chandigarh': ['Chandigarh'],
    'Dadra and Nagar Haveli and Daman and Diu': [
      'Daman',
      'Diu',
      'Silvassa',
    ],
    'Delhi': [
      'New Delhi',
      'Delhi',
      'Dwarka',
      'Rohini',
      'Karol Bagh',
      'Saket',
      'Janakpuri',
      'Lajpat Nagar',
      'Pitampura',
      'Mayur Vihar',
    ],
    'Jammu and Kashmir': [
      'Srinagar',
      'Jammu',
      'Anantnag',
      'Baramulla',
      'Udhampur',
      'Kathua',
      'Sopore',
      'Rajouri',
      'Poonch',
      'Doda',
      'Kishtwar',
      'Kulgam',
      'Budgam',
    ],
    'Ladakh': [
      'Leh',
      'Kargil',
      'Nubra',
      'Zanskar',
      'Hemis',
    ],
    'Lakshadweep': [
      'Kavaratti',
      'Agatti',
      'Amini',
      'Andrott',
      'Minicoy',
      'Kadmat',
    ],
    'Puducherry': [
      'Puducherry',
      'Karaikal',
      'Mahe',
      'Yanam',
    ],
  };

  /// All states/UTs in display order.
  static List<String> get states => statesWithCities.keys.toList();

  /// Cities for [state]; empty when the state is unknown/empty.
  static List<String> citiesFor(String state) {
    final key = _normalize(state);
    if (key.isEmpty) return const [];
    for (final entry in statesWithCities.entries) {
      if (_normalize(entry.key) == key) return entry.value;
    }
    return const [];
  }

  /// Matches a free-form state name (e.g. from reverse geocoding) against
  /// the dataset and returns the canonical name, or null when not found.
  static String? matchState(String raw) {
    final query = _normalize(raw);
    if (query.isEmpty) return null;
    for (final name in statesWithCities.keys) {
      if (_normalize(name) == query) return name;
    }
    for (final name in statesWithCities.keys) {
      final normalized = _normalize(name);
      if (normalized.contains(query) || query.contains(normalized)) {
        return name;
      }
    }
    return null;
  }

  /// Matches a free-form city name against [state]'s cities and returns the
  /// canonical name, or null when not found.
  static String? matchCity(String state, String raw) {
    final query = _normalize(raw);
    if (query.isEmpty) return null;
    for (final city in citiesFor(state)) {
      if (_normalize(city) == query) return city;
    }
    for (final city in citiesFor(state)) {
      final normalized = _normalize(city);
      if (normalized.contains(query) || query.contains(normalized)) {
        return city;
      }
    }
    return null;
  }

  /// Finds which state contains [city], or null when the city is not in the
  /// dataset. Used to detect geocoded cities that belong to another state.
  static String? findStateForCity(String city) {
    final query = _normalize(city);
    if (query.isEmpty) return null;
    for (final entry in statesWithCities.entries) {
      for (final candidate in entry.value) {
        if (_normalize(candidate) == query) return entry.key;
      }
    }
    for (final entry in statesWithCities.entries) {
      for (final candidate in entry.value) {
        final normalized = _normalize(candidate);
        if (normalized.contains(query) || query.contains(normalized)) {
          return entry.key;
        }
      }
    }
    return null;
  }

  static String _normalize(String value) {
    final trimmed = value.trim().toLowerCase();
    final commaIndex = trimmed.indexOf(',');
    return (commaIndex >= 0 ? trimmed.substring(0, commaIndex) : trimmed)
        .trim();
  }
}
