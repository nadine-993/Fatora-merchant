class ChangePasswordRequest{
  String? currentPassword;
  String? newPassword;

  ChangePasswordRequest(
      {
        this.currentPassword,
        this.newPassword,
      });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPassword'] = currentPassword;
    data['newPassword'] = newPassword;
    return data;
  }

}