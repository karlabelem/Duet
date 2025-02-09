 /* This file is for user data...
  *
  *
  */

import 'package:uuid/uuid.dart';

class UserProfileData {
  final String _uuid;  // Private unique user ID
  final String name, dob, location; // Public fields: name, date of birth, location
  
  // Create an instance of the Uuid class
  static final _uuidGen = Uuid();

  // Constructor Method
  UserProfileData({
    required this.name,
    required this.dob,
    required this.location
  }) :   this._uuid = _uuidGen.v4(); // Generate and assign a UUID

  // Getter for _uuid (to allow read access)
  String get uuid => _uuid;

}