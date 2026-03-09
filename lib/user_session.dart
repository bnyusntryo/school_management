class UserSession {
  static String currentRole = 'Teacher';

  static String currentUserName = 'Bpk. Alexander';

  static void switchUser(String role) {
    currentRole = role;
    if (role == 'Principal') {
      currentUserName = 'Kristo William';
    } else if (role == 'Teacher') {
      currentUserName = 'Bpk. Alexander';
    } else if (role == 'Student') {
      currentUserName = 'Yoga Pratama';
    }
  }
}