class SetDefaultParamsRequest{
  String? callbackURL;
  String? triggerURL;
  List<String?> status;

  SetDefaultParamsRequest(
      {
        this.callbackURL,
        this.triggerURL,
        required this.status,
      });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['callbackURL'] = callbackURL;
    data['triggerURL'] = triggerURL;
    data['status'] = status;
    return data;
  }

}