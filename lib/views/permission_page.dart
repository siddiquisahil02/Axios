import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:society_manager/components/ui_components.dart';
import 'package:society_manager/cubit/Permission/permission_cubit.dart';

class PermissionPage extends StatefulWidget {
  final String id;
  const PermissionPage({Key? key, required this.id}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {

  late final PermissionCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<PermissionCubit>(context);
    cubit.getData(payload: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Permission Screen'),
        ),
        body: BlocBuilder<PermissionCubit,PermissionState>(
          builder: (BuildContext context, state){
            if(state is PermissionLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is PermissionDone){
              Future.delayed(Duration.zero,(){
                Navigator.pushNamedAndRemoveUntil(context,'/home', (route) => false);
              });
              return const Center(child: Text("Done"));
            }else if(state is PermissionError){
              return Center(child: Text(state.msg));
            }else if(state is PermissionInitial){
              Map<String,dynamic>? data = state.data;
              return data!=null
                  ?Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIComponents.showText(
                        title: "Name",
                        body: data['name']
                    ),
                    UIComponents.showText(
                        title: "From",
                        body: data['from']
                    ),
                    UIComponents.showText(
                        title: "Phone Number",
                        body: data['phoneNumber']
                    ),
                    UIComponents.showText(
                        title: "Check In At",
                        body: DateFormat.yMMMEd().add_jms().format(data['checkInAt'].toDate())
                    ),
                    UIComponents.showText(
                        title: "Is Accompanied by a vehicle",
                        body: data['viaVehicle']?"Yes":"No"
                    ),
                    if(data['viaVehicle'])...[
                      UIComponents.showText(
                          title: "Vehicle Type",
                          body: data['vehicleType']
                      ),
                      UIComponents.showText(
                          title: "Vehicle Number",
                          body: data['vehicleNumber']
                      ),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            child: const Text("Deny",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            elevation: 8,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            color: Colors.red,
                            onPressed: (){
                              cubit.respond(
                                  response: false,
                                  visitorID: widget.id.split('-').first,
                                  resID: widget.id.split('-').last
                              );
                            },
                          ),
                          MaterialButton(
                            child: const Text("Allow",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            elevation: 8,
                            textColor: Colors.white,
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            onPressed: (){
                              cubit.respond(
                                  response: true,
                                  visitorID: widget.id.split('-').first,
                                  resID: widget.id.split('-').last
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
                  :const Center(
                  child: Text("No data is available")
              );
              return Container();
            }else{
              return Container();
            }
          },
        )
    );
  }
}
