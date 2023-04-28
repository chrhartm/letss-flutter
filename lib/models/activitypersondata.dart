
class ActivityPersonData {
  final int age;
  final String? gender;

  Map<String, dynamic> toJson() => {'age': age, 'gender': gender};

  ActivityPersonData({
    required this.age,
    this.gender
  });

  ActivityPersonData.fromJson(
      {required Map<String, dynamic> json})
      : age = json['age'],
        gender = json['gender'];
}
