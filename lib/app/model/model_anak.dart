class Anak {
  static const String baseUrlFoto = 'https://mi-paremono.presensimu.com/assets/image/foto_siswa/';

  int id;
  String nisn;
  String noInduk;
  String namaSiswa;
  String rfid;
  String kelas;
  String status;
  String kelamin;
  String tempatLahir;
  String noKk;
  String foto;
  String alamat;
  String tanggalLahir;
  String namaAyah;
  String namaIbu;
  String pekerjaanAyah;
  String pekerjaanIbu;
  int jmlSdr;
  int attendance;
  String lastPresensiTimeAgo;

  Anak({
    required this.id,
    required this.nisn,
    required this.noInduk,
    required this.namaSiswa,
    required this.rfid,
    required this.kelas,
    required this.status,
    required this.kelamin,
    required this.tempatLahir,
    required this.noKk,
    required this.foto,
    required this.alamat,
    required this.tanggalLahir,
    required this.namaAyah,
    required this.namaIbu,
    required this.pekerjaanAyah,
    required this.pekerjaanIbu,
    required this.jmlSdr,
    this.attendance = 0,
    this.lastPresensiTimeAgo = 'Tidak ada data',
  });

  String get fotoUrl => baseUrlFoto + foto;

  factory Anak.fromJson(Map<String, dynamic> json) {
    return Anak(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nisn: json['nisn'] ?? '',
      noInduk: json['no_induk'] ?? '',
      namaSiswa: json['nama_siswa'] ?? '',
      rfid: json['rfid'] ?? '',
      kelas: json['kelas'] ?? '',
      status: json['status'] ?? '',
      kelamin: json['kelamin'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      noKk: json['no_kk'] ?? '',
      foto: json['foto'] ?? '',
      alamat: json['alamat'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      pekerjaanAyah: json['pekerjaan_ayah'] ?? '',
      pekerjaanIbu: json['pekerjaan_ibu'] ?? '',
      jmlSdr: int.tryParse(json['jml_sdr']?.toString() ?? '') ?? 0,
      attendance: int.tryParse(json['attendance']?.toString() ?? '') ?? 0,
      lastPresensiTimeAgo: 'Tidak ada data', 
    );
  }
}
