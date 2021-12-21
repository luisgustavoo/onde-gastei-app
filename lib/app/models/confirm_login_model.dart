class ConfirmLoginModel {
  ConfirmLoginModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory ConfirmLoginModel.fromMap(Map<String, dynamic> map) {
    return ConfirmLoginModel(
      accessToken: map['access_token'].toString(),
      refreshToken: map['refresh_token'].toString(),
    );
  }

  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConfirmLoginModel &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
