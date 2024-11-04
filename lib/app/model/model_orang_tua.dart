class OrangTua {
  int id;
  String username;
  String email;
  String nama;
  String noKk;
  String telepon;

  OrangTua({
    required this.id,
    required this.username,
    required this.email,
    required this.nama,
    required this.noKk,
    required this.telepon,
  });

  factory OrangTua.fromJson(Map<String, dynamic> json) {
    return OrangTua(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      nama: json['nama'] ?? '',
      noKk: json['no_kk'] ?? '',
      telepon: json['telepon'] ?? '',
    );
  }
}
