import 'package:flutter/material.dart';
import 'package:admin_fik_app/customstyle/cardConfirmed.dart';
import 'package:admin_fik_app/data/api_data.dart' as api_data;

class TerkonfirmasiPage extends StatefulWidget {
  final String room;

  TerkonfirmasiPage({required this.room});

  @override
  _TerkonfirmasiPageState createState() => _TerkonfirmasiPageState();
}

class _TerkonfirmasiPageState extends State<TerkonfirmasiPage> {
  late Future<List<Map<String, dynamic>>> _peminjamanFuture;

  @override
  void initState() {
    super.initState();
    _peminjamanFuture = fetchPeminjaman();
  }

  Future<List<Map<String, dynamic>>> fetchPeminjaman() async {
    List<Map<String, dynamic>> peminjaman;
    if(widget.room == 'lab') {
      peminjaman = await api_data.getPeminjamanLab();
    }else{
      peminjaman = await api_data.getPeminjamanKelas();
    }
    print("peminjaman: ${peminjaman.where((peminjaman) => peminjaman['id_status'] == 5 || peminjaman['id_status'] == 6).toList()}");
    return peminjaman.where((peminjaman) => peminjaman['id_status'] == 5 || peminjaman['id_status'] == 6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Daftar Diterima/Ditolak',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFF5833),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _peminjamanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> peminjamanList = snapshot.data!;
            return ListView.builder(
              itemCount: peminjamanList.length,
              itemBuilder: (context, index) {
                var peminjaman = peminjamanList[index];
                return CardConfirmed(
                  id: peminjaman['id'],
                  studentName: peminjaman['nama_peminjam'],
                  no_tlp: peminjaman['no_tlp'],
                  grup_pengguna: peminjaman['grup_pengguna'],
                  inputDate: peminjaman['tanggal'],
                  bookDate: peminjaman['tanggal'],
                  studentNim: peminjaman['nim'],
                  keterangan: peminjaman['keterangan'] ?? '',
                  alasanPenolakan: peminjaman['alasan_penolakan'] ?? '',
                  catatan_kejadian: peminjaman['catatan_kejadian'] ?? '',
                  time: "${peminjaman['jam_mulai']} - ${peminjaman['jam_selesai']} WIB",
                  jamMulai: peminjaman['jam_mulai'],
                  jamSelesai: peminjaman['jam_selesai'],
                  ruangan: peminjaman['ruangan'],
                  groupSize: peminjaman['jumlah_orang'],
                  status: peminjaman['status'],
                );
              },
            );
          }
        },
      ),
    );
  }
}