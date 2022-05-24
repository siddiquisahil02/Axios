import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_manager/cubit/Complaints/complaints_cubit.dart';
import 'package:society_manager/utils/select_images.dart';
import 'package:society_manager/utils/text_components.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {

  late final ComplaintsCubit cubit;

  String? category;

  final desc = TextEditingController();
  List<XFile> images = [];

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ComplaintsCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Complaints'),
        ),
        body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          builder: (BuildContext context, state){
            if(state is ComplaintsLoading){
              return const Center(
                  child: CircularProgressIndicator()
              );
            }else if(state is ComplaintsError){
              return Center(
                  child: Text(state.msg,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  )
              );
            }else if(state is ComplaintsInitial){
              final List<String> data = state.data;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Category
                    Container(
                      margin: const EdgeInsets.only(bottom: 8,left: 7),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category:',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                    DropdownButtonFormField(
                        items: data.map((String e) =>
                            DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            )
                        ).toList(),
                        value: category,
                        decoration: textInputDeco(),
                        onChanged: (String? val){
                          setState(() {
                            category = val;
                          });
                        }
                    ),
                    const SizedBox(height: 20),

                    // Description
                    Container(
                      margin: const EdgeInsets.only(bottom: 8,left: 7),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Describe your issue:',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                    TextFormField(
                      controller: desc,
                      maxLines: 5,
                      cursorColor: Colors.red,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: FocusScope.of(context).unfocus,
                      validator: (val){
                        if(val==null || val.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textInputDeco(),
                    ),
                    const SizedBox(height: 20),

                    // Images
                    Container(
                      margin: const EdgeInsets.only(bottom: 8,left: 7),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Upload Images:',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ),
                    SelectImages(
                      onUpdate: (List<XFile> val){
                        images = val;
                      },
                    ),
                    const SizedBox(height: 50),

                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width - 50,
                      color: Colors.red,
                      height: 55,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text('Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: ()async{
                        if(category!=null && desc.text.isNotEmpty){
                          cubit.uploadData(
                            cat: category!,
                            desc: desc.text.trim(),
                            images: images
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter all the information to continue !'))
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }else if(state is ComplaintsDone){
              Future.delayed(Duration.zero,(){
                Fluttertoast.cancel();
                Fluttertoast.showToast(msg: "Complaint Registered..!");
                Navigator.pushNamedAndRemoveUntil(context,'/home', (route) => false);
              });
              return Container();
            }else{
              return Container();
            }
          },
        )
    );
  }
}
