import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_info/bloc/crypto_currency_bloc.dart';
import 'package:crypto_info/classes/crypto_currency.dart';
import 'package:crypto_info/global/functions.dart';
import 'package:flutter/material.dart';

class CryptoCurrencyListItem extends StatelessWidget {
  const CryptoCurrencyListItem({
    Key key,
    @required this.cryptoCurrency,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final CryptoCurrency cryptoCurrency;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl:
            "https://static.coincap.io/assets/icons/${cryptoCurrency.symbol.toLowerCase()}@2x.png",
        placeholder: (context, url) =>
            CircleAvatar(radius: 27, child: Text(cryptoCurrency.name[0])),
        errorWidget: (context, url, error) =>
            CircleAvatar(radius: 27, child: Text(cryptoCurrency.name[0])),
      ),
      title: Text(cryptoCurrency.name),
      subtitle: StreamBuilder(
        initialData: "{\"${cryptoCurrency.id}\":${cryptoCurrency.priceUsd}}",
        stream: CryptoCurrencyBloc.instance.getPriceUsdUpdates(cryptoCurrency),
        builder: (context, snapshot) {
          Map<String, dynamic> priceObject = convert.jsonDecode(snapshot.data);
          if (snapshot.hasData && priceObject != null) {
            return Text("\$ " +
                double.parse(priceObject[cryptoCurrency.id].toString() ?? "0")
                    .toStringAsFixed(8));
          }
          return Text("\$ " +
              double.parse(cryptoCurrency.priceUsd ?? "0").toStringAsFixed(8));
        },
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, "crypto-info", arguments: cryptoCurrency);
      },
      onLongPress: () {
        showToast(
          scaffoldKey: _scaffoldKey,
          text: cryptoCurrency.name,
        );
      },
    );
  }
}
