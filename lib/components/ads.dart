import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

String appID = dotenv.get('APP');
String bannerID = dotenv.get('BANNER');
String interstitialID = dotenv.get('INTERSTITIAL');

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({super.key});

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  late final BannerAd _bannerAd;
  bool _ready = false;
  AdSize? adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createBannerAd();
  }

  Future<void> _createBannerAd() async {
    final width = MediaQuery.of(context).size.width.truncate();
    adSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width,
    );

    if (adSize == null) {
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
        size: adSize!,
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
    if (_ready && adSize != null) {
      return SizedBox(
        height: adSize!.height.toDouble(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AdWidget(ad: _bannerAd),
        ),
      );
    } else if (_ready && adSize == null) {
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
