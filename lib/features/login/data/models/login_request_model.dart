class LoginRequestModel {
  String? userNameOrEmailAddress;
  String? password;
  bool? isMobile;

  LoginRequestModel(
      {
        this.userNameOrEmailAddress,
        this.password,
        this.isMobile,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userNameOrEmailAddress'] = userNameOrEmailAddress;
    data['password'] = password;
    data['isMobile'] = isMobile;
    return data;
  }

}
