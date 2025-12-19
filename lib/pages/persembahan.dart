import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Persembahan extends StatelessWidget {
  const Persembahan({super.key});

  final String rekNumber = "1234567890";

  @override
  Widget build(BuildContext context) {
	return Scaffold(
    appBar: AppBar(title: const Text('Persembahan')),
    body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // tengah vertikal
        crossAxisAlignment:
            CrossAxisAlignment.center, // tengah horizontal
        children: [
          const Text(
            'Anda bisa "Tap" QR Code ini untuk otomatis mendownload kode QR ini.\nTerima Kasih.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17, // perbesar ukuran font
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),
          SizedBox(
            width: 300,
            height: 400,
            child: Image.asset("assets/images/GBT_ALFA_OMEGA.png"),
          ),
          const SizedBox(height: 24),
          const Text(
            'Atau Anda bisa "Tap" No.Rek dibawah ini untuk otomatis menyalin nomor rekening ini.\nTerima Kasih.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17, // perbesar ukuran font
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),
          _rekBox(context)
        ],
      ),
	  ),
	);
  }

  // Widget _qrPersembahan(){
  //   return AssetImage(
  //       "assets/GBT_ALFA_OMEGA.png",
  //       height: 200,
  //       width: 200,
        
  //     );
  //   // );
  // }

  Widget _rekBox(BuildContext context){
    return Center(
      child: GestureDetector(
        onTap: (){
          Clipboard.setData(ClipboardData(text: rekNumber));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nomor Rekening Berhasil Tersalin'))
          );
        },
        child: Container(
          
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "No.Rekening : ",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 56, 55, 55),
                  )
                ),
                TextSpan(
                  text: rekNumber,
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  )
                )
              ]
            ),
          
          )
        ),
      )
    );
  }
}