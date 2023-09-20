class UserDto {
  late String email;
  late String name;
  late String nick;
  String? tel;
  String? proImgPath;
  UserDto({
    required this.email,
    required this.name,
    required this.nick,
    this.tel = "",
    this.proImgPath = "",
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'nick': nick,
      'tel': tel,
      'proImgPath': proImgPath,
    };
  }

  UserDto.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    name = json["name"];
    nick = json["nick"];
    tel = json["tel"];
    proImgPath = json["proImgPath"];
  }

  @override
  String toString() {
    var result = """$email,
                    $name,
                    $nick,
                    $tel,
                    $proImgPath,""";
    return result;
  }

  // NaverBookDto.fromJson(Map<String, dynamic> json) {
  //   title = json["title"];
  //   link = json["link"];
  //   image = json["image"];
  //   author = json["author"];
  //   discount = json["discount"];
  //   publisher = json["publisher"];
  //   isbn = json["isbn"];
  //   description = json["description"];
  //   pubdate = json["pubdate"];
  // }
}
