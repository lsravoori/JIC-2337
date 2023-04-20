import 'package:flutter/material.dart';
import '../../../functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminStats extends StatefulWidget {
  const AdminStats({super.key});
  @override
  State<AdminStats> createState() => _AdminStats();
}

class _AdminStats extends State<AdminStats> {
  int acctCount = 0,
      maleAccts = 0,
      femaleAccts = 0,
      nonBinaryAccts = 0,
      otherAccts = 0,
      whiteAccts = 0,
      blackAccts = 0,
      hispanicAccts = 0,
      midEasternAccts = 0,
      asianAccts = 0,
      pacificIslanderAccts = 0,
      nativeAmAccts = 0,
      twoPlusAccts = 0,
      otherRaceAccts = 0,
      lqbtqAccts = 0;

  int busCount = 0,
      femaleBus = 0,
      nonBinaryBus = 0,
      blackBus = 0,
      hispanicBus = 0,
      midEasternBus = 0,
      asianBus = 0,
      pacificIslanderBus = 0,
      nativeAmBus = 0,
      lqbtqBus = 0;

  Future<QuerySnapshot> getData() async {
    FirebaseFirestore.instance.collection('Accounts').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        acctCount++;
        if (doc['Gender'] == 'Man') {
          maleAccts++;
        } else if (doc['Gender'] == 'Woman') {
          femaleAccts++;
        } else if (doc['Gender'] == 'Non-binary') {
          nonBinaryAccts++;
        } else if (doc['Gender'] == 'Other') {
          otherAccts++;
        }
        if (doc['Race'] == 'White') {
          whiteAccts++;
        } else if (doc['Race'] == 'Black') {
          blackAccts++;
        } else if (doc['Race'] == 'Hispanic') {
          hispanicAccts++;
        } else if (doc['Race'] == 'Middle Eastern') {
          midEasternAccts++;
        } else if (doc['Race'] == 'Asian') {
          asianAccts++;
        } else if (doc['Race'] == 'Pacific Islander') {
          pacificIslanderAccts++;
        } else if (doc['Race'] == 'Native American') {
          nativeAmAccts++;
        } else if (doc['Race'] == 'Two or More Ethnicities') {
          twoPlusAccts++;
        } else if (doc['Race'] == 'Other') {
          otherRaceAccts++;
        }
        if (doc['LGBTQ+'] == true) {
          lqbtqAccts++;
        }
      });
    });

    FirebaseFirestore.instance.collection('Businesses').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        busCount++;
        if (doc["Category"] == 'Women') {
          femaleBus++;
        } else if (doc["Category"] == 'Non-Binary') {
          nonBinaryBus++;
        } else if (doc["Category"] == 'LGBT+') {
          lqbtqBus++;
        } else if (doc['Category'] == 'Black') {
          blackBus++;
        } else if (doc['Category'] == 'Hispanic') {
          hispanicBus++;
        } else if (doc['Category'] == 'Middle Eastern') {
          midEasternBus++;
        } else if (doc['Category'] == 'Asian') {
          asianBus++;
        } else if (doc['Category'] == 'Pacific Islander') {
          pacificIslanderBus++;
        } else if (doc['Category'] == 'Native American') {
          nativeAmBus++;
        }
      });
    });
    return await FirebaseFirestore.instance.collection('Businesses').get();
  }

  int _selectedIndex = 1; //this is the page we are on

  Scaffold makeScaffold() {
    return Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text(
            'Administrator Statistics',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          backgroundColor: const Color(0xFFD67867),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: makeChildren()),
        ),
        bottomNavigationBar: Functions.adminNavBar(_selectedIndex, (int index) {
          //logic for nav bar
          setState(() {
            _selectedIndex = index;
          });
          Functions.onTapAdmin(index, context);
        }));
  }

  List<Widget> makeChildren() {
    List<Widget> list = [];
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Text(
        'Total Accounts: $acctCount',
        style: const TextStyle(fontSize: 20),
      ),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Male: $maleAccts (${(maleAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Female: $femaleAccts (${(femaleAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Non-Binary: $nonBinaryAccts (${(nonBinaryAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Other Genders: $otherAccts (${(otherAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'White: $whiteAccts (${(whiteAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Black: $blackAccts (${(blackAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Hispanic: $hispanicAccts (${(hispanicAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Middle Eastern: $midEasternAccts (${(midEasternAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Asian: $asianAccts (${(asianAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Pacific Islander: $pacificIslanderAccts (${(pacificIslanderAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Native American: $nativeAmAccts (${(nativeAmAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Two or More Ethnicities: $twoPlusAccts (${(twoPlusAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Other Ethnicities: $otherRaceAccts (${(otherRaceAccts / acctCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'LGBTQ+: $lqbtqAccts (${(lqbtqAccts / acctCount).toStringAsFixed(2)}%)'),
    ));

    list.add(const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Text(''),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Text('Total Businesses: $busCount',
          style: const TextStyle(fontSize: 20)),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Female: $femaleBus (${(femaleBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Non-Binary: $nonBinaryBus (${(nonBinaryBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Black: $blackBus (${(blackBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Hispanic: $hispanicBus (${(hispanicBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Middle Eastern: $midEasternBus (${(midEasternBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Asian: $asianBus (${(asianBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Pacific Islander: $pacificIslanderBus (${(pacificIslanderBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'Native American: $nativeAmBus (${(nativeAmBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Text(
          'LGBTQ+: $lqbtqBus (${(lqbtqBus / busCount).toStringAsFixed(2)}%)'),
    ));
    list.add(const Text(
        'This is just here to make sure that the scroll-view covers the entire applicaiton. It is white so should not show unless the background is changed.',
        style: TextStyle(fontSize: 20, color: Colors.white)));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    //builds the UI screen
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return makeScaffold();
        } else {
          return const Scaffold();
        }
      },
    );
  }
}
