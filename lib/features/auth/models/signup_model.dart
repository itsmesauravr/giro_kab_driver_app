class SignUpData {
  final String mobile;
  final String password;
  final String name;
  final String franchise;

  SignUpData({
    required this.mobile,
    required this.password,
    required this.name,
    required this.franchise,
  });

   Map<String, String> toJson(){
    return{'mobile':mobile, 'password': password, 'name':name, 'franchise_id':franchise};
  }

}
