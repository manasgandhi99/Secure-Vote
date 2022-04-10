import 'dart:convert';
import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:nanoid/nanoid.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/blockchain/blockchain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class CreateElectionForm extends StatefulWidget {
  const CreateElectionForm({Key? key}) : super(key: key);

  @override
  State<CreateElectionForm> createState() => _CreateElectionFormState();
}

class _CreateElectionFormState extends State<CreateElectionForm> {
  int _activeStepIndex = 0;
  var httpClient = Client();
  var ethereumClient;
  List<List<dynamic>> fields = [[]];

  final _electionDetailsFormKey = GlobalKey<FormState>();
  final _candidateDetailsFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  List<String> emails = [];
  late TextEditingController electionDurationController;
  List<TextEditingController> controllers = [TextEditingController()];
  String apiUrl = "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";

  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  late String id;

  TextStyle headerTexstyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    ethereumClient = Web3Client(apiUrl, httpClient);
    
    id = nanoid();
    final now = DateTime.now();
    String initialDurationText = DateFormat.yMMMMd().format(now) +
        "  - " +
        DateFormat.yMMMMd().format(DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 10)));
    electionDurationController =
        TextEditingController(text: initialDurationText);
  }

  String getElectionId() {
    String id = "";
    Random r = Random();
    for (int i=0; i<6; i++) {
      id = id + r.nextInt(9).toString();
    }
    return id;
  }

  _pickElectionDuration() async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      helpText:"Select election duration",
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 10))));

    if (dateTimeRange != null) {
      setState(() {
        startDate = dateTimeRange.start;
        endDate = dateTimeRange.end;
        electionDurationController.text = "$startDate - $endDate";
      });
    }
  }

  Future<void> pickFile() async {
    try{
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["csv"]);
    if (result != null) {
      PlatformFile file = result.files.first;
      String? path = file.path;
      final input = File(path ?? "").openRead();
      fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      emails = List<String>.from(fields[0]);
      print(fields);
    }}catch(e){
      print("error");
    }
  }

  List<Step> stepList(Size size) => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Election Details'),
          content: Form(
            key: _electionDetailsFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value){
                    if(value == null || value.trim().isEmpty){
                      return "Please enter election name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    
                    labelText: 'Election Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                TextFormField(
                  controller: descriptionController,
                  validator: (value){
                    if(value == null || value.trim().isEmpty){
                      return "Please enter election description";
                    }
                    return null;
                  },
                  maxLines: 5,
                  minLines: 3,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                TextFormField(
                  controller: electionDurationController,
                  readOnly: true,
                  onTap: _pickElectionDuration,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Election Duration',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text('Candidates'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                
                Form(
                  key: _candidateDetailsFormKey,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            labelText: "Candidate ${index + 1}",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.blueGrey)),
                            suffixIcon: index > 0
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(
                                        () => controllers.removeAt(index)),
                                  )
                                : null,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter name of candidate ${index + 1}";
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),
                ),
                MaterialButton(
                    onPressed: () => setState(
                        () => controllers.add(TextEditingController())),
                    child: const Text("Add Candidate"),
                    color: Colors.blue[100]),
                SizedBox(height: size.height * 0.04),
              ],
            )),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('Eligible Voters'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               MaterialButton(
                color: Color.fromRGBO(68, 138, 255, 1),
                onPressed: () async{
                  await pickFile();
                  setState(() {
                    
                  });
                },
                child:const Text("Add CSV"),
              ),
              emails.isNotEmpty ? Column(
                children: [
                  Container(
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                )),
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.005, horizontal: 5),
            child: Row(
              children: [
                SizedBox(
                    width: size.width * 0.2,
                    child: Text("Sr. No.", style: headerTexstyle)),
                SizedBox(
                    width: size.width * 0.3,
                    child: Text("Email", style: headerTexstyle)),
               
              ],
            ),
          ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: emails.length,
                    itemBuilder: (context, index) {
                                  return Column(
        children: [
          Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? const Color.fromRGBO(255, 255, 255, 1) : Colors.blue[100],
                      borderRadius: index != emails.length - 1
                          ? BorderRadius.zero
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                    ),padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: size.width * 0.01),
                            width: size.width * 0.2,
                            child: Text((index+1).toString())),
                        Container(
                            width: size.width * 0.2,
                            child: Text(
                              emails[index],
                              softWrap: true,
                            )),
                      ],
                    ),),]
                                
                                  );}),
                ],
              ):SizedBox(),],),),];
          
      


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

     return Scaffold(
       body: Stepper(
          type: StepperType.vertical,
          currentStep: _activeStepIndex,
          steps: stepList(size),
          onStepContinue: () async{
            switch (_activeStepIndex) {
                case 0:
                  if (_electionDetailsFormKey.currentState!.validate()) {
                    setState(() => _activeStepIndex += 1);
                  }
                  break;
                  print("case0");
                case 1:
                  if (_candidateDetailsFormKey.currentState!.validate()) {
                    setState(() => _activeStepIndex += 1);
                  }
                  break;
                  print("case1");
                  //Submit election, candidate and voter details
                  case 2:
                  print('case 2');
                  if (_candidateDetailsFormKey.currentState!.validate() && _electionDetailsFormKey.currentState!.validate()) {
                    if(emails.isNotEmpty){
                      List<String> cand = [];
                      for(int i=0;i<controllers.length;i++){
                        cand.add(controllers[i].text);
                      }
                      
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? privateKey =prefs.getString(PRIVATEKEYSHAREDPREFNAME);
                      print("Got the private key");
                      print(privateKey);

                      if(privateKey != null){
                        print("Private key not null");
                        String code = getElectionId();
                        print("code ${code.toString()}");
                        String result = await Blockchain().transaction('createElection', [code, nameController.text, BigInt.from(controllers.length), BigInt.from(startDate.millisecondsSinceEpoch), BigInt.from(endDate.millisecondsSinceEpoch), cand, fields[0]], ethereumClient, privateKey);
                        print('Final result after creating election: '+result);
                        print("Election created successfully");
                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.email).update({'createdElectionIds':FieldValue.arrayUnion([code])});
                        print("SUCESSSSS");
                        Navigator.pop(context);
                      }else{
                        print("Private key is null");
                        }
                    }
                    else{
                      print("email empty"); 
                    }
                  }else{
                    print("Invalid form(s)");
                  }
                  break;
                  default:
                  print("Default");
              }
            
          },
          onStepCancel: () {
            if (_activeStepIndex == 0) {
              return;
            }
            setState(() => _activeStepIndex -= 1);
          },
          onStepTapped: (int index) => setState(() => _activeStepIndex = index),
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            return Row(
              children: <Widget>[
                MaterialButton(
                  color: Colors.blue,
                  shape: const StadiumBorder(),
                  onPressed: controls.onStepContinue,
                  child: const Text('Continue'),
                ),
                _activeStepIndex != 0
                    ? TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text('Back'),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
     );
  }

  void _showDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: const Text("Election Code"),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text("Candidate Name"),
          // SizedBox(height: size.height * 0.02),
          TextFormField(
            initialValue: id,
            readOnly: true,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              labelText: "Election ID",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),

          MaterialButton(
            child: Icon(Icons.copy),
            onPressed: (){
              FlutterClipboard.copy('hello flutter friends').then(( value ) => print('copied'));
              
            }
          )
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(25.0),
          //   child: MaterialButton(
          //     height: 50,
          //     color: Colors.blue,
          //     textColor: Colors.black,
          //     onPressed: () {
          //       // Navigator.pop(context);
          //     },
          //     child: const Text('VOTE!'),
          //   ),
          // ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
