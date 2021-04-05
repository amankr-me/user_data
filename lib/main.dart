
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_data/provider/language.dart';
import 'package:user_data/provider/user.dart';
import 'package:user_data/provider/users.dart';
import 'package:provider/provider.dart';
import 'package:user_data/settings.dart';
import 'package:user_data/success.dart';
import 'package:user_data/users_screen.dart';
import 'package:user_data/util/theme_notifier.dart';
import 'package:user_data/values/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user_data/localization/language_constants.dart';


void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Users(),
          // value: Products(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkTheme),
        ),
      ],
      child:MyApp()),);
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
        print(_locale);
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    }else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: themeNotifier.getTheme(),
        locale: _locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: [
          const Locale('en', 'US'), // English, no country code
          const Locale('hi', 'IN'), // Spanish, no country code
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Save User Data'),
        routes: {
          Success.routeName: (ctx) => Success(),
          UserScreen.routeName: (ctx) => UserScreen(),
          SettingsPage.routeName: (ctx) => SettingsPage(),
        },

      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _genderFocusNode = FocusNode();
  final _calendarFocusNode = FocusNode();
  var _newUser = User(id: null, name: '', gender: '', dob: null);
  var _initValues = {
    'name': '',
    'gender': 'Male',
    'age': '',
  };

  String _gender ='Male';
  DateTime _dateTime;
  final _form = GlobalKey<FormState>();

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

      try {
        await Provider.of<Users>(context, listen: false)
            .addUser(_newUser);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      Navigator.of(context).pushNamed(Success.routeName);
    // }

    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
  }
  void _onchangeLanguage(Language language) async{
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
    print(language.languageCode);
  }


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calendarFocusNode.dispose();
    _genderFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'home_page')),
        actions: [

          Padding(padding: EdgeInsets.all(8),
          child: DropdownButton(
            underline: SizedBox() ,
              icon: Icon(Icons.language,color: Colors.white,),
              items: Language.languageList().map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                  value: lang,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                Text(lang.flag),
                Text(lang.name),
              ],))).toList(),
              onChanged: (Language language){
                _onchangeLanguage(language);
              }),
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: (){
            Navigator.of(context).pushNamed(SettingsPage.routeName);
          }),
        ],
      ),
      body: Center(
        child: Form(
            key: _form,
            child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: _initValues['name'],
              decoration: InputDecoration(labelText: 'Name',labelStyle: TextStyle(color: Colors.grey)),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_genderFocusNode);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide the Name';
                }
                return null;
              },
              onSaved: (newValue) {
                _newUser = User(
                  id: _newUser.id,
                  name: newValue,
                  gender: _newUser.gender,
                  dob: _newUser.dob,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Gender',textAlign: TextAlign.start,style: TextStyle(fontSize: 16.0),),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value){

                        setState(() {
                          _newUser = User(
                            id: _newUser.id,
                            name: _newUser.name,
                            gender: value,
                            dob: _newUser.dob,
                          );                          _gender= value;
                        });
                        FocusScope.of(context).requestFocus(_calendarFocusNode);
                      },
                    ),
                    Text(
                      'Male',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Radio(
                      value: 'Female',
                      focusNode: _genderFocusNode,
                      groupValue: _gender,
                      onChanged: (value){

                        setState(() { _newUser = User(
                          id: _newUser.id,
                          name: _newUser.name,
                          gender: value,
                          dob: _newUser.dob,
                        );
                        _gender= value;
                        FocusScope.of(context).requestFocus(_calendarFocusNode);
                        });

                      },
                    ),
                    Text(
                      'Female',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),

                 Row(
                   children: [
                     Radio(
                      value: 'TransGender',
                      groupValue: _gender,
                      onChanged: (value){
                        setState(() { _newUser = User(
                          id: _newUser.id,
                          name: _newUser.name,
                          gender: value,
                          dob: _newUser.dob,
                        );
                        _gender= value;
                        });
                        FocusScope.of(context).requestFocus(_calendarFocusNode);
                      },
                ),
                     Text(
                       'Transgender',
                       style: new TextStyle(fontSize: 16.0),
                     ),
                   ],
                 ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('Date of Birth',style: TextStyle(fontSize: 16.0),),
                      TextButton(
                        focusNode: _calendarFocusNode,
                        child: _dateTime==null?Text('${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}'):Text('${_dateTime.day.toString()}/${_dateTime.month.toString()}/${_dateTime.year.toString()}'),
                        onPressed: (){
                          showDatePicker(
                              context: context,
                              initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                              firstDate: DateTime(1951),
                              lastDate: DateTime(2030),
                          ).then((date) {
                            setState(() {
                              _dateTime = date; _newUser = User(
                                id: _newUser.id,
                                name: _newUser.name,
                                gender: _newUser.gender,
                                dob: date,
                              );
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
                RaisedButton(child:Text('Save'),onPressed: (){
                  _saveForm();print(_newUser.dob.year);
                }),
              ],
            ),
          )
        ],))
      ),
      floatingActionButton: FloatingActionButton(child:Icon(Icons.person_pin),onPressed: (){
        Navigator.of(context).pushNamed(UserScreen.routeName);
      }),
    );
  }


}
