import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubits/CubitState.dart';
import 'package:note_app/cubits/NoteCubit.dart';
import 'package:note_app/ui/pages/AddNotePage.dart';
import 'package:note_app/ui/pages/LoginPage.dart';
import 'package:note_app/ui/resources/AppColor.dart';
import 'package:note_app/ui/widgets/LoadingWidget.dart';
import 'package:note_app/ui/widgets/NoteListWidget.dart';
import 'package:note_app/utils/PreferencesUtils.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  BuildContext context;

  NoteCubit _newsCubit = NoteCubit();

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        PreferencesUtils().removeAll(PreferencesKeys.IS_LOGIN);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
        break;
      case 'Support':
        break;
    }
  }

  @override
  void initState() {
    _newsCubit.fetchNote();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard Page"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: handleClick,
              itemBuilder: (context) {
                return {'Logout', 'Support'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: BlocBuilder<NoteCubit, CubitState>(
            cubit: _newsCubit,
            builder: (context, state) {
              if (state is FailedState) {
                return Center(child: Text("No data Found"));
              } else if (state is SuccessState) {
                print("Size_${_newsCubit.noteList.length}");
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _newsCubit.noteList.length,
                  itemBuilder: (context, index) {
                    return NewsListWidget(
                      noteModel: _newsCubit.noteList[index],
                      cubit: _newsCubit,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else if (state is LoadingState) {
                return LoadingWidget(true);
              } else {
                return Container();
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool flag = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(
                    isUpdate: false,
                  ),
                ));
            if (flag != null) {
              _newsCubit.fetchNote();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: AppColor.themeColor,
        ),
      ),
    );
  }
}
