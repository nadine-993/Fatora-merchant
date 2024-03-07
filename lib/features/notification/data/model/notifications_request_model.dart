class NotificationsRequestModel {
  String? terminalId;

  NotificationsRequestModel(
      {
        this.terminalId,

      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['terminalId'] = terminalId;
    return data;
  }

}
