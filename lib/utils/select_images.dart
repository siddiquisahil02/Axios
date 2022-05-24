import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImages extends StatefulWidget {
  final void Function(List<XFile> data) onUpdate;
  const SelectImages({Key? key, required this.onUpdate}) : super(key: key);

  @override
  _SelectImagesState createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectImages> {

  late final List<XFile> images;

  @override
  void initState() {
    images = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 15,
      runSpacing: 10,
      children: [
        ...images.map((e){
            return Stack(
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black,
                          width: 2
                      ),
                    image: DecorationImage(
                      image: FileImage(File(e.path)),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Positioned(
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (){
                      images.remove(e);
                      widget.onUpdate.call(images);
                      setState(() {});
                    },
                  ),
                )
              ],
            );
        }).toList(),
        if(images.length<5)
        GestureDetector(
          child: Container(
            height: 150,
            width: 100,
            alignment: Alignment.center,
            child: const Icon(Icons.add,color: Colors.black,size: 40),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
            ),
          ),
          onTap: ()async{
            final res = await ImagePicker().pickImage(
                source: ImageSource.camera,
            );
            if(res!=null){
              images.add(res);
              widget.onUpdate.call(images);
              setState(() {});
            }
          },
        )
      ],
    );
  }
}
