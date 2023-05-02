import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'country.dart';

void main() => runApp(const CountrySearchPage());

class FlagWidget extends StatelessWidget {
  final String countryCode;
  
  const FlagWidget({super.key, required this.countryCode});

  @override
  Widget build(BuildContext context){
    return Image.network(
      "https://flagsapi.com/$countryCode/flat/64.png",
      width : 64,
      height : 64,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        // If the flag image cannot be loaded, display an empty placeholder image
        return Image.asset(
          "assets/images/white.png",
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        );
      },
    );
  }
}

class CountrySearchPage extends StatefulWidget {
  const CountrySearchPage({Key? key}): super(key:key);
  
   @override
  State<CountrySearchPage> createState() => _CountrySearchPageState();
}

class _CountrySearchPageState extends State<CountrySearchPage> {
  TextEditingController textEditingController = TextEditingController();
  var selectCountry = "";
  var countryCode = "No Records";
  
  var country = "No Records", capital = "No Records", region = "No Records", curCode = "No Records", curName = "No Records", surArea = 0.0, populat = 0.0, gdp = 0.0;
  
  Country searchCountry = Country("Not Available","No Records", "No Records", "No Records", "No Records", "No Records", 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Data Search App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country Data Search App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Text("Search for Country Data", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "Country Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ),
                ),
                  ElevatedButton(onPressed : _searchCountry, child: const Text("Search")),
                  Expanded(child: CountryGrid(
                    searchCountry: searchCountry,),),
              ]
              ,
            ),
          ),
        ),
      ),
    );
  }

  _searchCountry() async {
    selectCountry = textEditingController.text;
    
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
   
   String apiid = "te5dKFyVPaLrp0A3GQ9sYg==IaUdZiJ3u4qRifiM";
   
   var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$selectCountry');
   var response = await http.get(url, headers: {"X-Api-Key": apiid});
   
   // ignore: use_build_context_synchronously
    var rescode = response.statusCode;
    progressDialog.dismiss();
    if (rescode == 200) {
      // ignore: avoid_print
      print("rescode = 200");
      var jsonData = response.body;
      List parsedJson = json.decode(jsonData);
      if (selectCountry != "" && parsedJson.isNotEmpty){
        setState(() {
          country = parsedJson[0]["name"];
          countryCode = parsedJson[0]["iso2"];
          capital = parsedJson[0]["capital"];
          region = parsedJson[0]["region"];
          curCode = parsedJson[0]['currency']['code'];
          curName = parsedJson[0]['currency']['name'];
          surArea = parsedJson[0]['surface_area'];
          populat = parsedJson[0]['population'];
          gdp = parsedJson[0]['gdp'];
          searchCountry = Country(country, countryCode, capital, region, curCode, curName, surArea, populat, gdp);

          Fluttertoast.showToast(
            msg: "Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        });
      } else {
          setState(() {
            country = "No record";
            countryCode = "No record";
            capital = "No record";
            region = "No record";
            curCode = "No record";
            curName = "No record";
            surArea = 0.0;
            populat = 0.0;
            gdp = 0.0;
            searchCountry = Country(country, countryCode, capital, region, curCode, curName, surArea, populat, gdp);

            Fluttertoast.showToast(
              msg: "The search country is not found.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          });
        
        }

    } else {
        setState(() {
          country = "No record";
          countryCode = "No record";
          capital = "No record";
          region = "No record";
          curCode = "No record";
          curName = "No record";
          surArea = 0.0;
          populat = 0.0;
          gdp = 0.0;
          searchCountry = Country(country, countryCode, capital, region, curCode, curName, surArea, populat, gdp);

          Fluttertoast.showToast(
            msg: "The search country is not found.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        });
        
        // ignore: avoid_print
        print(response.statusCode);
    }
  }
}

class CountryGrid extends StatefulWidget {
  final Country searchCountry;
  const CountryGrid({Key? key, required this.searchCountry}) : super(key: key);

  @override
  State<CountryGrid> createState() => _CountryGridState();
}

class _CountryGridState extends State<CountryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Country"),
              FlagWidget(countryCode: widget.searchCountry.countryCode),
              Text(widget.searchCountry.country)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Capital"),
              const Icon(Icons.location_city_rounded, size: 64,),
              Text(widget.searchCountry.capital)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Region"),
              const Icon(Icons.location_on_rounded, size: 64,),
              Text(widget.searchCountry.region)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Currency Code"),
              const Icon(Icons.attach_money_rounded, size: 64,),
              Text(widget.searchCountry.curCode)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Currency Name"),
              const Icon(Icons.money_rounded, size: 64,),
              Text(widget.searchCountry.curName)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Surface Area"),
              const Icon(Icons.area_chart_rounded, size: 64,),
              Text(widget.searchCountry.surArea.toString())
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Population"),
              const Icon(Icons.location_history_rounded, size: 64,),
              Text(widget.searchCountry.populat.toString())
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("GDP"),
              const Icon(Icons.trending_up_rounded, size: 64,),
              Text(widget.searchCountry.gdp.toString())
            ],
          ),
        ),
      ],
    );
  }
}