import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/global/functions.dart';
import 'package:crypto_info/pages/loading/loading_screen.dart';
import 'package:crypto_info/widgets/popup_menu_button_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CryptoCurrencyBloc cryptoCurrencyBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cryptoCurrencyBloc = CryptoCurrencyBloc();
    cryptoCurrencyBloc.loadCryptoCurrenciesData();
  }

  @override
  void dispose() {
    super.dispose();
    cryptoCurrencyBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CryptoCurrencyBlocProvider(
      bloc: cryptoCurrencyBloc,
      child: StreamBuilder(
        stream: cryptoCurrencyBloc.cryptoCurrencyStream,
        builder: (context, AsyncSnapshot<List<CryptoCurrency>> snapshot) {
          if (snapshot.hasData) {
            return HomeScreenContent(
                scaffoldKey: _scaffoldKey, snapshot: snapshot);
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    @required AsyncSnapshot<List<CryptoCurrency>> snapshot,
  })  : _scaffoldKey = scaffoldKey,
        _snapshot = snapshot,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final AsyncSnapshot<List<CryptoCurrency>> _snapshot;

  @override
  Widget build(BuildContext context) {
    final cryptoCurrencyBloc = CryptoCurrencyBlocProvider.of(context).bloc;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Crypto Info"),
        elevation: 5,
        actions: <Widget>[
          PopupMenuButtonHome(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await cryptoCurrencyBloc.loadCryptoCurrenciesData();
          return Future.value(null);
        },
        child: SafeArea(
          child: ListView.builder(
            itemCount: _snapshot.data.length,
            itemBuilder: (BuildContext ctx, int i) {
              CryptoCurrency cryptoCurrency = _snapshot.data[i];
              return ListTile(
                leading: CircleAvatar(child: Text(cryptoCurrency.name[0])),
                title: Text(cryptoCurrency.name),
                subtitle: Text("\$ " +
                    double.parse(cryptoCurrency.priceUsd).toStringAsFixed(2)),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  print(cryptoCurrency.toJson());
                },
                onLongPress: () {
                  showToast(
                    scaffoldKey: _scaffoldKey,
                    text: cryptoCurrency.name,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
