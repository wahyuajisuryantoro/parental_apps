class Presensi {
  int id;
  String keterangan;
  String namaSiswa;
  int idSiswa;
  String rfid;
  String kelas;
  DateTime waktu;
  String tanggal;

  Presensi({
    required this.id,
    required this.keterangan,
    required this.namaSiswa,
    required this.idSiswa,
    required this.rfid,
    required this.kelas,
    required this.waktu,
    required this.tanggal,
  });

  factory Presensi.fromJson(Map<String, dynamic> json) {
    return Presensi(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      keterangan: json['keterangan'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      idSiswa: int.tryParse(json['id_siswa']?.toString() ?? '') ?? 0,
      rfid: json['rfid'] ?? '',
      kelas: json['kelas'] ?? '',
      waktu: DateTime.tryParse(json['waktu'] ?? '') ?? DateTime.now(),
      tanggal: json['tanggal'] ?? '',
    );
  }
}
