import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:async';

String appID = dotenv.get('APP');
String bannerID = dotenv.get('BANNER');
String openID = dotenv.get('OPEN');

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({super.key});

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  late final BannerAd _bannerAd;
  bool _ready = false;
  AdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createBannerAd();
  }

  Future<void> _createBannerAd() async {
    final width = MediaQuery.of(context).size.width.truncate();
    _adSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width,
    );

    if (_adSize == null) {
      _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerID,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _ready = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            _ready = false;
            ad.dispose();
          },
        ),
        request: const AdRequest(),
      )..load();
    } else {
      _bannerAd = BannerAd(
        size: _adSize!,
        adUnitId: bannerID,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _ready = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            _ready = false;
            ad.dispose();
          },
        ),
        request: const AdRequest(),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _adSize != null) {
      return SizedBox(
        height: _adSize!.height.toDouble(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AdWidget(ad: _bannerAd),
        ),
      );
    } else if (_ready && _adSize == null) {
      return SizedBox(
        height: 60,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AdWidget(ad: _bannerAd),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class AppOpenAdManager {
  String adUnitId = openID;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  Completer<void> _adLoadCompleter = Completer<void>();

  /* void loadAppOpenAd() {
    AppOpenAd.load(
        adUnitId: openID,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              _appOpenAd = ad;
              _appOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  } */

  Future<void> loadAppOpenAd() async {
    _adLoadCompleter = Completer<void>();

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _adLoadCompleter
              .complete(); // Marcar como completo cuando el anuncio esté cargado.
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _adLoadCompleter
              .complete(); // Marcar como completo incluso en caso de error.
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );

    await _adLoadCompleter
        .future; // Esperar hasta que el anuncio se cargue o falle.
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  bool get isAdShowing {
    return _isShowingAd;
  }

  Future<void> showAdIfAvailable() async {
    if (!isAdAvailable) {
      await loadAppOpenAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) async {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        await loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }
}
