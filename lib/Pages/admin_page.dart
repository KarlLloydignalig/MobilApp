import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paraiso/Utils/database_admin_helper.dart';
import 'package:paraiso/Models/admin_model.dart';
import 'package:paraiso/Utils/city_monicipality_province.dart';
import 'package:paraiso/Utils/my_colors.dart';
import 'package:auto_complete_search/auto_complete_search.dart';
import 'package:paraiso/Utils/database_helper_place.dart';
import 'package:paraiso/Models/places_model.dart';
import 'dart:async';

//googles place



class AdminPage extends StatefulWidget{
  final Admin _admin;
  final List<Place> _places;
  AdminPage(this._admin,this._places);
  @override
  AdminPageState createState() => AdminPageState(_admin,_places);
}

class AdminPageState extends State<AdminPage>{
  Admin _admin;
  //List<Asset> images = List<Asset>();
  String imagesPath = '';
  String imagesPathUpdate = '';
  List<Place> _places;
  Place placeSelected;
  AdminPageState(this._admin,this._places);
  Future<File> _image;
  Future<File> _imageUpdateFuture;
  File _imageUpdate;
  final picker = ImagePicker();
  DataBaseHelperAdmin dataBaseHelperAdmin =  DataBaseHelperAdmin();
  DataBaseHelperPlace dataBaseHelperPlace =  DataBaseHelperPlace();

  GlobalKey key = new GlobalKey<AutoCompleteSearchFieldState<String>>();
  GlobalKey keyUpdateCity = new GlobalKey<AutoCompleteSearchFieldState<String>>();
  GlobalKey keyUpdate = new GlobalKey<AutoCompleteSearchFieldState<Place>>();

  TextEditingController password = new TextEditingController();
  TextEditingController username = new TextEditingController();

  TextEditingController placeStatusController = new TextEditingController();
  TextEditingController selectedPlaceController = new TextEditingController();
  //update
  TextEditingController placeStatusControllerUpdate = new TextEditingController();
  TextEditingController spotNameUpdate = new TextEditingController();
  TextEditingController addressUpdate = new TextEditingController();
  TextEditingController descriptionUpdate = new TextEditingController();
  TextEditingController feesUpdate = new TextEditingController();
  String selectedTagUpdate;
  String coverPhotoPathUpdate;
  bool isSpotUpdate = false;
  Color isSpotColorUpdate = BlueSubmerge.withAlpha(150);
  String isSpotYesUpdate = 'No!';
  //insert
  TextEditingController spotName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController fees = new TextEditingController();
  String selectedTag;
  String coverPhotoPath;
  bool isSpot = false;
  Color updateAdminAccountColor = BlueSubmerge.withAlpha(150);
  Color isSpotColor = BlueSubmerge.withAlpha(150);
  bool isAdminAccountUpdate = false;
  String isSpotYes = 'No!';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Page"),
        ),
        body: FutureBuilder<List<Place>>(
          future: dataBaseHelperPlace.getPlaceList(),
          builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot){
            if(snapshot.hasData){
              _places = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                          child: Text("Toggle to update Admin password and username.")),

                      FlatButton(
                        color: updateAdminAccountColor,
                        child: Text("Update Admin Account",style: TextStyle(color: Colors.white),),
                        onPressed:(){
                          setState(() {
                            if(!isAdminAccountUpdate){
                              updateAdminAccountColor = BlueSubmerge.withAlpha(255);
                              isAdminAccountUpdate = true;
                            }
                            else {
                              updateAdminAccountColor = BlueSubmerge.withAlpha(150);
                              isAdminAccountUpdate = false;
                            }
                          });

                        },
                      ),
                      if(isAdminAccountUpdate)
                        adminUpdate(),

                      Container(
                          margin: EdgeInsets.only(top: 20,bottom: 10),
                          child: Text("Places Data",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                      Column(
                        children: [
                          Container(
                            //constraints: BoxConstraints.expand(width: double.infinity),
                              height: 1500,
                              child: WillPopScope(
                                  onWillPop: () async => true,
                                  child: DefaultTabController(
                                    length: 2,
                                    child:Scaffold(
                                        appBar: AppBar(
                                          toolbarHeight: 75,
                                          automaticallyImplyLeading: false,
                                          bottom: TabBar(
                                            tabs: [
                                              Tab(icon: Icon(Icons.add),text: "Add place",),
                                              Tab(icon: Icon(Icons.update),text: "Update place",),
                                            ],
                                          ),
                                        ),
                                        body: TabBarView(
                                          children: [
                                            Container(
                                              //height: 5000,
                                              //color: Colors.green,
                                              margin: EdgeInsets.only(top: 10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      child: Text("Is Spot?")),
                                                  FlatButton(
                                                    color: isSpotColor,
                                                    child: Text(isSpotYes,style: TextStyle(color: Colors.white),),
                                                    onPressed:(){
                                                      setState(() {
                                                        if(!isSpot){
                                                          isSpotYes = 'Yes!';
                                                          isSpotColor = BlueSubmerge.withAlpha(255);
                                                          isSpot = true;
                                                        }
                                                        else {
                                                          isSpotYes = 'No!';
                                                          isSpotColor = BlueSubmerge.withAlpha(150);
                                                          isSpot = false;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  spotFields()

                                                ],
                                              ) ,
                                            ),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(left: 0,top: 10),
                                                    child: Text("Is Spot?")),
                                                FlatButton(
                                                  color: isSpotColorUpdate,
                                                  child: Text(isSpotYesUpdate,style: TextStyle(color: Colors.white),),
                                                  onPressed:(){
                                                    setState(() {
                                                      if(!isSpotUpdate){
                                                        isSpotYesUpdate = 'Yes!';
                                                        isSpotColor = BlueSubmerge.withAlpha(255);
                                                        isSpotUpdate = true;
                                                      }
                                                      else {
                                                        isSpotYesUpdate = 'No!';
                                                        isSpotColorUpdate = BlueSubmerge.withAlpha(150);
                                                        isSpotUpdate = false;
                                                      }
                                                    });
                                                  },
                                                ),
                                                updatePlace(),
                                              ],
                                            )
                                          ],
                                        )
                                    ),)
                              )
                          ),
                        ],
                      ),
                      //
                    ],
                  ),
                ),
              );
            }
            else return Center(child: CircularProgressIndicator(),);
          },
        )

    );
  }

  Container adminUpdate(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Admin account settings",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          TextField(
            controller: username,
            decoration: InputDecoration(
                hintText: "Your username here.",
                labelText: 'Change username'
            ),
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(
                hintText: "Your password here.",
                labelText: 'Change Password'
            ),
          ),
          FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.blueAccent,
                    width: 1
                ),
              ),
              child: Text("Update"),
              onPressed: (){
                if(username.text.isNotEmpty&&password.text.isNotEmpty){
                  dataBaseHelperAdmin.updateAdmin(_admin,new Admin(username.text,password.text));
                  setState(() {
                    username.clear();
                    password.clear();
                  });
                }
              })
        ],
      ),
    );
  }
  Container updatePlace(){
    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          AutoCompleteSearchField(
            key: keyUpdate,
            suggestions: _places.toSet().toList(),
            controller: selectedPlaceController,
            submitOnSuggestionTap: true,
            clearOnSubmit: false,
            itemSorter: (Place a, Place b) =>
                a.name.toLowerCase().compareTo(b.name.toLowerCase()),

            itemBuilder: (context, place) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Image.asset(place.coverPhotoPath,height: 70,width: 70,)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width-150,
                          child: Text(
                              "Php."+place.fees.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: SunGlow.withAlpha(255)),
                              overflow: TextOverflow.ellipsis
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width-150,
                          child: Text(
                              place.name,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width-150,
                          child: Text(
                              place.location,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis
                          ),
                        )
                      ]),
                ],
              ),
            ),
            itemSubmitted: (Place place) {
              setState(() {
                isSpotUpdate = place.isSpot == 1 ? true : false;
                selectedPlaceController.text = place.name;
                placeSelected = place;
                spotNameUpdate.text = place.name;
                descriptionUpdate.text = place.description;
                _imageUpdate = File(place.coverPhotoPath);
                addressUpdate.text = place.location;
                feesUpdate.text = place.fees.toString();
                selectedTagUpdate = place.tag;
                placeStatusControllerUpdate.text = place.cityName;

              });
            },
            itemFilter: (suggestion, input)
            => suggestion.name.toLowerCase().contains(input.toLowerCase()) ||
                suggestion.cityName.toString().toLowerCase().contains(input.toLowerCase()) ||
                suggestion.location.toString().toLowerCase().contains(input.toLowerCase()),

            decoration: InputDecoration(
                labelText: "Find place on database.",
                //prefixIcon: Icon(Icons.search,color: BlueSubmerge.withAlpha(255),),
                //border: InputBorder.none,
                hintText: "Try \"Cagayan de Oro\""
            ),
          ),
          AutoCompleteSearchField(
            key: keyUpdateCity,
            suggestions: CityProvinceMunicipality.getItems,
            controller: placeStatusControllerUpdate,
            submitOnSuggestionTap: true,
            clearOnSubmit: false,
            itemSorter: (String a, String b) =>
                a.toLowerCase().compareTo(b.toLowerCase()),
            itemBuilder: (context, name) => Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
            ),
            itemSubmitted: (String name) {
              setState(() {
                placeStatusController.text = name;
              });
            },
            itemFilter: (suggestion, input)
            => suggestion.toLowerCase().contains(input.toLowerCase()),
            decoration: InputDecoration(
                labelText: "Select City/Municipality/Province",
                hintText: "Try \"Cagayan de Oro\""
            ),
          ),
          TextField(
            controller: spotNameUpdate,
            decoration: InputDecoration(
                hintText: "Example \"Mapawa Nature Park\"",
                labelText: isSpot ? 'Spot name':'Place Name'
            ),
          ),
          if(isSpotUpdate)
            TextField(
              controller: addressUpdate,
              decoration: InputDecoration(
                  hintText: "Example \"Malasag, Barangay Cugman\"",
                  labelText: 'Full Address'
              ),
            ),
          TextField(
            controller: descriptionUpdate,
            keyboardType: TextInputType.multiline,
            maxLines: 10,

            decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: "You can add details like size of the pool,contact number, etc...",
                labelText: 'Spot Description',
                hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
            ),
          ),
          if(isSpotUpdate)
            TextField(
              keyboardType: TextInputType.number,
              controller: feesUpdate,
              decoration: InputDecoration(
                  hintText: "If there are any.",
                  labelText: 'Fees'
              ),
            ),
          if(isSpotUpdate)
            DropdownButton<String>(
              hint: Text("Select Tag"),
              value: selectedTagUpdate,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.black45,
              ),
              onChanged: (String newValue) {
                setState(() {
                  selectedTagUpdate = newValue;
                });
              },
              items: <String>['Sleep', 'Eat', 'Relax', 'Experience']
                  .map<DropdownMenuItem<String>>((String value) {
                IconData icon;

                switch(value){
                  case 'Sleep':
                    icon = Icons.hotel;
                    break;
                  case 'Eat':
                    icon = Icons.local_dining;
                    break;
                  case 'Relax':
                    icon = Icons.self_improvement;
                    break;
                  case 'Experience':
                    icon = Icons.tour;
                    break;
                }

                return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(value),
                        Container(
                            margin: EdgeInsets.only(left: 3),
                            child: Icon(icon))
                      ],)
                );
              }).toList(),
            ),
          FlatButton(
            color: BlueSubmerge.withAlpha(200),
            child: Text("Select place cover photo.",style: TextStyle(color: Colors.white),),
            onPressed:(){
              getImageFromGallery(ImageSource.gallery,true);
            },
          ),
          if(_imageUpdate!=null)
            Container(
              width: 300,
              height: 300,
              child: _imageUpdateFuture!=null? showImage(true): Image.file(_imageUpdate),
            ),
          FlatButton(
            color: BlueSubmerge.withAlpha(200),
            child: Text("Add photo gallery",style: TextStyle(color: Colors.white),),
            onPressed:() async{

              List<File> files = await FilePicker.getMultiFile(
                type: FileType.custom,
                allowedExtensions: ['jpg'],
              );
              setState(() {
                for(int i = 0; i <= files.length -1;i++){
                  //print(files[i].path);
                  imagesPathUpdate += files[i].path+",";
                }
                imagesPathUpdate+=","+placeSelected.getGallery()!=null ? placeSelected.getGallery(): '';
              });
            },

          ),
          if(placeSelected!=null)
            if(placeSelected.getGallery()!=null)
              Container(
                height: 200,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(imagesPathUpdate==null?placeSelected.getGallery().split(',').length:imagesPathUpdate.split(',').length, (index)  {
                    //print(placeSelected.getGallery());
                    Image image = Image.file(File(imagesPathUpdate==null?placeSelected.getGallery().split(',')[index]:imagesPathUpdate.split(',')[index]),fit: BoxFit.cover,filterQuality: FilterQuality.low,);
                    //print(imagesPath);
                    return Container(
                      width: 100,
                      height: 100,
                      child: image,
                    );
                  }),
                ),
              ),
          Container(
              child:FlatButton(
                minWidth: double.infinity,
                color: BlueSubmerge.withAlpha(200),
                child: Text("Update",style: TextStyle(color: Colors.white),),
                onPressed: () async{

                  setState(() {
                    bool isSuccess = false;
                    if(coverPhotoPathUpdate == null){
                      coverPhotoPathUpdate = placeSelected.coverPhotoPath;
                    }
                    if(isSpotUpdate){
                      if(selectedTagUpdate.isNotEmpty&&spotNameUpdate.text.isNotEmpty&&
                          addressUpdate.text.isNotEmpty&&descriptionUpdate.text.isNotEmpty&&
                          placeStatusControllerUpdate.text.isNotEmpty){

                        print(placeSelected.id);
                        Place place = new Place(spotNameUpdate.text,placeStatusControllerUpdate.text,addressUpdate.text,descriptionUpdate.text,1,selectedTagUpdate,double.parse(feesUpdate.text),0,coverPhotoPathUpdate,
                            photoGallery: imagesPathUpdate==null?'':imagesPathUpdate);
                        place.id = placeSelected.id;
                        dataBaseHelperPlace.updatePlace(placeSelected,place);
                        isSuccess = true;
                      }
                    }
                    else{
                      if(spotNameUpdate.text.isNotEmpty&&descriptionUpdate.text.isNotEmpty&&coverPhotoPathUpdate.isNotEmpty&&placeStatusControllerUpdate.text.isNotEmpty){
                        Place place = new Place(spotNameUpdate.text,placeStatusControllerUpdate.text,placeStatusControllerUpdate.text,descriptionUpdate.text,0,'all',0.0,0,coverPhotoPathUpdate,
                            photoGallery: imagesPathUpdate==null?'':imagesPathUpdate);
                        place.id = placeSelected.id;
                        dataBaseHelperPlace.updatePlace(placeSelected,place);
                        isSuccess = true;
                      }
                    }
                    if(isSuccess){
                      _imageUpdateFuture = null;
                      _showMyDialog(context,Text("Successful"),clearUpdateFields);
                    }
                    else{
                      _showMyDialog(context,Text("Successful"),null);
                    }
                  });

                },)
          ),
          Container(
              child:FlatButton(
                minWidth: double.infinity,
                color: Colors.red[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("LongPress  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                    Text("To Delete",style: TextStyle(color: Colors.white,fontSize: 12),),
                  ],),
                onLongPress: (){
                  setState(() {
                    dataBaseHelperPlace.deletePlace(placeSelected.name, placeSelected.id);
                    _showMyDialog(context,Text("Successful Deleted:"+placeSelected.name),clearUpdateFields);
                    showImage(true);
                  });
                },
              )
          ),
        ],
      ),
    );
  }
  Container spotFields(){
    return Container(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoCompleteSearchField(
              key: key,
              suggestions: CityProvinceMunicipality.getItems,
              controller: placeStatusController,
              submitOnSuggestionTap: true,
              clearOnSubmit: false,
              itemSorter: (String a, String b) =>
                  a.toLowerCase().compareTo(b.toLowerCase()),
              itemBuilder: (context, name) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              ),
              itemSubmitted: (String name) {
                setState(() {
                  placeStatusController.text = name;
                });
              },
              itemFilter: (suggestion, input)
              => suggestion.toLowerCase().contains(input.toLowerCase()),
              decoration: InputDecoration(
                  labelText: "Select City/Municipality/Province",
                  hintText: "Try \"Cagayan de Oro\""
              ),
            ),
            TextField(
              controller: spotName,
              decoration: InputDecoration(
                  hintText: "Example \"Mapawa Nature Park\"",
                  labelText: isSpot ? 'Spot name':'Place Name'
              ),
            ),
            if(isSpot)
              TextField(
                controller: address,
                decoration: InputDecoration(
                    hintText: "Example \"Malasag, Barangay Cugman\"",
                    labelText: 'Full Address'
                ),
              ),
            TextField(
              controller: description,
              keyboardType: TextInputType.multiline,
              maxLines: 10,

              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: "You can add details like size of the pool,contact number, etc...",
                  labelText: 'Spot Description',
                  hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
              ),
            ),
            if(isSpot)
              TextField(
                keyboardType: TextInputType.number,
                controller: fees,
                decoration: InputDecoration(
                    hintText: "If there are any.",
                    labelText: 'Fees'
                ),
              ),
            if(isSpot)
              DropdownButton<String>(
                hint: Text("Select Tag"),
                value: selectedTag,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.black45,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    selectedTag = newValue;
                  });
                },
                items: <String>['Sleep', 'Eat', 'Relax', 'Experience']
                    .map<DropdownMenuItem<String>>((String value) {
                  IconData icon;

                  switch(value){
                    case 'Sleep':
                      icon = Icons.hotel;
                      break;
                    case 'Eat':
                      icon = Icons.local_dining;
                      break;
                    case 'Relax':
                      icon = Icons.self_improvement;
                      break;
                    case 'Experience':
                      icon = Icons.tour;
                      break;
                  }

                  return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(value),
                          Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Icon(icon))
                        ],)
                  );
                }).toList(),
              ),
            FlatButton(
              color: BlueSubmerge.withAlpha(200),
              child: Text("Select place cover photo.",style: TextStyle(color: Colors.white),),
              onPressed:(){
                getImageFromGallery(ImageSource.gallery,false);
              },
            ),
            Container(
              width: 300,
              height: 300,
              child: showImage(false),
            ),
            FlatButton(
              color: BlueSubmerge.withAlpha(200),
              child: Text("Add photo gallery",style: TextStyle(color: Colors.white),),
              onPressed:() async{

                List<File> files = await FilePicker.getMultiFile(
                  type: FileType.custom,
                  allowedExtensions: ['jpg'],
                );
                setState(() {
                  for(int i = 0; i <= files.length -1;i++){
                    //print(files[i].path);
                    imagesPath += files[i].path+",";
                  }
                });
              },

            ),
            Container(
              height: 200,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(imagesPath.split(',').length, (index)  {

                  Image image = Image.file(File(imagesPath.split(',')[index]),fit: BoxFit.cover,filterQuality: FilterQuality.low,);
                  //print(imagesPath);
                  return Container(
                    width: 100,
                    height: 100,
                    child: image,
                  );
                }),
              ),
            ),
            Container(
                child:FlatButton(
                  minWidth: double.infinity,
                  color: BlueSubmerge.withAlpha(200),
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                  onPressed: ()async{
                    setState(() {

                      bool isSuccess = false;//
                      if(isSpot){

                        if(selectedTag != null&&spotName.text.isNotEmpty&&
                            address.text.isNotEmpty&&description.text.isNotEmpty&&
                            coverPhotoPath!=null&&placeStatusController.text.isNotEmpty){
                          dataBaseHelperPlace.insertPlace(new Place(spotName.text,placeStatusController.text,address.text,description.text,1,selectedTag,double.parse(fees.text),0,coverPhotoPath
                              ,photoGallery: imagesPath!=null? imagesPath : ''));
                          print(imagesPath+"----------------------------");
                          isSuccess = true;
                        }
                      }
                      else{
                        if(spotName.text.isNotEmpty&&description.text.isNotEmpty&&coverPhotoPath!=null&&placeStatusController.text.isNotEmpty){
                          dataBaseHelperPlace.insertPlace(new Place(spotName.text,placeStatusController.text,placeStatusController.text,description.text,0,'all',0.0,0,coverPhotoPath,
                              photoGallery: imagesPath!=null? imagesPath : ''));
                          isSuccess = true;
                        }
                      }
                      if(isSuccess){

                        _image = null;
                        _showMyDialog(context,Text("Successful"),clearAddFields);
                      }
                      else{
                        _showMyDialog(context,Text("Failed"),null);
                      }
                    });
                  },)
            ),
          ],
        )
    );
  }
  getImageFromGallery(ImageSource source,bool isUpdate)  {
    setState(() {
      if(isUpdate){
        _imageUpdateFuture = ImagePicker.pickImage(source: source);
      }
      else{
        _image = ImagePicker.pickImage(source: source);
      }

    });

  }
  Widget showImage(bool isUpdate){
    return FutureBuilder(
      future:isUpdate ? _imageUpdateFuture:_image,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot){
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          if(isUpdate) coverPhotoPathUpdate = snapshot.data.path;
          else coverPhotoPath = snapshot.data.path;
          return Image.file(
            snapshot.data,
            fit:BoxFit.scaleDown,

          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future<void> _showMyDialog(BuildContext mainContext,Text text,Function function) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                text
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Confirm'),
                onPressed: () {

                  //print(_places.length);
                  if(function!=null){
                    function.call();
                  }

                  Navigator.of(context).pop();
                }
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  void clearUpdateFields(){
    isSpotUpdate = false;
    selectedPlaceController.clear();
    placeSelected = null;
    spotNameUpdate.clear();
    descriptionUpdate.clear();
    _imageUpdate = null;
    addressUpdate.clear();
    feesUpdate.clear();
    selectedTagUpdate = '';
    _imageUpdateFuture = null;
    _image = null;
    placeStatusControllerUpdate.clear();
    if(coverPhotoPathUpdate == null){
      coverPhotoPathUpdate = null;
    }
    showImage(true);
  }
  void clearAddFields(){
    isSpot = false;
    spotName.clear();
    description.clear();
    _image = null;
    address.clear();
    fees.clear();
    selectedTag = '';
    placeStatusController.clear();
    showImage(false);
  }

  Future<void> pickImage() async{
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
  }

}