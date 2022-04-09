import 'package:flutter/material.dart';

class StepperForm extends StatefulWidget {
  // final BaseAuth auth;
  StepperForm();

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int _activeStepIndex = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Information'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'Election Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                 TextFormField(
                  controller: description,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                 TextFormField(
                  controller: start_date,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'Start Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                 ),
                const SizedBox(
                  height: 8,
                ),
                 TextFormField(
                  controller: end_date,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelText: 'End Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        )
        // ),
        // Step(
        //     state:
        //         _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
        //     isActive: _activeStepIndex >= 1,
        //     title: const Text('Candidates'),
        //     content: Container(
        //       child: Column(
        //         children: [
        //           const SizedBox(
        //             height: 8,
        //           ),
        //           TextField(
        //             controller: address,
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: 'Full House Address',
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 8,
        //           ),
        //           TextField(
        //             controller: pincode,
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: 'Pin Code',
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
        // Step(
        //     state: StepState.complete,
        //     isActive: _activeStepIndex >= 2,
        //     title: const Text('Voters'),
        //     content: Container(
        //         child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Text('Name: ${name.text}'),
        //         Text('Email: ${email.text}'),
        //         const Text('Password: *****'),
        //         Text('Address : ${address.text}'),
        //         Text('PinCode : ${pincode.text}'),
        //       ],
        //     )))
      ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Stepper'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            setState(() {
              _activeStepIndex += 1;
            });
          } else {
            print('Submited');
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }
          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
                  return Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: controls.onStepContinue,
                        child: const Text('Hello'),
                      ),
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: const Text('World'),
                      ),
                    ],
                  );
                },
      ),
    );
  }
}