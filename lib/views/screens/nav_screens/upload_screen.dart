import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/controllers/category_controller.dart';
import 'package:vendor_app/models/category.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late Future<List<Category>> futureCategories;
late String name;
Category? selectedCategory;
@override
  void initState() {
    futureCategories = CategoryController().loadCategories();
    super.initState();
  }
  // Create an instance of image picker to undo image selection
  final ImagePicker picker = ImagePicker();

  // Initialize an empty list to store the selected images
  List<File> images = [];

  // Define a function to choose image from the gallery
  chooseImage() async {
    //Use the picker to select the image from the gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //Check if not image was picked
    if (pickedFile == null) {
      print("No Image Picked");
    }else{
      //if an image was picked, update the state and add image to the list      
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            itemCount: images.length+1, // the number of items in the grid (+1 for the add button)
            shrinkWrap: true, // Allow the gridview to shrink to fit the content

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 3,
              childAspectRatio: 1,
              ), 
            itemBuilder: (context, index){
              // if the index is 0. display an iconButton to add a new image
              return index==0? Center(
                child: IconButton(
                  onPressed: (){
                    chooseImage();
                  }, 
                  icon: Icon(Icons.add)
                  ),
              ): SizedBox(
                  width: 50,
                  height: 40,
                  child: Image.file(images[index-1]),
              );
        }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Product Name',
                hintText: 'Enter Product Name',
                border: OutlineInputBorder()
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Product Price',
                hintText: 'Enter Product Price',
                border: OutlineInputBorder()
              ),
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Product Quantity',
                hintText: 'Enter Product Quantity',
                border: OutlineInputBorder()
              ),
            ),
          ),
          SizedBox(height: 10,),
           FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    final stacktrace = snapshot.stackTrace;
                     print("📍 StackTrace: $stacktrace");
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No Category"),
                    );
                  } else {
                    return DropdownButton<Category>(
                        value: selectedCategory,
                        hint: Text('Select Category'),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          // print(selectedCategory!.name);
                        });
                  }
                }),
                SizedBox(height: 10,),
          SizedBox(
            width: 400,
            child: TextFormField(
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Enter Product Description',
                hintText: 'Enter Product Description',
                border: OutlineInputBorder()
              ),
            ),
          ),


          
            ],
          ),
        )
        ],
      ),
    );
  }
}
