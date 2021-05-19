import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'main.dart';


class NewProductScreen extends StatefulWidget 
  {@override
   _NewProductScreenState createState() => _NewProductScreenState();
  }

class _NewProductScreenState extends State<NewProductScreen> 
  {TextEditingController _prnameController = new TextEditingController();
   TextEditingController _prtypeController = new TextEditingController();
   TextEditingController _prpriceController = new TextEditingController();
   TextEditingController _prqtyController = new TextEditingController();
   double picHeight, picWidth;
   String pathAsset = 'assets/images/camera.png';
   File _image;
 
   @override
   Widget build(BuildContext context) 
    {picHeight = MediaQuery.of(context).size.height;
     picWidth = MediaQuery.of(context).size.width;

     return Container
      (decoration: new BoxDecoration
        (gradient: new LinearGradient
          (begin: Alignment.topLeft,
           end: Alignment.bottomRight,
           stops: [0.3,1],
           colors: [Colors.green[200],
                    Colors.red[200]
                   ],
          ),
        ),
       child: Scaffold
        (backgroundColor: Colors.transparent,
         
         body: Center
          (child: SingleChildScrollView 
            (child: Column
              (children: 
                [Card
                  (margin: EdgeInsets.fromLTRB(20,5,20,10),
                   elevation: 10,
                   shape: RoundedRectangleBorder
                    (borderRadius: BorderRadius.circular(50),
                    ),
                   color: Colors.white60,
                   child: 
                   Padding 
                    (padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
                     child: Column
                      (children: 
                        [Text
                          ('PRODUCT DETAILS',
                           style: TextStyle(fontWeight: FontWeight.bold, fontSize:25)
                          ),
                         TextField
                          (controller: _prnameController,
                           inputFormatters: 
                            [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),],
                           decoration: InputDecoration
                            (labelText: 'Name', 
                             labelStyle: TextStyle
                              (fontFamily: 'Varela_Round', 
                               fontSize:20
                              ),
                            ),
                           style: TextStyle(fontSize:20),
                          ),
                         TextField
                          (controller: _prtypeController,
                           inputFormatters: 
                            [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),],
                           decoration: InputDecoration
                            (labelText: 'Type', 
                             labelStyle: TextStyle
                              (fontFamily: 'Varela_Round', 
                               fontSize:20
                              ),
                            ),
                           style: TextStyle(fontSize:20),
                          ),
                          TextField
                          (controller: _prpriceController,
                           inputFormatters: 
                            [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration
                            (labelText: 'Price (RM)', 
                             labelStyle: TextStyle
                              (fontFamily: 'Varela_Round', 
                               fontSize:20
                              ),
                            ),
                           style: TextStyle(fontSize:20),
                          ),
                         TextField
                          (controller: _prqtyController,
                           inputFormatters: 
                            [FilteringTextInputFormatter.digitsOnly],
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration
                            (labelText: 'Quantity', 
                             labelStyle: TextStyle
                              (fontFamily: 'Varela_Round', 
                               fontSize:20
                              ),
                            ),
                           style: TextStyle(fontSize:20),
                          ),

                         GestureDetector
                          (onTap: () => {_selectPicture()},
                           child: Container
                            (height: picHeight/5,
                             width: picWidth/5,
                             decoration: BoxDecoration
                              (image: DecorationImage
                                (image: _image == null
                                 ? AssetImage(pathAsset)
                                 : FileImage(_image),
                                 fit: BoxFit.scaleDown,
                                ),
                              )
                            ),
                          ),
                         Text("*Click image to upload picture",
                      style: TextStyle(fontSize: 15.0, color: Colors.black)),
                  
                         SizedBox(height:30),
                          
                         MaterialButton
                            (shape: RoundedRectangleBorder
                              (borderRadius: BorderRadius.circular(5),),
                               minWidth: 150,
                               height: 50,
                               child: Text('ADD', style: TextStyle
                                    (fontFamily: 'Fredoka_One', 
                                     fontSize:25,
                                     color: Colors.white)
                                    ),
                               onPressed: _add,
                               color: Colors.green
                            )
                        ],
                      ),
                    ),
                  ),
                 SizedBox(height:20),
                 GestureDetector
                  (child: Text
                    ("Cancel", 
                      style: TextStyle
                        (fontFamily: 'Comfortaa', fontSize:22)),
                      onTap: () {
                        Navigator.push
                        (context, MaterialPageRoute(builder: (content) => Main()));
                      },
                    ),
                ],
              ),
            )
          ),
        ),
      );
    }

   void _add() 
    {String _prname = _prnameController.text.toString();
     String _prtype = _prtypeController.text.toString();
     String _prprice = _prpriceController.text.toString();
     String _prqty = _prqtyController.text.toString();

     if (_prname.isEmpty || _prtype.isEmpty || _prprice.isEmpty || _prqty.isEmpty)
      {Fluttertoast.showToast
        (msg: "Please ensure that all details are filled.",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
         backgroundColor: Colors.red,
         textColor: Colors.white,
         fontSize: 18.0
        );
       return;
      }
     showDialog
      (context: context,
       builder: (BuildContext context) 
        {return AlertDialog
          (shape: RoundedRectangleBorder
            (borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
           title: Text("ADD NEW PRODUCT", 
                  style: TextStyle(fontFamily: 'Fredoka_One', 
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                  fontSize:22)),
           content: Text("Confirm?",
            style: TextStyle(fontSize:20)),
           actions: 
            [TextButton
              (child: 
                Text("Yes", 
                     style: TextStyle(color: Colors.green[700],
                     fontFamily: 'Varela_Round',
                     fontSize: 18)),
                onPressed: () 
                  {Navigator.of(context).pop();
                   _addNewProduct(_prname, _prtype, _prprice, _prqty);
                  },
              ),
             TextButton
              (child: 
                Text("Cancel",
                     style: TextStyle(color: Colors.red[700],
                     fontFamily: 'Varela_Round',
                     fontSize: 18)),
                onPressed: () 
                  {Navigator.of(context).pop();
                  }
              ),
            ],
          );
        }
      );
    }   
   
   _selectPicture() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              //color: Colors.white,
              height: picHeight / 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

   Future _chooseCamera() async
    {final picker = ImagePicker();
     final pickedFile = await picker.getImage
      (source: ImageSource.camera,
       maxHeight: 800,
       maxWidth: 800,
      );
     
     setState(()
      {if (pickedFile != null)
        {_image = File(pickedFile.path);
        }
       else 
        {print('No image has been selected.');
        }
      });
    }

   Future _chooseGallery() async
    {final picker = ImagePicker();
     final pickedFile = await picker.getImage
      (source: ImageSource.gallery,
       maxHeight: 800,
       maxWidth: 800,
      );
     
     setState(()
      {if (pickedFile != null)
        {_image = File(pickedFile.path);
        }
       else 
        {print('No image has been selected.');
        }
      });
    }

   void _addNewProduct(String prname, String prtype, String prprice, String prqty)
    {http.post
      (Uri.parse("https://crimsonwebs.com/s270012/myshop/php/newproduct.php"),
       body:
        {"prname":prname,
         "prtype":prtype,
         "prprice":prprice,
         "prqty":prqty
        }
      ).then
        ((response)
          {print(response.body);

           if (response.body=="successsuccess")
            {Fluttertoast.showToast
              (msg: "Added Successfully.",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.green,
               textColor: Colors.white,
               fontSize: 18.0
              );
             Navigator.pop(context);
             Navigator.push(
              context, MaterialPageRoute(builder: (content) => Main()));
            }
           else 
            {Fluttertoast.showToast
              (msg: "Addition Failed.",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.red,
               textColor: Colors.white,
               fontSize: 18.0
              );
            }
          }
        );
    }
  }
