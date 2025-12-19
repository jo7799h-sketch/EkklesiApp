import 'package:comp_vis_project/feature/custom_card_button.dart';
import 'package:comp_vis_project/pages/detail_khotbah.dart';
import 'package:comp_vis_project/model_data.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:comp_vis_project/feature/sorting_data_helper.dart';

class HalamanKhotbah extends StatelessWidget{
  const HalamanKhotbah({super.key});

  @override
  Widget build(BuildContext context){

    final latestSermons = getLatestToLongestSermons();
    
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 31, left: 50),
              child: 
              Text(
                'Arsip Khotbah',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
          ],
        ),
        Expanded(
          child: 
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dummySermons.length,
            itemBuilder: (context, index){
              final sermon = latestSermons[index];
              return CustomCardButton(
                title: sermon.title, 
                subtitle: "${sermon.preacher}\n${sermon.date.day}/${sermon.date.month}/${sermon.date.year}", 
                icon: AppIcons.sermon,
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => DetailKhotbah(sermon: sermon)
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