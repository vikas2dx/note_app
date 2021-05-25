import 'package:flutter/material.dart';
import 'package:note_app/cubits/NoteCubit.dart';
import 'package:note_app/model/NoteModel.dart';
import 'package:note_app/ui/pages/AddNotePage.dart';
import 'package:note_app/ui/pages/DetailsPage.dart';
import 'package:note_app/ui/widgets/CustomText.dart';
import 'package:note_app/utils/NetworkUtils.dart';

class NewsListWidget extends StatelessWidget {
  NoteCubit cubit;
  NoteModel noteModel;

  NewsListWidget({this.noteModel, this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(noteModel),
              ));
        },
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: noteModel.title,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: noteModel.description,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit',
                      onPressed: () async {
                        bool flag = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNotePage(
                                  isUpdate: true, noteModel: noteModel),
                            ));
                        print("Update Status $flag");
                        if (flag != null) {
                          if (flag) {
                            cubit.fetchNote();
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete',
                      onPressed: () async {
                        if (await NetworkUtils.isInternetAvailable()) {
                          cubit.deleteFirebase(noteModel.time_stamp.toString(), noteModel.time_stamp);
                        } else {
                          int id= await cubit.deleteSqlite(noteModel.time_stamp);
                          print("Id $id");
                          if(id>0)
                            {
                              cubit.fetchNote();
                            }
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
