class Config {
  bool forceAddActivity = false;
  int activityAddPromptEveryTenX = 2;
  int minChatsForReview = 3;
  int searchDays = 0;
  String supportPitch =
      "Enjoying our app? Buy us a coffee and get a supporter badge on your profile.";
  int supportRequestInterval = 360;

  Config();

  Config.fromJson({required Map<String, dynamic> json}){
    if(json.containsKey('forceAddActivity')){
      forceAddActivity = json['forceAddActivity'];
    }
    if(json.containsKey('activityAddPromptEveryTenX')){
        activityAddPromptEveryTenX = json['activityAddPromptEveryTenX'];
    }
    if(json.containsKey('minChatsForReview')){
        minChatsForReview = json['minChatsForReview'];
    }
    if(json.containsKey('searchDays')){
        searchDays = json['searchDays'];
    }
    if(json.containsKey('supportPitch')){
        supportPitch = json['supportPitch'];
    }
    if(json.containsKey('supportRequestInterval')){
        supportRequestInterval = json['supportRequestInterval'];
    }
  }
}
