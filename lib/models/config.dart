class Config {
  bool forceAddActivity = false;
  int activityAddPromptEveryTenX = 2;
  int minChatsForReview = 3;
  int searchDays = 0;
  int supportRequestInterval = 360;
  int notificationsRequestInterval = 7;
  List<Map<String, dynamic>> hubs = [
    /*
    {
      "lat": 52.370216,
      "lng": 4.895168,
      "emoji": "🇳🇱",
      "name": "Amsterdam",
    },
    {"name": "Berlin", "lat": 52.520008, "lng": 13.404954, "emoji": "🇩🇪"},
    {"name": "Zurich", "lat": 47.376887, "lng": 8.541694, "emoji": "🇨🇭"},
    */
  ];

  Config();

  Config.fromJson({required Map<String, dynamic> json}) {
    if (json.containsKey('forceAddActivity')) {
      forceAddActivity = json['forceAddActivity'];
    }
    if (json.containsKey('activityAddPromptEveryTenX')) {
      activityAddPromptEveryTenX = json['activityAddPromptEveryTenX'];
    }
    if (json.containsKey('minChatsForReview')) {
      minChatsForReview = json['minChatsForReview'];
    }
    if (json.containsKey('searchDays')) {
      searchDays = json['searchDays'];
    }
    if (json.containsKey('supportRequestInterval')) {
      supportRequestInterval = json['supportRequestInterval'];
    }
    if (json.containsKey('notificationsRequestInterval')) {
      notificationsRequestInterval = json['notificationsRequestInterval'];
    }
    if (json.containsKey('hubs')) {
      hubs = [];
      hubs = json["hubs"]
          .map<Map<String, dynamic>>((e) => {
                "name": e["name"],
                "lat": e["lat"],
                "lng": e["lng"],
                "emoji": e["emoji"]
              })
          .toList();
    }
  }
}
