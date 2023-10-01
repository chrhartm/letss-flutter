import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/models/template.dart';

class TemplateService {
  static Future<List<Template>> searchTemplates(
      SearchParameters searchParameters,
      {int N = 100}) async {
    List<Template> templates = [];

    String countryCode = (searchParameters.language == null ||
            searchParameters.language!.countryCode == null)
        ? "en"
        : searchParameters.language!.countryCode!;

    // First get location-specific templates
    Query query = FirebaseFirestore.instance
        .collection('templates')
        .where('language', isEqualTo: countryCode)
        .where('status', isEqualTo: 'ACTIVE')
        .where('location.locality', isEqualTo: searchParameters.locality);
    if (searchParameters.category != null) {
      query = query.where('categories',
          arrayContains: searchParameters.category!.name);
    }
    await query
        .orderBy('timestamp', descending: true)
        .limit(N ~/ 2)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        jsonData["uid"] = doc.id;
        templates.add(Template.fromJson(json: jsonData));
      });
    });

    // Then get non-location-specific templates
    query = FirebaseFirestore.instance
        .collection('templates')
        .where('language', isEqualTo: countryCode)
        .where('status', isEqualTo: 'ACTIVE')
        .where('location.locality', isNull: true);
    if (searchParameters.category != null) {
      query = query.where('categories',
          arrayContains: searchParameters.category!.name);
    }
    await query
        .orderBy('timestamp', descending: true)
        .limit(N ~/ 2)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        jsonData["uid"] = doc.id;
        templates.add(Template.fromJson(json: jsonData));
      });
    });

    // Sort the joined list because only individually ordered
    templates.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return templates;
  }
}
