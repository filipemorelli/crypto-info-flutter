import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/classes/crypto_currency.dart';
import 'package:crypto_info/global/constants.dart';
import 'package:crypto_info/global/functions.dart';
import 'package:crypto_info/widgets/crypto_currency_item.dart';
import 'package:crypto_info/widgets/popup_menu_button_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    CryptoCurrencyBloc.instance.loadCryptoCurrenciesData().catchError((e) {
      showToast(
          scaffoldKey: _scaffoldKey,
          text: "Não foi possivel buscar os dados no servidor.");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CryptoCurrencyBloc.instance.cryptoCurrencyStream,
      builder: (context, AsyncSnapshot<List<CryptoCurrency>> snapshot) {
        return HomeScreenContent(scaffoldKey: _scaffoldKey, snapshot: snapshot);
      },
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Crypto Info"),
        actions: <Widget>[
          PopupMenuButtonHome(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await CryptoCurrencyBloc.instance.loadCryptoCurrenciesData();
          } catch (e) {
            showToast(
              scaffoldKey: _scaffoldKey,
              text: "Não foi possivel buscar os dados no servidor.",
            );
          }
          return Future.value(null);
        },
        child: SafeArea(
          bottom: false,
          child: buildCryptoCurrenciesList(context),
        ),
      ),
    );
  }

  Widget buildCryptoCurrenciesList(BuildContext context) {
    return _snapshot.hasData
        ? Scrollbar(
            child: ListView.builder(
              itemCount: _snapshot.data.length,
              itemBuilder: (BuildContext ctx, int i) {
                CryptoCurrency cryptoCurrency = _snapshot.data[i];
                return CryptoCurrencyListItem(
                  cryptoCurrency: cryptoCurrency,
                  scaffoldKey: _scaffoldKey,
                );
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: spaceSize),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()],
            ),
          );
  }
}
