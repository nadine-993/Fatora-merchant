class SetPasswordRequestModel {
  int? userId;
  String? resetCode;
  String? password;
  String? returnUrl;

  SetPasswordRequestModel(
      {
        this.userId,
        this.resetCode,
        this.password,
        this.returnUrl,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['resetCode'] = resetCode;
    data['password'] = password;
    data['returnUrl'] = returnUrl;
    return data;
  }

}
