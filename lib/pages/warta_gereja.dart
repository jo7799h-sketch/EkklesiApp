import 'package:comp_vis_project/model_data.dart';
import 'package:flutter/material.dart';

// WARTA GEREJA DIBUAT KAYAK DETAIL_KHOTBAH
class WartaGereja extends StatelessWidget{
  final Warta warta;

  const WartaGereja({super.key, required this.warta});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(warta.title),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              warta.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Oleh: ${warta.preacher}",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "Tanggal: ${warta.date.day}/${warta.date.month}/${warta.date.year}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16,),
            Text(
              warta.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            )
          ],
        ),
      ),
    );
  }
}