import 'dart:async';
import 'package:flutter/material.dart';
import '../core/brand.dart';
import '../core/l10n.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _c = PageController(viewportFraction: 0.92);
  int _i = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_c.hasClients) return;
      _c.animateToPage((_i + 1) % Brand.banners.length,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 186,
        child: PageView.builder(
          controller: _c,
          itemCount: Brand.banners.length,
          onPageChanged: (i) => setState(() => _i = i),
          itemBuilder: (_, i) {
            final b = Brand.banners[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: b.colors),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                          color: b.colors.first.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: Stack(children: [
                    PositionedDirectional(
                      end: -10,
                      bottom: -6,
                      top: 6,
                      child: Image.asset(b.image, width: 170, fit: BoxFit.contain),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 0, 18),
                      child: SizedBox(
                        width: 190,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(context.tr(b.tag),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(height: 10),
                              Text(context.tr(b.title),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      height: 1.25,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Text(context.tr(b.subtitle),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                              const SizedBox(height: 12),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(context.t('shop_now'),
                                    style: TextStyle(
                                        color: b.colors.first,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < Brand.banners.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _i == i ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
                color: _i == i ? Brand.primary : Brand.primary.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4)),
          ),
      ]),
    ]);
  }
}
