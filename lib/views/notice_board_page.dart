import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:society_manager/cubit/Notice/notice_cubit.dart';
import 'package:society_manager/models/notice_model.dart';

class NoticeBoardPage extends StatefulWidget {
  const NoticeBoardPage({Key? key, this.data}) : super(key: key);
  final Map<String,dynamic>? data;

  @override
  State<NoticeBoardPage> createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {

  late final NoticeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<NoticeCubit>(context);
    cubit.getData();
  }

  Widget noticePopUp({required BuildContext context, required NoticeModel model}){
    return AlertDialog(
      title: Text(model.title,
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold
        ),
      ),
      scrollable: true,
      content: Text(model.body,
        style: GoogleFonts.overlock(),
      ),
      actions: [
        MaterialButton(
          color: Colors.red,
          child: const Text("Okay"),
          textColor: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notice Board'),
        ),
        body: BlocBuilder<NoticeCubit, NoticeState>(
          builder: (BuildContext context, state){
            if(state is NoticeLoading){
              return const Center(
                  child: CircularProgressIndicator()
              );
            }else if(state is NoticeError){
              return Center(
                  child: Text(state.msg,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
              );
            }else if(state is NoticeInitial){
              List<NoticeModel> listData = state.listData;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: listData.isNotEmpty?ListView.separated(
                  itemCount: listData.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        showDialog(
                            builder: (BuildContext context) => noticePopUp(context: context, model: listData[index]),
                            context: context
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1
                          ),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(listData[index].title,
                                style: GoogleFonts.overlock(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(listData[index].body,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.overlock(),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text("Posted on: ${DateFormat.yMMMd().add_jm().format(listData[index].createdAt.toDate())}",
                                style: GoogleFonts.overlock(
                                  fontSize: 14
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index){
                    return const SizedBox(
                      height: 17,
                    );
                  },
                ):const Center(
                  child: Text("No Notice Posted yet..!"),
                ),
              );
            }else{
              return Container();
            }
          },
        )
    );
  }
}