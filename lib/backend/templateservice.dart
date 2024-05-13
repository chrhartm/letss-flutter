import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/models/template.dart';

class TemplateService {
  static Future<Template?> getTemplate(String uid) async {
    Template? template;
    await FirebaseFirestore.instance
        .collection('templates')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> jsonData =
            documentSnapshot.data() as Map<String, dynamic>;
        jsonData["uid"] = documentSnapshot.id;
        template = Template.fromJson(json: jsonData);
      } else {
        throw Exception('Template not found');
      }
    });
    return template;
  }

  static Future<List<Template>> searchTemplates(
      SearchParameters searchParameters,
      {bool withGeneric = true,
      int N = 100}) async {
    List<Template> templates = [];

    String languageCode = (searchParameters.language == null)
        ? "en"
        : searchParameters.language!.languageCode;

    // TODO hack to make sure events are in English. In future have
    // language-specific events
    if (!withGeneric) {
      languageCode = "en";
    }

    // First get location-specific templates
    Query query = FirebaseFirestore.instance
        .collection('templates')
        .where('language', isEqualTo: languageCode)
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
    if (withGeneric) {
      query = FirebaseFirestore.instance
          .collection('templates')
          .where('language', isEqualTo: languageCode)
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
    }
    // Sort the joined list because only individually ordered
    templates.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Shuffle to make more interesting
    templates.shuffle();

    return templates;
  }
}
