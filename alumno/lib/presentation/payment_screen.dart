/* import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mercado_youtube/screen/item_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  static const String routename = 'PaymentScreen';
  final String? url;

  const PaymentScreen({super.key, this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && context.mounted) {
        String path = uri.host;
        bool isSuccess = false;
        if (path == 'success') {
          _verificarEstadoPago(context);
        } else {
          Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
        }
      }
    }, onError: (err) {
      debugPrint('Error al manejar los deep links: $err');
    });
  }

  Future<void> _verificarEstadoPago(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/verificar_estado_pago'));

      if (response.statusCode == 201) {
        bool isSuccess = true;
        Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
      } else {
        bool isSuccess = false;
        Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
      }
    } catch (e) {
      debugPrint('Error al verificar el estado del pago: $e');
      bool isSuccess = false;
      Navigator.pushReplacementNamed(context, ItemScreen.routename, arguments: isSuccess);
    }
  }

  void _launchURL(BuildContext context, String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La URL no es válida')),
      );
      return;
    }

    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: false,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
        ),
      );
    } catch (e) {
      debugPrint('Error al abrir la URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _launchURL(context, widget.url),
            child: const Text('Pagar con MercadoPago'),
          ),
        ),
      ),
    );
  }
} */

import 'package:alumno/presentation/clases_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  static const String routename = 'PaymentScreen';
  final String? url;
  final DateTime date;

  const PaymentScreen({super.key, this.url, required this.date});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _sub;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && context.mounted) {
        String path = uri.host;
        bool isSuccess = false;
        if (path == 'success') {
          //_verificarEstadoPago(context);
          bool isSuccess = true;

          Map<DateTime, bool> arguments = {widget.date: isSuccess};
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ClasesScreen(
                      date: widget.date,
                    )),
          );

          // Navigator.pushReplacementNamed(context, ClasesScreen.name, arguments: arguments);
        } else {
          Map<DateTime, bool> arguments = {widget.date: isSuccess};
          Navigator.pushReplacementNamed(context, ClasesScreen.name,
              arguments: arguments);
        }
      }
    }, onError: (err) {
      debugPrint('Error al manejar los deep links: $err');
    });
  }

  Future<void> _verificarEstadoPago(BuildContext context) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/verificar_estado_pago'));

      if (response.statusCode == 201) {
        bool isSuccess = true;
        Map<DateTime, bool> arguments = {widget.date: isSuccess};
        Navigator.pushReplacementNamed(context, ClasesScreen.name,
            arguments: arguments);
      } else {
        bool isSuccess = false;
        Map<DateTime, bool> arguments = {widget.date: isSuccess};
        Navigator.pushReplacementNamed(context, ClasesScreen.name,
            arguments: arguments);
      }
    } catch (e) {
      debugPrint('Error al verificar el estado del pago: $e');
      bool isSuccess = false;
      Map<DateTime, bool> arguments = {widget.date: isSuccess};
      Navigator.pushReplacementNamed(context, ClasesScreen.name,
          arguments: arguments);
    }
  }

  Future<void> _launchUrl(BuildContext context, String? url) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(url!),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
            navigationBarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

/*   void _launchURL(BuildContext context, String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La URL no es válida')),
      );
      return;
    }

    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: false,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
        ),
      );
    } catch (e) {
      debugPrint('Error al abrir la URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la URL')),
      );
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () async => await _launchUrl(context, widget.url),
            child: const Text('Pagar con MercadoPago'),
          ),
        ),
      ),
    );
  }
}
