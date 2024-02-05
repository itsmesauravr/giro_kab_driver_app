class LoginData {
  final String driverId;
  final String password;

  LoginData({
    required this.driverId,
    required this.password,
  });
   Map<String, String> toJson(){
    return{'driver_id':driverId, 'password': password};
  }

  @override
  String toString() {
    return "$driverId $password";
  }
}
