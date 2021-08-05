class Person {
  String _name = "";
  String _bio = "";
  List<String> _interests = [];

  String getName() {
    return this._name;
  }

  String getBio() {
    return this._bio;
  }

  List<String> getInterests() {
    return this._interests;
  }

  Person(String name, String bio, List<String> interests) {
    this._name = name;
    this._bio = bio;
    this._interests = interests;
  }
}
