import 'package:intl/intl.dart';

class Presensi {
  final int id;
  final String keterangan;
  final String namaSiswa;
  final int idSiswa;
  final String rfid;
  final String kelas;
  final DateTime waktu;
  final String tanggal;

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
      id: int.parse(json['id'] ?? '0'),
      keterangan: json['keterangan'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      idSiswa: int.parse(json['id_siswa'] ?? '0'),
      rfid: json['rfid'] ?? '',
      kelas: json['kelas'] ?? '',
      waktu: DateTime.parse(json['waktu'] ?? DateTime.now().toString()),
      tanggal: json['tanggal'] ?? '',
    );
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(waktu);
  }

  String get formattedDate {
    return DateFormat('dd MMMM yyyy').format(waktu);
  }
}
