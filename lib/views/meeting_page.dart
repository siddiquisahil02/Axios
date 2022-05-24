import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:society_manager/cubit/Meeting/meeting_cubit.dart';
import 'package:society_manager/models/meeting_model.dart';

class MeetingPage extends StatelessWidget {
  const MeetingPage({Key? key}) : super(key: key);

  Widget meetingPopUp({required BuildContext context, required MeetingModel model}){
    return AlertDialog(
      title: Text(model.agenda,
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
    final cubit = BlocProvider.of<MeetingCubit>(context);
    cubit.getData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting Planner'),
        ),
        body: BlocBuilder<MeetingCubit, MeetingState>(
          builder: (BuildContext context, state){
              if(state is MeetingLoading){
                return const Center(
                    child: CircularProgressIndicator()
                );
              }else if(state is MeetingError){
                return Center(
                    child: Text(state.msg,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    )
                );
              }else if(state is MeetingInitial) {
                List<MeetingModel> listData = state.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  child: listData.isNotEmpty?ListView.separated(
                    itemCount: listData.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          showDialog(
                              builder: (BuildContext context) => meetingPopUp(context: context, model: listData[index]),
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
                                title: Text(listData[index].agenda,
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
