class ConfirmLoginRequestModel {
  String? usernameOrEmail;
  String? otp;

  ConfirmLoginRequestModel(
      {
        this.usernameOrEmail,
        this.otp,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usernameOrEmail'] = usernameOrEmail;
    data['otp'] = otp;
    return data;
  }

}
