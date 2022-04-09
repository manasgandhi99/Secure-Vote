import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepperForm extends StatefulWidget {
  // final BaseAuth auth;
  const StepperForm({Key? key}) : super(key: key);

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  int _activeStepIndex = 0;
  final _electionDetailsFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  late TextEditingController electionDurationController;

  String startDate = "Start Date", endDate = "End Date";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    String initialDurationText = DateFormat.yMMMMd().format(now) + "  - " + DateFormat.yMMMMd().format(DateTime(now.year, now.month, now.day).add(const Duration(days: 10)));
    electionDurationController =  TextEditingController(text :initialDurationText);
  }

  _pickElectionDuration() async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 10)))
  
    );

    if (dateTimeRange != null) {
      setState(() {
        startDate = DateFormat.yMMMMd().format(dateTimeRange.start);
        endDate = DateFormat.yMMMMd().format(dateTimeRange.end);
        electionDurationController.text =   "$startDate - $endDate";
      });
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
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Election Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.004),
                TextFormField(
                  controller: descriptionController,
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
                const SizedBox(height: 8),
                // TextFormField(
                //   controller: startDateController,
                //   // onTap: _pickStartDate,
                //   readOnly: true,
                //   decoration: const InputDecoration(
                //     labelStyle: TextStyle(color: Colors.black),
                //     labelText: 'Start Date',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       borderSide: BorderSide(color: Colors.black),
                //     ),
                //   ),
                // ),
                
                const SizedBox(height: 8),
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
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full House Address',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pincodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pin Code',
                  ),
                ),
              ],
            )),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('Voters'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Name: ${nameController.text}'),
              // Text('Email: ${email.text}'),
              const Text('Password: *****'),
              // Text('Address : ${address.text}'),
              // Text('PinCode : ${pincode.text}'),
            ],
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Election')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeStepIndex,
        steps: stepList(size),
        onStepContinue: () {
          if (_activeStepIndex < (stepList(size).length - 1)) {
            setState(() => _activeStepIndex += 1);
          } else {
            print('Submited');
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
