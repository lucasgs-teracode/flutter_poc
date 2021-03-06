import 'package:flutter/material.dart';
import 'package:flutter_poc/presenters/your_medication_presenter.dart';
import 'package:flutter_poc/views/medication_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YourMedicationInterface {
  onboardingOK() {}
}

class YourMedication extends StatefulWidget {
  final YourMedicationPresenter presenter = YourMedicationPresenter();

  @override
  createState() => YourMedicationState();
}

class YourMedicationState extends State<YourMedication>
    implements YourMedicationInterface {
  String med1 = "";
  String med2 = "";
  bool showingAnotherInsulin = false;

  @override
  void initState() {
    super.initState();
    this.widget.presenter.view = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(91, 95, 180, 1),
        elevation: 0,
      ),
      body: _getScreen(context),
      backgroundColor: Color.fromRGBO(91, 95, 180, 1),
    );
  }

  _getScreen(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).yourMedication,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'What diabetes medications are you currently prescribed?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Insulin',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _getMedicationBlock(med1),
                SizedBox(height: 20),
                Visibility(
                  visible: (med1 != "" && !showingAnotherInsulin),
                  child: _getMedicationBlock(med2),
                ),
                Visibility(
                  visible: showingAnotherInsulin,
                  child: Row(
                    children: [
                      Expanded(
                          child: FlatButton(
                        onPressed: med1 != ""
                            ? () {
                                setState(() {
                                  showingAnotherInsulin = false;
                                });
                              }
                            : null,
                        child: Text("Add another insulin..."),
                        color: Color.fromRGBO(91, 95, 180, 1),
                        textColor: Colors.white,
                        disabledTextColor: Color.fromRGBO(91, 95, 180, 0.4),
                        height: 40,
                        disabledColor: Color.fromRGBO(91, 95, 180, 0.2),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: FlatButton(
                      onPressed: med1 != ""
                          ? () {
                              this.widget.presenter.sendOnboarding();
                            }
                          : null,
                      child: Text("Next"),
                      color: Color.fromRGBO(91, 95, 180, 1),
                      textColor: Colors.white,
                      disabledTextColor: Color.fromRGBO(91, 95, 180, 0.4),
                      height: 40,
                      disabledColor: Color.fromRGBO(91, 95, 180, 0.2),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ))
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _getMedicationBlock(String medication) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MedicationList()));

              setState(() {
                if (med1 == "") {
                  med1 = result;
                  showingAnotherInsulin = true;
                } else {
                  med2 = result;
                }
              });
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('lib/assets/log_insulin_generic.png'),
                    height: 40,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 6,
                    child: Text(
                      (medication == "") ? "None" : medication,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Image(
                    image: AssetImage('lib/assets/badge.png'),
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  onboardingOK() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(":)"),
        content: Text("You finished the onboarding flow successfully"),
      ),
    );
  }
}
