import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_manager/cubit/Emergency/emergency_cubit.dart';
import 'package:society_manager/models/emergency_model.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EmergencyCubit>(context);
    cubit.getData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Emergency Contacts'),
        ),
        body: BlocBuilder<EmergencyCubit,EmergencyState>(
          builder: (BuildContext context, state){
            if(state is EmergencyLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is EmergencyError){
              return Center(child: Text(state.msg));
            }else if(state is EmergencyInitial){
              return state.data!=null?Container(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  itemCount: state.data!.value.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemBuilder: (BuildContext context, int index){
                    Value value = state.data!.value[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value.name,
                          style: GoogleFonts.overlock(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            // final String telNo = "tel:${value.number}";
                            bool? res = await FlutterPhoneDirectCaller.callNumber(value.number);
                            if(!res!){
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: "Can't launch the dialer\nLong press to copy.");
                            }
                          },
                          onLongPress: (){
                            Clipboard.setData(ClipboardData(text: value.number)).then((value){
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(msg: "Copied to your clipboard");
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 7),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.black,width: 2),
                              color: Colors.grey.shade300
                            ),
                            child: Text(value.number,
                              style: GoogleFonts.lato(
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ):const Center(
                child: Text("No Data found..!"),
              );
            }else{
              return Container();
            }
          },
        )
    );
  }
}
