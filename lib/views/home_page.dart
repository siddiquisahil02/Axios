import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_manager/constants.dart';
import 'package:society_manager/cubit/Home/home_cubit.dart';
import 'package:society_manager/models/home_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    cubit.getDues();
    return Scaffold(
        appBar: AppBar(
          title: Text('  Axios',
            style: GoogleFonts.satisfy(
              fontSize: 30
            ),
          ),
          actions: [
            IconButton(
                onPressed: ()async{
                  final String resId = box.read("resId")??"N.A";
                  await FirebaseMessaging.instance.unsubscribeFromTopic(resId);
                  //print(auth.currentUser?.displayName);
                  await auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(context,"/", (route) => false);
                },
                icon: const Icon(Icons.login))
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, state){
            if(state is HomeLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is HomeError){
              return Center(child: Text(state.msg));
            }else if(state is HomeInitial){
              HomeModel data = state.data;
              return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Hello, ${data.fullName}",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text("${data.email} (${data.role})",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.overlock(
                              fontSize: 18
                          ),
                        ),
                        Text("${data.houseNo}, ${data.residence}, ${data.city}, ${data.state}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.overlock(
                              fontSize: 18
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.shade400
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Your Dues",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Rs. ${data.dues}",
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: (){
                              cubit.submitRazorID(context: context, amount: data.dues);
                            },
                            child: Text("Pay Now",
                              style: GoogleFonts.pattaya(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'/notice');
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 1),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue
                            ),
                            child: Text("Notice Board",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'/complaints');
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 1),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green
                            ),
                            child: Text("Complaint Center",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'/meeting');
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 1),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.purple
                            ),
                            child: Text("Meeting Board",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'/emergency');
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 1),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.brown
                            ),
                            child: Text("Emergency Contacts",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
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
