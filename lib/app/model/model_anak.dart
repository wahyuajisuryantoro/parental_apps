class Anak {
  int id;
  String namaSiswa;
  String kelas;
  String status;
  int attendance;

  Anak({
    required this.id,
    required this.namaSiswa,
    required this.kelas,
    required this.status,
    required this.attendance,
  });

  factory Anak.fromJson(Map<String, dynamic> json) {
    return Anak(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      namaSiswa: json['nama_siswa'] ?? '',
      kelas: json['kelas'] ?? '',
      status: json['status'] ?? '',
      attendance: int.tryParse(json['attendance']?.toString() ?? '') ?? 0,
    );
  }
}
