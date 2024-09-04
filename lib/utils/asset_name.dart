class AnimationAddress {
  static const String main = 'assets/animations/';
  static String notFound = getName('not-found.json');
  static String getName(String name) => '$main$name';
}
