import 'package:comp_vis_project/pages/warta_gereja.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:comp_vis_project/model_data.dart';
import 'package:comp_vis_project/feature/custom_card_button.dart';
import 'package:comp_vis_project/feature/sorting_data_helper.dart';

class HalamanWarta extends StatelessWidget{
  const HalamanWarta({super.key});

  @override
  Widget build(BuildContext context){

    final longestWarta = getLongestToLatestWarta();

    return 
    Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 31, left: 50),
              child: 
              Text(
                'Arsip Warta Gereja',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
          ],
        ),
        // const SizedBox(height: 20),
        Expanded(
          child: 
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dummyWarta.length,
            itemBuilder: (context, index){
              final warta = longestWarta[index];
              return CustomCardButton(
                title: warta.title, 
                subtitle: "${warta.preacher}\n${warta.date.day}/${warta.date.month}/${warta.date.year}", 
                icon: AppIcons.warta,
                onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => WartaGereja(warta: warta)
                        )
                      );
                    },
              );
            },
          ),
        )
      ],
    );
  }
}