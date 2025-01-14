import 'package:flutter/material.dart';
import 'package:admin_fik_app/customstyle/reportCard.dart';
import 'package:admin_fik_app/data/api_data.dart' as api_data;

class SemuakendalaPage extends StatefulWidget {
  final String room;

  SemuakendalaPage({required this.room});
  
  @override
  _SemuakendalaPageState createState() => _SemuakendalaPageState();
}

class _SemuakendalaPageState extends State<SemuakendalaPage> {
  late Future<List<Map<String, dynamic>>> _kendalaFuture;

  @override
  void initState() {
    super.initState();
    _kendalaFuture = fetchKendala();
  }

  Future<List<Map<String, dynamic>>> fetchKendala() async {
    List<Map<String, dynamic>> kendala;
    if(widget.room == 'lab') {
      kendala = await api_data.getKendalaLab();
    }else{
      kendala = await api_data.getKendalaKelas();
    }
    return kendala;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Semua Daftar Laporan Kendala',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFF5833),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _kendalaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> kendalaList = snapshot.data!;
            return ListView.builder(
              itemCount: kendalaList.length,
              itemBuilder: (context, index) {
                var kendala = kendalaList[index];
                return ReportCard(
                  id: kendala['id'],
                  nama_pelapor: kendala['nama_pelapor'],
                  nim_nrp: kendala['nim_nrp'],
                  nama_ruangan: kendala['nama_ruangan'],
                  status: kendala['status'],
                  tanggal: kendala['tanggal'],
                  jenis_kendala: kendala['jenis_kendala'],
                  bentuk_kendala: kendala['bentuk_kendala'],
                  deskripsi_kendala: kendala['deskripsi_kendala'],
                  keterangan_penyelesaian: kendala['keterangan_penyelesaian'] ?? '',
                );
              },
            );
          }
        },
      ),
    );
  }
}